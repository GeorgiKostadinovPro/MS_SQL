-- Part I - Queries for Bank Database
USE Bank

-- 01. Create Table Logs
CREATE TABLE Logs
(
LogId INT PRIMARY KEY IDENTITY NOT NULL,
AccountId INT NOT NULL,
OldSum MONEY NOT NULL,
NewSum MONEY NOT NULL

CONSTRAINT FK_Logs_Accounts
FOREIGN KEY (AccountId) REFERENCES Accounts(Id)
)

GO
CREATE TRIGGER tr_AddToLogsOnAccountUpdate
ON Accounts FOR UPDATE
AS
BEGIN
   INSERT INTO Logs(AccountId, OldSum, NewSum)
   SELECT i.Id, d.Balance, i.Balance FROM inserted AS i
   INNER JOIN deleted AS d ON i.AccountHolderId = d.AccountHolderId
   WHERE i.Balance <> d.Balance
END
GO

-- 2. Create Table Emails
CREATE TABLE NotificationEmails
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Recipient INT NOT NULL,
[Subject] NVARCHAR(MAX) NOT NULL,
Body NVARCHAR(MAX) NOT NULL

CONSTRAINT FK_NotificationEmails_Accounts
FOREIGN KEY (Recipient) REFERENCES Accounts(Id)
)

GO
CREATE TRIGGER tr_AddToNotificationEmailsONLogsInsert
ON Logs FOR INSERT
AS
BEGIN
   INSERT INTO NotificationEmails(Recipient, [Subject], Body)
   SELECT TOP 1
      i.AccountId, 
      CONCAT('Balance change for account: ', i.AccountId) AS [Subject],
	  CONCAT('On ', GETDATE(), ' your balance was changed from ',
	  i.OldSum, ' to ', i.NewSum, '.') AS Body
   FROM inserted AS i
END
GO

-- 03. Deposit Money
GO
CREATE PROC usp_DepositMoney @AccountId INT, @MoneyAmount MONEY
AS
BEGIN
   DECLARE @AccountIdToGet INT = (
                                   SELECT Id FROM Accounts
								   WHERE Id = @AccountId
                                 )

   IF (@AccountIdToGet IS NULL)
   BEGIN
      RETURN;
   END

   IF (@MoneyAmount <= 0)
   BEGIN
      RETURN;
   END

   UPDATE Accounts
   SET Balance = Balance + @MoneyAmount
   WHERE Id = @AccountId
END
GO

EXEC dbo.usp_DepositMoney 1, 10

-- 04. Withdraw Money Procedure
GO
CREATE PROC usp_WithdrawMoney @AccountId INT, @MoneyAmount MONEY
AS
BEGIN
   DECLARE @AccountIdToGet INT = (
                                   SELECT Id FROM Accounts
								   WHERE Id = @AccountId
                                 )

   IF (@AccountIdToGet IS NULL)
   BEGIN
      RETURN;
   END

   IF (@MoneyAmount <= 0)
   BEGIN
      RETURN;
   END

   UPDATE Accounts
   SET Balance = Balance - @MoneyAmount
   WHERE Id = @AccountId
END
GO

EXEC dbo.usp_WithdrawMoney 5, 25

-- 05. Money Transfer
GO
CREATE PROC usp_TransferMoney @SenderId INT, @ReceiverId INT, @Amount MONEY
AS
BEGIN
   DECLARE @SenderIdToGet INT = (
                                  SELECT Id FROM Accounts
								  WHERE Id = @SenderId
                                )

   DECLARE @ReceiverIdToGet INT = (
                                    SELECT Id FROM Accounts
                                    WHERE Id = @ReceiverId
                                  )

   IF (@SenderIdToGet IS NULL
   OR @ReceiverIdToGet IS NULL
   OR @SenderIdToGet = @ReceiverIdToGet)
   BEGIN
      RETURN;
   END

   DECLARE @SenderBalance MONEY = (
                                    SELECT Balance FROM Accounts
								    WHERE Id = @SenderId
                                  )

   IF (@Amount <= 0 OR @SenderBalance < @Amount)
   BEGIN
      RETURN;
   END

   EXEC dbo.usp_WithdrawMoney @SenderId, @Amount
   EXEC dbo.usp_DepositMoney @ReceiverId, @Amount
END
GO

EXEC dbo.usp_TransferMoney 5, 1, 5000