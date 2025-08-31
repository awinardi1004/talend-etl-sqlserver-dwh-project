CREATE DATABASE DWH;
GO

USE DWH;


CREATE TABLE DimCustomer (
	CustomerID INT PRIMARY KEY,
	CustomerName VARCHAR(100),
	Address VARCHAR(200),
	CityName VARCHAR(25),
	StateName VARCHAR(30),
	Age INT,
	Gender VARCHAR(20),
	Email VARCHAR(100)
);

CREATE TABLE DimAccount (
	AccountID INT PRIMARY KEY,
	CustomerID INT,
	AccountType VARCHAR(20),
	Balance DECIMAL(18,2),
	DateOpened DATETIME2,
	Status Varchar(20),
	CONSTRAINT FK_Account_Customer FOREIGN KEY (CustomerID) 
      REFERENCES DimCustomer(CustomerID)
);


CREATE TABLE DimBranch (
	BranchID INT PRIMARY KEY,
	BranchName VARCHAR(50),
	BranchLocation VARCHAR(100)
);

CREATE TABLE FactTransaction (
	TransactionID INT PRIMARY KEY,
	AccountID INT NOT NULL,
	BranchID INT,
	TransactionDate DATETIME2(0),
	Amount DECIMAL(18,2),
	TransactionType VARCHAR(50),
	CONSTRAINT FK_Fact_Account FOREIGN KEY (AccountID) REFERENCES DimAccount(AccountID),
	CONSTRAINT FK_Fact_Branch FOREIGN KEY (BranchID) REFERENCES DimBranch(BranchID)
);