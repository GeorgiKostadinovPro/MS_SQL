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