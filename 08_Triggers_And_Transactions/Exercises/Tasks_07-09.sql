-- Part III - Queries for SoftUni Database
USE SoftUni

-- 07. Employees with Three Projects
GO

CREATE PROC usp_AssignProject @emloyeeId INT, @projectID INT
AS
BEGIN
   DECLARE @EmployeeProjectsCount INT = (
                                          SELECT COUNT(*) FROM EmployeesProjects
										  WHERE EmployeeID = @emloyeeId
                                        )

   BEGIN TRANSACTION
      IF (@EmployeeProjectsCount >= 3)
	  BEGIN
	     ROLLBACK;
	     THROW 50002, 'The employee has too many projects!', 1
	  END

	  INSERT INTO EmployeesProjects(EmployeeID, ProjectID)
	  VALUES (@emloyeeId, @projectID)
   COMMIT
END

GO

EXEC dbo.usp_AssignProject 1, 1

-- 09. Delete Employees
CREATE TABLE Deleted_Employees
(
	EmployeeId INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	MiddleName VARCHAR(50),
	JobTitle VARCHAR(150) NOT NULL,
	DepartmentId INT NOT NULL,
	Salary MONEY NOT NULL

	CONSTRAINT FK_Deleted_Employees_Departments
	FOREIGN KEY (DepartmentId) REFERENCES Departments(DepartmentID)
)

GO 

CREATE TRIGGER tr_AddToDeleted_EmployeesOnEmployeesDelete
ON Employees FOR DELETE
AS
BEGIN
    INSERT INTO Deleted_Employees(FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary)
	SELECT
	   d.FirstName, 
	   d.LastName, 
	   d.MiddleName,
	   d.JobTitle,
	   d.DepartmentID,
	   d.Salary
	FROM deleted AS d
END

GO