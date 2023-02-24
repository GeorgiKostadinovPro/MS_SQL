USE NationalTouristSitesOfBulgaria

-- 05. Tourists
SELECT
   [Name],
   Age,
   PhoneNumber,
   Nationality
FROM Tourists
ORDER BY Nationality ASC,
         Age DESC,
		 [Name] ASC

-- 06. Sites with Their Location and Category
SELECT
   s.[Name],
   l.[Name] AS [Location],
   s.Establishment,
   c.[Name]
FROM Sites AS s
INNER JOIN Locations AS l ON s.LocationId = l.Id
INNER JOIN Categories AS c ON s.CategoryId = c.Id
ORDER BY c.[Name] DESC,
         l.[Name] ASC,
		 s.[Name] ASC

-- 07. Count of Sites in Sofia Province
SELECT
   l.Province,
   l.Municipality,
   l.[Name] AS [Location],
   COUNT(s.Id) AS CountOfSites
FROM Sites AS s
INNER JOIN Locations AS l ON s.LocationId = l.Id
WHERE l.Province = 'Sofia'
GROUP BY l.[Name], l.Province, l.Municipality
ORDER BY CountOfSites DESC,
         [Location] ASC 

-- 08. Tourist Sites established BC
SELECT
   s.[Name] AS [Site],
   l.[Name] AS [Location],
   l.Municipality,
   l.Province,
   s.Establishment
FROM Sites AS s
INNER JOIN Locations AS l ON s.LocationId = l.Id
WHERE LEFT(l.[Name], 1) NOT IN ('B', 'M', 'D')
      AND s.Establishment LIKE '%BC'
ORDER BY [Site] ASC

-- 09. Tourists with their Bonus Prizes
SELECT
   t.[Name],
   t.Age,
   t.PhoneNumber,
   t.Nationality,
   ISNULL(bp.[Name], '(no bonus prize)') AS Reward
FROM Tourists AS t
LEFT JOIN TouristsBonusPrizes AS tbp ON t.Id = tbp.TouristId
LEFT JOIN BonusPrizes AS bp ON tbp.BonusPrizeId = bp.Id
ORDER BY t.[Name] ASC

-- 10. Tourists visiting History & Archaeology sites
SELECT
   SUBSTRING(t.[Name], CHARINDEX(' ', t.[Name]) + 1, LEN(t.[Name]) - CHARINDEX(' ', t.[Name])) AS LastName,
   t.Nationality,
   t.Age,
   t.PhoneNumber
FROM Tourists AS t
INNER JOIN SitesTourists AS st ON t.Id = st.TouristId
INNER JOIN Sites AS s ON st.SiteId = s.Id
INNER JOIN Categories AS c ON s.CategoryId = c.Id
WHERE c.[Name] = 'History and archaeology'
GROUP BY t.[Name], t.Nationality, t.Age, t.PhoneNumber
ORDER BY LastName ASC