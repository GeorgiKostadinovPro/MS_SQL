-- Part II - Queries for Diablo Database
USE Diablo

-- 06. *Massive Shopping
GO

CREATE PROC usp_BuyItemsWithLevels 
AS
BEGIN
   DECLARE @UserId INT = ( 
                           SELECT Id FROM Users
						   WHERE FirstName = 'Stamat'
                         )

   DECLARE @GameId INT = ( 
                           SELECT Id FROM Games
						   WHERE [Name] = 'Safflower'
                         )
   /*
   Stamat id = 9
   Safflower id = 87
   */		

   DECLARE @UserGameId INT = ( 
                               SELECT Id FROM UsersGames
						       WHERE UserId = @UserId AND GameId = @GameId
                             )

   DECLARE @UserGameCash MONEY = (
                                   SELECT Cash FROM UsersGames
						           WHERE Id = @UserGameId
                                 )

   DECLARE @TotalCostOfGamesBetweenLevels11And12 MONEY = (
                                                           SELECT SUM(Price) FROM Items
														   WHERE MinLevel BETWEEN 11 AND 12
                                                         )

   IF (@UserGameCash >= @TotalCostOfGamesBetweenLevels11And12)
   BEGIN
      BEGIN TRANSACTION
	  UPDATE UsersGames
	  SET Cash = Cash - @TotalCostOfGamesBetweenLevels11And12
	  WHERE Id = @UserGameId

	  INSERT INTO UserGameItems(ItemId, UserGameId)
	  SELECT Id, @UserGameId FROM Items
	  WHERE MinLevel BETWEEN 11 AND 12
	  COMMIT
   END

   DECLARE @UserGameCashAfterBuyingItemsBetweenLevels11And12 MONEY = (
                                                                       SELECT Cash FROM UsersGames
						                                               WHERE Id = @UserGameId
                                                                     )

   DECLARE @TotalCostOfGamesBetweenLevels19And21 MONEY = (
                                                           SELECT SUM(Price) FROM Items
														   WHERE MinLevel BETWEEN 19 AND 21
                                                         )

   IF (@UserGameCashAfterBuyingItemsBetweenLevels11And12 >= @TotalCostOfGamesBetweenLevels19And21)
   BEGIN
      BEGIN TRANSACTION
	  UPDATE UsersGames
	  SET Cash = Cash - @TotalCostOfGamesBetweenLevels19And21
	  WHERE Id = @UserGameId

	  INSERT INTO UserGameItems(ItemId, UserGameId)
	  SELECT Id, @UserGameId FROM Items
	  WHERE MinLevel BETWEEN 19 AND 21
	  COMMIT
   END

   SELECT i.[Name] FROM UserGameItems AS ugi
   INNER JOIN Items AS i ON ugi.ItemId = i.Id
   WHERE ugi.UserGameId = @UserGameId
   ORDER BY [Name] ASC
END

GO

EXEC dbo.usp_BuyItemsWithLevels