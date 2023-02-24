-- 11. Tourists Count on a Tourist Site
GO

CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site VARCHAR(100))
RETURNS INT AS
BEGIN
   DECLARE @Result INT = (
                           SELECT COUNT(st.TouristId) FROM Sites AS s
						   INNER JOIN SitesTourists AS st ON s.Id = st.SiteId
						   WHERE s.[Name] = @Site
                         )

   RETURN @Result;
END

GO

SELECT dbo.udf_GetTouristsCountOnATouristSite ('Regional History Museum – Vratsa')

-- 12. Annual Reward Lottery
GO

CREATE PROC usp_AnnualRewardLottery @TouristName VARCHAR(50)
AS
BEGIN
   DECLARE @CountOfVisitedSites INT = (
                                        SELECT COUNT(st.SiteId) FROM Tourists AS t
						                INNER JOIN SitesTourists AS st ON t.Id = st.TouristId
						                WHERE t.[Name] = @TouristName
                                      )
									  
   IF (@CountOfVisitedSites >= 25 AND @CountOfVisitedSites < 50)
   BEGIN
      BEGIN TRANSACTION
	     UPDATE Tourists
	     SET Reward = 'Bronze badge'
	  COMMIT
   END
   ELSE IF (@CountOfVisitedSites >= 50 AND @CountOfVisitedSites < 100)
   BEGIN
      BEGIN TRANSACTION
	     UPDATE Tourists
	     SET Reward = 'Silver badge'
	  COMMIT
   END
   ELSE IF (@CountOfVisitedSites >= 100)
   BEGIN
   BEGIN TRANSACTION
	     UPDATE Tourists
	     SET Reward = 'Gold badge'
	  COMMIT
   END

   SELECT [Name], Reward FROM Tourists
   WHERE [Name] = @TouristName
END

GO

EXEC dbo.usp_AnnualRewardLottery 'Gerhild Lutgard' 