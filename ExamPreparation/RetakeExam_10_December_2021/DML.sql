USE Airport

-- 02. Insert
INSERT INTO Passengers(FullName, Email)
SELECT
   CONCAT_WS(' ', FirstName, LastName) AS FullName,
   CONCAT(FirstName, LastName, '@gmail.com') AS Email
FROM Pilots
WHERE Id BETWEEN 5 AND 15

-- 03. Update
UPDATE Aircraft
SET Condition = 'A'
WHERE Condition IN ('C', 'B')
      AND (FlightHours IS NULL OR FlightHours <= 100)
	  AND [Year] >= 2013

-- 04. Delete
DELETE FROM FlightDestinations
WHERE PassengerId IN (
                       SELECT Id FROM Passengers
					   WHERE LEN(FullName) <= 10
                     )

DELETE FROM Passengers
WHERE LEN(FullName) <= 10