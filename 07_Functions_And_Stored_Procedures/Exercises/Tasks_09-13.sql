-- Part II – Queries for Bank Database
USE Bank

GO

-- 09. Find Full Name
CREATE OR ALTER PROC usp_GetHoldersFullName
AS
BEGIN
   SELECT CONCAT_WS(' ', FirstName, LastName) AS [Full Name] FROM AccountHolders
END

EXEC dbo.usp_GetHoldersFullName

GO

-- 10. People with Balance Higher Than
CREATE PROC usp_GetHoldersWithBalanceHigherThan @Number DECIMAL(18, 4)
AS
BEGIN 
   SELECT FirstName, LastName FROM
   (
      SELECT ah.FirstName, ah.LastName, SUM(a.Balance) AS TotalBalanceForSingleAccount FROM AccountHolders AS ah
      INNER JOIN Accounts AS a ON ah.Id = a.AccountHolderId
      GROUP BY ah.Id, ah.FirstName, ah.LastName
   ) AS GetTotalBalanceForSingleAccountSubquery
   WHERE TotalBalanceForSingleAccount > @Number
   ORDER BY FirstName ASC, LastName ASC
END

EXEC dbo.usp_GetHoldersWithBalanceHigherThan 35000

-- 11. Future Value Function
CREATE FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(18, 4), @yearly  FLOAT, @numberOfYears INT)
RETURNS DECIMAL(18, 4) AS
BEGIN
   DECLARE @Result DECIMAL(18, 4) = @sum * (POWER((1 + @yearly), @numberOfYears));

   RETURN @Result;
END

EXEC dbo.ufn_CalculateFutureValue 1000, 0.1, 5

-- 12. Calculating Interest
CREATE PROC usp_CalculateFutureValueForAccount @AccountId INT, @InterestRate FLOAT
AS
BEGIN
   SELECT 
      ah.Id, 
	  ah.FirstName, 
	  ah.LastName, 
	  a.Balance AS [Current Balance],
	  dbo.ufn_CalculateFutureValue(a.Balance, @InterestRate, 5) AS [Balance in 5 years]
   FROM AccountHolders AS ah
   INNER JOIN Accounts AS a ON ah.Id = a.AccountHolderId
   WHERE a.Id = @AccountId
END

EXEC dbo.usp_CalculateFutureValueForAccount 1, 0.1

GO

-- Part III – Queries for Diablo Database
USE Diablo

-- 13. *Cash in User Games Odd Rows
CREATE FUNCTION ufn_CashInUsersGames(@GameName NVARCHAR(50))
RETURNS TABLE AS
RETURN
   SELECT SUM(Cash) AS SumCash FROM
   (
      SELECT
         g.[Name],
         ug.Cash,
         ROW_NUMBER() OVER
         (ORDER BY ug.Cash DESC)
         AS RowNumber
      FROM UsersGames AS ug
      INNER JOIN Games AS g ON ug.GameId = g.Id
      WHERE [Name] = @GameName
   ) AS GetRowNumbersSubquery
   WHERE RowNumber % 2 <> 0

SELECT * FROM dbo.ufn_CashInUsersGames('Love in a mist')