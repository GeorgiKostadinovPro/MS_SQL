USE Boardgames

-- 05. Boardgames by Year of Publication
SELECT
   [Name],
   Rating
FROM Boardgames
ORDER BY YearPublished ASC,
         [Name] DESC

-- 06. Boardgames by Category
SELECT
   b.Id,
   b.[Name],
   b.YearPublished,
   c.[Name] AS CategoryName
FROM Boardgames AS b
INNER JOIN Categories AS c ON b.CategoryId = c.Id
WHERE c.[Name] IN ('Strategy Games', 'Wargames')
ORDER BY b.YearPublished DESC

-- 07. Creators without Boardgames
SELECT
   Id,
   CONCAT(FirstName, ' ', LastName) AS CreatorName,
   Email
FROM Creators
WHERE Id NOT IN (
                  SELECT CreatorId FROM CreatorsBoardgames
                )
ORDER BY CreatorName ASC

-- 08. First 5 Boardgames
SELECT TOP 5
   b.[Name],
   b.Rating,
   c.[Name] AS CategoryName
FROM Boardgames AS b
INNER JOIN Categories AS c ON b.CategoryId = c.Id
WHERE (b.Rating > 7.00 AND b.[Name] LIKE '%a%')
      OR 
	  (b.Rating > 7.50 AND b.PlayersRangeId IN ( 
	                                         SELECT Id FROM PlayersRanges
											 WHERE PlayersMin = 2 AND PlayersMax = 5
	                                       )
	  )
ORDER BY b.[Name] ASC,
         b.Rating DESC

-- 09. Creators with Emails
SELECT
   CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
   c.Email,
   MAX(b.Rating) AS Rating
FROM Creators AS c
INNER JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
INNER JOIN Boardgames AS b ON cb.BoardgameId = b.Id
WHERE c.Email LIKE '%.com'
GROUP BY c.FirstName, c.LastName, c.Email
ORDER BY FullName ASC

-- 10. Creators by Rating
SELECT
  c.LastName,
  CEILING(AVG(b.Rating)) AS AverageRating,
  p.[Name] AS PublisherName
FROM Creators AS c
INNER JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
INNER JOIN Boardgames AS b ON cb.BoardgameId = b.Id
INNER JOIN Publishers AS p ON b.PublisherId = p.Id
WHERE p.[Name] = 'Stonemaier Games'
GROUP BY c.LastName, p.[Name]
ORDER BY AVG(b.Rating) DESC