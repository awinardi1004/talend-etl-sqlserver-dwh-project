USE DWH;
GO

--DailyTransaction
CREATE OR ALTER PROCEDURE dbo.DailyTransaction
  @start_date DATE,
  @end_date   DATE
AS
BEGIN
  SET NOCOUNT ON;
  SELECT
    CAST(TransactionDate AS DATE) AS [Date],
    COUNT(*)                      AS TotalTransactions,
    SUM(Amount)                   AS TotalAmount
  FROM FactTransaction
  WHERE TransactionDate >= @start_date
    AND TransactionDate <  DATEADD(DAY, 1, @end_date)
  GROUP BY CAST(TransactionDate AS DATE)
  ORDER BY [Date];
END;

-- BalancePerCustomer
CREATE OR ALTER PROCEDURE dbo.BalancePerCustomer
  @name VARCHAR(200)
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH Tx AS (
    SELECT
      a.AccountID,
      SUM(CASE WHEN ft.TransactionType = 'Deposit' THEN ft.Amount ELSE -ft.Amount END) AS NetTx
    FROM DimAccount a
    LEFT JOIN FactTransaction ft ON ft.AccountID = a.AccountID
    GROUP BY a.AccountID
  )
  SELECT
    dc.CustomerName,
    a.AccountType,
    a.Balance,
    (a.Balance + ISNULL(tx.NetTx,0)) AS CurrentBalance
  FROM DimAccount a
  JOIN DimCustomer dc ON dc.CustomerID = a.CustomerID
  LEFT JOIN Tx tx ON tx.AccountID = a.AccountID
  WHERE a.[Status] = 'active'
    AND dc.CustomerName = @name
  ORDER BY a.AccountType;
END;