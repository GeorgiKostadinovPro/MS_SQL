USE Airport

-- 05. Aircraft
SELECT
   Manufacturer,
   Model,
   FlightHours,
   Condition
FROM Aircraft
ORDER BY FlightHours DESC

-- 06. Pilots and Aircraft
SELECT
   p.FirstName,
   p.LastName,
   a.Manufacturer,
   a.Model,
   a.FlightHours
FROM Pilots AS p
INNER JOIN PilotsAircraft AS pa ON p.Id = pa.PilotId
INNER JOIN Aircraft AS a ON pa.AircraftId = a.Id
WHERE a.FlightHours <= 304
ORDER BY a.FlightHours DESC,
         p.FirstName ASC

-- 07. Top 20 Flight Destinations
SELECT TOP 20
   fd.Id AS DestinationId,
   fd.[Start],
   p.FullName,
   a.AirportName,
   fd.TicketPrice
FROM FlightDestinations AS fd
INNER JOIN Passengers AS p ON fd.PassengerId = p.Id
INNER JOIN Airports AS a ON fd.AirportId = a.Id
WHERE DAY([Start]) % 2 = 0
ORDER BY fd.TicketPrice DESC,
         a.AirportName ASC

-- 08. Number of Flights for Each Aircraft
SELECT
   a.Id AS AircraftId,
   a.Manufacturer,
   a.FlightHours,
   COUNT(fd.Id) AS FlightDestinationsCount,
   ROUND(AVG(fd.TicketPrice), 2) AS AvgPrice
FROM Aircraft AS a
INNER JOIN FlightDestinations AS fd ON a.Id = fd.AircraftId
GROUP BY a.Id, a.Manufacturer, a.FlightHours
HAVING COUNT(fd.Id) >= 2
ORDER BY FlightDestinationsCount DESC,
         a.Id ASC

-- 09. Regular Passengers
SELECT 
   p.FullName,
   COUNT(fd.AircraftId) AS CountOfAircraft,
   SUM(fd.TicketPrice) AS TotalPayed
FROM Passengers AS p
INNER JOIN FlightDestinations AS fd ON p.Id = fd.PassengerId
WHERE SUBSTRING(p.FullName, 2, 1) = 'a'
GROUP BY p.FullName
HAVING COUNT(fd.AircraftId) > 1
ORDER BY P.FullName ASC

-- 10. Full Info for Flight Destinations
SELECT
   a.AirportName,
   fd.[Start] AS DayTime,
   fd.TicketPrice,
   p.FullName,
   ac.Manufacturer,
   ac.Model
FROM FlightDestinations AS fd
INNER JOIN Airports AS a ON fd.AirportId = a.Id
INNER JOIN Passengers AS p ON fd.PassengerId = p.Id
INNER JOIN Aircraft AS ac ON fd.AircraftId = ac.Id
WHERE DATEPART(HOUR, (fd.[Start])) BETWEEN 6 AND 20 
      AND fd.TicketPrice > 2500
ORDER BY ac.Model ASC