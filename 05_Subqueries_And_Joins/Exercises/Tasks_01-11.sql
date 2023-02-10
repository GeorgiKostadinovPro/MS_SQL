-- Part I – Queries for SoftUni Database
USE SoftUni

-- 01. Employee Address
SELECT TOP 5 e.EmployeeID, e.JobTitle, a.AddressID, a.AddressText FROM Employees AS e
INNER JOIN Addresses AS a ON e.AddressID = a.AddressID
ORDER BY e.AddressID ASC

-- 02. Addresses with Towns
SELECT TOP 50 e.FirstName, e.LastName, t.[Name], a.AddressText FROM Employees AS e
INNER JOIN Addresses AS a ON e.AddressID = a.AddressID
INNER JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY e.FirstName ASC,
e.LastName ASC

-- 03. Sales Employees
SELECT e.EmployeeID, e.FirstName, e.LastName, d.[Name] FROM Employees AS e
INNER JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY e.EmployeeID ASC

-- 04. Employee Departments
SELECT TOP 5 e.EmployeeID, e.FirstName, e.Salary, d.[Name] FROM Employees AS e
INNER JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary  > 15000
ORDER BY d.DepartmentID ASC

-- 05. Employees Without Projects
SELECT TOP 3 e.EmployeeID, e.FirstName FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
WHERE ep.ProjectID IS NULL
ORDER BY e.EmployeeID ASC

-- 06. Employees Hired After
SELECT e.FirstName, e.LastName, e.HireDate, d.[Name] FROM Employees AS e
INNER JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate > CONVERT(DATETIME2, '1999-01-01') AND (d.[Name] = 'Sales' OR d.[Name] = 'Finance')
ORDER BY e.HireDate ASC

-- 07. Employees With Project
SELECT TOP 5 e.EmployeeID, e.FirstName, p.[Name] FROM Employees AS e
INNER JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > CONVERT(DATETIME2, '2002-08-13') AND p.EndDate IS NULL
ORDER BY e.EmployeeID ASC

-- 08. Employee 24
SELECT ep.EmployeeID, e.FirstName,
CASE
WHEN YEAR(p.StartDate) >= 2005 THEN NULL
ELSE p.[Name]
END AS ProjectName
FROM Projects AS p
INNER JOIN EmployeesProjects AS ep ON p.ProjectID = ep.ProjectID
INNER JOIN Employees AS e ON ep.EmployeeID = e.EmployeeID
WHERE ep.EmployeeID = 24

-- 09. Employee Manager
SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName FROM Employees AS e
INNER JOIN Employees AS m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID ASC

-- 10. Employees Summary
SELECT TOP 50 e.EmployeeID, CONCAT_WS(' ', e.FirstName, e.LastName) AS EmployeeName, 
CONCAT_WS(' ', m.FirstName, m.LastName) AS ManagerName, d.[Name] FROM Employees AS e
INNER JOIN Employees AS m ON e.ManagerID = m.EmployeeID
INNER JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID ASC

-- 11. Min Average Salary
SELECT TOP 1 AVG(Salary) AS MinAverageSalary FROM Employees
GROUP BY DepartmentID
ORDER BY MinAverageSalary ASC