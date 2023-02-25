USE Zoo

-- 05. Volunteers
SELECT 
       [Name], 
       PhoneNumber, 
       [Address], 
       AnimalId, 
       DepartmentId 
FROM Volunteers
ORDER BY [Name] ASC,
         AnimalId ASC,
		 DepartmentId ASC

-- 06. Animals data
SELECT 
   a.[Name], 
   [at].AnimalType, 
   FORMAT(a.BirthDate, 'dd.MM.yyyy') AS BirthDate
FROM Animals AS a
INNER JOIN AnimalTypes AS [at] ON a.AnimalTypeId = [at].Id
ORDER BY a.[Name] ASC
 
-- 07. Owners and Their Animals
SELECT TOP 5 
   o.[Name] AS [Owner], 
   COUNT(a.Id) AS CountOfAnimals 
FROM Owners AS o
INNER JOIN Animals AS a ON o.Id = a.OwnerId
GROUP BY o.[Name]
ORDER BY CountOfAnimals DESC

-- 08. Owners, Animals and Cages
SELECT
   CONCAT_WS('-', o.[Name], a.[Name]) AS OwnersAnimals,
   o.PhoneNumber,
   ac.CageId
FROM Owners AS o
INNER JOIN Animals AS a ON o.Id = a.OwnerId
INNER JOIN AnimalsCages AS ac ON a.Id = ac.AnimalId
INNER JOIN AnimalTypes AS [at] ON a.AnimalTypeId = [at].Id
WHERE [at].AnimalType = 'Mammals'
ORDER BY o.[Name] ASC,
         a.[Name] DESC

-- 09. Volunteers in Sofia
SELECT 
   [Name], 
   PhoneNumber,
   SUBSTRING([Address], CHARINDEX(',', [Address]) + 1, LEN([Address]) - CHARINDEX(',', [Address]))
   AS [Address]
FROM Volunteers
WHERE [Address] LIKE '%Sofia%' AND DepartmentId IN (
                                                     SELECT Id FROM VolunteersDepartments
						                             WHERE DepartmentName = 'Education program assistant'
                                                   )
ORDER BY [Name] ASC

-- 10. Animals for Adoption
SELECT
   a.[Name],
   YEAR(a.BirthDate) AS BirthYear,
   [at].AnimalType
FROM Animals AS a
INNER JOIN AnimalTypes AS [at] ON a.AnimalTypeId = [at].Id
WHERE a.OwnerId IS NULL AND [at].AnimalType <> 'Birds' 
      AND DATEDIFF(YEAR, a.BirthDate, '2022-01-01') < 5
ORDER BY a.[Name] ASC