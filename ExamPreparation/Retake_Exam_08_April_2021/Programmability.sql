USE [Service]

-- 11. Hours to Complete
GO

CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT AS
BEGIN
   IF (@StartDate IS NULL OR @EndDate IS NULL)
   BEGIN
      RETURN 0;
   END

   DECLARE @Result INT = DATEDIFF(HOUR, @StartDate, @EndDate);

   RETURN @Result;
END

GO

SELECT 
   dbo.udf_HoursToComplete(OpenDate, CloseDate) AS TotalHours 
FROM Reports

-- 12. Assign Employee
GO

CREATE PROC usp_AssignEmployeeToReport @EmployeeId INT, @ReportId INT
AS
BEGIN
   DECLARE @EmployeeDepartmentId INT = (
                                         SELECT DepartmentId FROM Employees
									     WHERE Id = @EmployeeId
                                       )

   DECLARE @ReportDepartmentId INT = (
                                       SELECT c.DepartmentId FROM Reports AS r
									   INNER JOIN Categories AS c ON r.CategoryId = c.Id
								       WHERE r.Id = @ReportId
                                     )

   IF (@EmployeeDepartmentId IS NULL
       OR @EmployeeDepartmentId != @ReportDepartmentId)
	BEGIN
	   THROW 51000, 'Employee doesn''t belong to the appropriate department!', 1
	END

	BEGIN TRANSACTION
	   UPDATE Reports
	   SET EmployeeId = @EmployeeId
	   WHERE Id = @ReportId
	COMMIT
END

GO

EXEC dbo.usp_AssignEmployeeToReport 30, 1 

EXEC usp_AssignEmployeeToReport 17, 2 