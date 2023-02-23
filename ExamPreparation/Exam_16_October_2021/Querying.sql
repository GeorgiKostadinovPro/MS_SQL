USE CigarShop

-- 05. Cigars by Price
SELECT 
   CigarName, 
   PriceForSingleCigar, 
   ImageURL 
FROM Cigars
ORDER BY PriceForSingleCigar ASC,
         CigarName DESC

-- 06. Cigars by Taste 
SELECT 
   c.Id, 
   c.CigarName, 
   c.PriceForSingleCigar,
   t.TasteType,
   t.TasteStrength
FROM Cigars AS c
INNER JOIN Tastes AS t ON c.TastId = t.Id
WHERE t.TasteType IN ('Earthy', 'Woody')
ORDER BY c.PriceForSingleCigar DESC

-- 07. Clients without Cigars
SELECT 
       Id, 
       CONCAT_WS(' ', FirstName, LastName) AS ClientName, 
       Email
FROM Clients
WHERE Id NOT IN (
                  SELECT ClientId FROM ClientsCigars
                )
ORDER BY ClientName ASC

-- 08. First 5 Cigars
SELECT TOP 5
   CigarName,
   PriceForSingleCigar,
   ImageURL
FROM Cigars
WHERE SizeId IN (
                  SELECT Id FROM Sizes
				  WHERE [Length] >= 12
                )
AND (LOWER(CigarName) LIKE '%ci%' OR PriceForSingleCigar > 50)
AND SizeId IN (
                SELECT Id FROM Sizes
				WHERE RingRange > 2.55
              )
ORDER BY CigarName ASC,
         PriceForSingleCigar DESC

-- Using Joins
SELECT TOP 5
   c.CigarName,
   c.PriceForSingleCigar,
   c.ImageURL
FROM Cigars AS c
INNER JOIN Sizes AS s ON c.SizeId = s.Id
WHERE s.[Length] >= 12 AND (LOWER(c.CigarName) LIKE '%ci%' OR  c.PriceForSingleCigar > 50)
      AND s.RingRange > 2.55
ORDER BY c.CigarName ASC,
         c.PriceForSingleCigar DESC

-- 09. Clients with ZIP Codes 
SELECT 
   FullName,
   Country,
   ZIP,
   CONCAT('$', PriceForSingleCigar) AS CigarPrice
FROM
(
SELECT
   CONCAT_WS(' ', c.FirstName, c.LastName) AS FullName,
   a.Country,
   a.ZIP,
   ci.PriceForSingleCigar,
   DENSE_RANK() OVER
   (PARTITION BY c.Id ORDER BY ci.PriceForSingleCigar DESC)
   AS CigarPriceRank
FROM Clients AS c
INNER JOIN Addresses AS a ON c.AddressId = a.Id
INNER JOIN ClientsCigars AS cc ON c.Id = cc.ClientId
INNER JOIN Cigars AS ci ON cc.CigarId = ci.Id
WHERE TRY_CONVERT(INT, a.ZIP) IS NOT NULL
) AS CigarPriceRankingSubquery
WHERE CigarPriceRank = 1
ORDER BY FullName ASC

-- using group by statement instead of DENSE_RANK() function
SELECT
   CONCAT_WS(' ', c.FirstName, c.LastName) AS FullName,
   a.Country,
   a.ZIP,
   CONCAT('$', MAX(ci.PriceForSingleCigar)) AS CigarPrice
FROM Clients AS c
INNER JOIN Addresses AS a ON c.AddressId = a.Id
INNER JOIN ClientsCigars AS cc ON c.Id = cc.ClientId
INNER JOIN Cigars AS ci ON cc.CigarId = ci.Id
WHERE TRY_CONVERT(INT, a.ZIP) IS NOT NULL
GROUP BY c.FirstName, c.LastName, a.Country, a.ZIP
ORDER BY FullName ASC

-- 10. Cigars by Size 
SELECT 
   c.LastName, 
   AVG(s.[Length]) AS CigarLength,
   CEILING(AVG(s.RingRange)) AS CigarRingRange
FROM Clients AS c
INNER JOIN ClientsCigars AS cc ON c.Id = cc.ClientId
INNER JOIN Cigars AS ci ON cc.CigarId = ci.Id
INNER JOIN Sizes AS s ON  ci.SizeId = s.Id
GROUP BY c.LastName
ORDER BY CigarLength DESC