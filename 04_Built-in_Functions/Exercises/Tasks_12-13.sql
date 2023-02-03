-- Part II – Queries for Geography Database
USE [Geography]

-- 12. Countries Holding 'A' 3 or More Times
SELECT 
   CountryName AS [Country Name], 
   IsoCode AS [ISO Code] 
FROM Countries
WHERE LEN(CountryName) - LEN(REPLACE(CountryName, 'a', '')) >= 3
ORDER BY [ISO Code] ASC

-- 13. Mix of Peak and River Names
SELECT * FROM
(SELECT p.PeakName, r.RiverName,
CASE
WHEN SUBSTRING(p.PeakName, LEN(p.PeakName), 1) = SUBSTRING(r.RiverName, 1, 1)
THEN LOWER(CONCAT(p.PeakName, SUBSTRING(r.RiverName, 2, LEN(r.RiverName) - 1)))
END 
AS Mix
FROM Peaks AS p, Rivers AS r
) AS a
WHERE a.Mix IS NOT NULL
ORDER BY a.Mix ASC