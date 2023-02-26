USE Airport

-- 11. Find all Destinations by Email Address
GO

CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT AS
BEGIN
   DECLARE @Result INT = (
                           SELECT COUNT(fd.Id) FROM Passengers AS p
						   INNER JOIN FlightDestinations AS fd ON p.Id = fd.PassengerId
						   WHERE p.Email = @email
                         )
   RETURN @Result;
END

GO

SELECT dbo.udf_FlightDestinationsByEmail ('PierretteDunmuir@gmail.com')

-- 12. Full Info for Airports
GO

CREATE PROC usp_SearchByAirportName @airportName VARCHAR(70)
AS
BEGIN
   SELECT
      a.AirportName,
	  p.FullName,
	  CASE
	  WHEN fd.TicketPrice <= 400 THEN 'Low'
	  WHEN fd.TicketPrice BETWEEN 401 AND 1500 THEN 'Medium'
	  ELSE 'High'
	  END AS LevelOfTickerPrice,
	  ac.Manufacturer,
	  ac.Condition,
	  [at].TypeName
   FROM Airports AS a
   INNER JOIN FlightDestinations AS fd ON a.Id = fd.AirportId
   INNER JOIN Passengers AS p ON fd.PassengerId = p.Id
   INNER JOIN Aircraft AS ac ON fd.AircraftId = ac.Id
   INNER JOIN AircraftTypes AS [at] ON ac.TypeId = [at].Id
   WHERE AirportName = @airportName
   ORDER BY ac.Manufacturer ASC,
            p.FullName ASC
END

GO

EXEC dbo.usp_SearchByAirportName 'Sir Seretse Khama International Airport' 