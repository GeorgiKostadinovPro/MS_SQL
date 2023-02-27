USE Boardgames

-- 11. Creator with Boardgames
GO

CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(30))
RETURNS INT AS
BEGIN
   DECLARE @Result INT = (
                           SELECT COUNT(cb.BoardgameId) FROM Creators AS c
						   INNER JOIN CreatorsBoardgames AS cb ON c.Id= cb.CreatorId
						   WHERE c.FirstName = @name
                         )

	RETURN @Result;
END

GO

SELECT dbo.udf_CreatorWithBoardgames('Bruno')

-- 12. Search for Boardgame with Specific Category
GO

CREATE PROC usp_SearchByCategory @category VARCHAR(50)
AS
BEGIN
   SELECT
     b.[Name],
	 b.YearPublished,
	 b.Rating,
	 c.[Name] AS CategoryName,
	 p.[Name] AS PublisherName,
	 CONCAT(pr.PlayersMin, ' people') AS MinPlayers,
	 CONCAT(pr.PlayersMax, ' people') AS MaxPlayers
   FROM Boardgames AS b
   INNER JOIN Categories AS c ON b.CategoryId = c.Id
   INNER JOIN Publishers AS p ON b.PublisherId = p.Id
   INNER JOIN PlayersRanges AS pr ON b.PlayersRangeId = pr.Id
   WHERE c.[Name] = @category
   ORDER BY PublisherName ASC,
            YearPublished DESC
END

GO

EXEC dbo.usp_SearchByCategory 'Wargames' 
