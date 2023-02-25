USE Zoo

-- 11. All Volunteers in a Department
GO

CREATE FUNCTION udf_GetVolunteersCountFromADepartment (@VolunteersDepartment VARCHAR(30))
RETURNS INT AS
BEGIN
   DECLARE @Result INT = (
                           SELECT COUNT(*) FROM Volunteers
						   WHERE DepartmentId IN (
						                            SELECT Id FROM VolunteersDepartments
													WHERE DepartmentName = @VolunteersDepartment
						                         )
                         )

  RETURN @Result;
END

GO

SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant')

-- 12. Animals with Owner or Not
CREATE PROC usp_AnimalsWithOwnersOrNot(@AnimalName VARCHAR(30))
AS
BEGIN
   SELECT a.[Name], ISNULL(o.[Name], 'For adoption') AS OwnersName FROM Animals AS a
   LEFT JOIN Owners AS o ON a.OwnerId = o.Id
   WHERE a.[Name] = @AnimalName
END

EXEC usp_AnimalsWithOwnersOrNot 'Pumpkinseed Sunfish'