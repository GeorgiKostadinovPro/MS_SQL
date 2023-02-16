-- Part I – Queries for SoftUni Database
USE SoftUni

-- 01. Employees with Salary Above 35000
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
BEGIN
   SELECT FirstName, LastName FROM Employees
   WHERE Salary > 35000
END

EXEC dbo.usp_GetEmployeesSalaryAbove35000

-- 02. Employees with Salary Above Number
CREATE PROC usp_GetEmployeesSalaryAboveNumber @Number DECIMAL(18, 4)
AS
BEGIN
   SELECT FirstName, LastName FROM Employees
   WHERE Salary >= @Number
END

EXEC dbo.usp_GetEmployeesSalaryAboveNumber 48100

-- 03. Town Names Starting With
CREATE PROC usp_GetTownsStartingWith @StartingString VARCHAR(50)
AS
BEGIN
   SELECT [Name] FROM Towns
   WHERE LOWER([Name]) LIKE CONCAT(LOWER(@StartingString), '%')
END

EXEC dbo.usp_GetTownsStartingWith 'b'

-- 04. Employees from Town
CREATE PROC usp_GetEmployeesFromTown @TownName VARCHAR(50)
AS
BEGIN
   SELECT FirstName, LastName FROM Employees
   WHERE AddressID IN (
                         SELECT AddressID FROM Addresses
						 WHERE TownID IN (
						                    SELECT TownID FROM Towns
											WHERE [Name] = @TownName
										 )
					  )
END

EXEC dbo.usp_GetEmployeesFromTown 'Sofia'

-- 05. Salary Level Function
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(10) AS
BEGIN
   DECLARE @SalaryLevel VARCHAR(10) = 'Average';

   IF (@salary < 30000)
   BEGIN
      SET @SalaryLevel = 'Low';
   END
   ELSE IF (@salary > 50000)
   BEGIN
      SET @SalaryLevel = 'High';
   END

   RETURN @SalaryLevel;
END

SELECT Salary, dbo.ufn_GetSalaryLevel(Salary) FROM Employees

-- 06. Employees by Salary Level
CREATE PROC usp_EmployeesBySalaryLevel @SalaryLevel VARCHAR(10)
AS
BEGIN
   SELECT FirstName, LastName FROM Employees
   WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel
END

EXEC dbo.usp_EmployeesBySalaryLevel 'High'

-- 07. Define Function
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX))
RETURNS BIT AS
BEGIN
   DECLARE @WordLength INT = LEN(@word);
   DECLARE @i INT = 1;

   WHILE @i <= @WordLength
   BEGIN
      DECLARE @CharacterPosition INT = CHARINDEX(SUBSTRING(@word, @i, 1), @setOfLetters);
      
      IF (@CharacterPosition = 0)
	  BEGIN
		 RETURN 0;
	  END
	  
	  SET @i = @i + 1;
   END

   RETURN 1;
END

EXEC dbo.ufn_IsWordComprised 'oistmiahf', 'Sofia'

-- 08. *Delete Employees and Departments
CREATE OR ALTER PROC usp_DeleteEmployeesFromDepartment @departmentId INT
AS
BEGIN
   ALTER TABLE Departments
   ALTER COLUMN ManagerID INT NULL

   DELETE FROM EmployeesProjects
   WHERE EmployeeID IN (
                          SELECT EmployeeID FROM Employees
						  WHERE DepartmentID = @departmentId
                       )

   UPDATE Departments
   SET ManagerID = NULL
   WHERE DepartmentID = @departmentId

   UPDATE Employees
   SET ManagerID = NULL
   WHERE DepartmentID = @departmentId

   ALTER TABLE Employees
   ALTER COLUMN DepartmentID INT NULL

   UPDATE Employees
   SET DepartmentID = NULL
   WHERE DepartmentID = @departmentId

   DELETE FROM Employees
   WHERE DepartmentID = @departmentId

   DELETE FROM Departments
   WHERE DepartmentID = @departmentId

   SELECT COUNT(*) FROM Employees
   WHERE DepartmentID = @departmentId
END

EXEC dbo.usp_DeleteEmployeesFromDepartment 1

GO