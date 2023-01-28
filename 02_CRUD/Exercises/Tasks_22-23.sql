-- Part II – Queries for Geography Databas
USE [Geography]

-- 22. All Mountain Peaks
SELECT PeakName FROM Peaks
ORDER BY PeakName ASC

-- 23. Biggest Countries by Population
SELECT TOP 30 CountryName, [Population] FROM Countries
WHERE ContinentCode IN (
                         SELECT ContinentCode FROM Continents
                         WHERE ContinentName = 'Europe'
		       )
ORDER BY [Population] DESC