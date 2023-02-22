USE [Service]

--05. Unassigned Reports
SELECT
   r.[Description],
   FORMAT(r.OpenDate, 'dd-MM-yyyy') AS OpenDate
FROM Reports AS r
WHERE r.EmployeeId IS NULL
ORDER BY r.OpenDate ASC,
         r.[Description] ASC

-- 06. Reports & Categories
SELECT
   r.[Description],
   c.[Name] AS CategoryName
FROM Reports AS r
INNER JOIN Categories AS c ON r.CategoryId = c.Id
ORDER BY r.[Description] ASC,
         c.[Name] ASC

-- 07. Most Reported Category
SELECT TOP 5
   c.[Name] AS CategoryName,
   COUNT(r.Id) AS ReportsNumber
FROM Reports AS r
INNER JOIN Categories AS c ON r.CategoryId = c.Id
GROUP BY c.[Name]
ORDER BY ReportsNumber DESC,
         c.[Name] ASC

-- 08. Birthday Report
SELECT
   u.Username,
   c.[Name] AS CategoryName
FROM Reports AS r
INNER JOIN Categories AS c ON r.CategoryId = c.Id
INNER JOIN Users AS u ON r.UserId = u.Id
WHERE DAY(r.OpenDate) = DAY(u.Birthdate)
      AND MONTH(r.OpenDate) = MONTH(u.Birthdate)
ORDER BY u.Username ASC,
         c.[Name] ASC

-- 09. User per Employee
SELECT
   CONCAT_WS(' ', e.FirstName, e.LastName) AS FullName,
   COUNT(r.UserId) AS UsersCount
FROM Reports AS r
RIGHT JOIN Employees AS e ON r.EmployeeId = e.Id
GROUP BY e.FirstName, e.LastName
ORDER BY UsersCount DESC,
         FullName ASC

-- 10. Full Info
SELECT 
   ISNULL(e.FirstName + ' ' + e.LastName, 'None') AS Employee,
   ISNULL(d.[Name], 'None') AS Department,
   c.[Name] AS Category,
   r.[Description],
   FORMAT(r.OpenDate, 'dd.MM.yyyy') AS OpenDate,
   s.[Label] AS [Status],
   ISNULL(u.[Name], 'None') AS [User]
FROM 
Reports AS r
LEFT JOIN Employees AS e ON r.EmployeeId = e.Id
INNER JOIN Categories AS c ON r.CategoryId = c.Id
LEFT JOIN Departments AS d ON e.DepartmentId = d.Id
INNER JOIN Users AS u ON r.UserId = u.Id
INNER JOIN [Status] AS s ON r.StatusId = s.Id
ORDER BY e.FirstName DESC,
         e.LastName DESC,
		 Department ASC,
		 Category ASC,
		 r.[Description] ASC,
		 r.OpenDate ASC,
		 [Status] ASC,
		 [User] ASC