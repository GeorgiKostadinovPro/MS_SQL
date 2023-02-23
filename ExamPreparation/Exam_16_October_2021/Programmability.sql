USE CigarShop

-- 11. Client with Cigar
GO

CREATE FUNCTION udf_ClientWithCigars(@name VARCHAR(30))
RETURNS INT AS
BEGIN
   DECLARE @Result INT = (
                           SELECT COUNT(*) FROM Clients AS c
						   INNER JOIN ClientsCigars AS cc ON c.Id = cc.ClientId
						   WHERE c.FirstName = @name
                         )

   RETURN @Result;
END

GO

SELECT dbo.udf_ClientWithCigars('Betty')

-- 12. Search for Cigar with Specific Taste 
GO

CREATE PROC usp_SearchByTaste @taste VARCHAR(20)
AS
BEGIN
   SELECT 
      c.CigarName,
	  CONCAT('$', c.PriceForSingleCigar) AS Price,
	  t.TasteType,
	  b.BrandName,
	  CONCAT_WS(' ', s.[Length], 'cm') AS CigarLength,
	  CONCAT_WS(' ', s.RingRange, 'cm') AS CigarRingRange
   FROM Cigars AS c
   INNER JOIN Tastes AS t ON c.TastId = t.Id
   INNER JOIN Brands AS b ON c.BrandId = b.Id
   INNER JOIN Sizes AS s ON c.SizeId = s.Id
   WHERE t.TasteType = @taste
   ORDER BY s.[Length] ASC,
            s.RingRange DESC
END

GO

EXEC dbo.usp_SearchByTaste 'Woody' 