-- Part II – Queries for SoftUni Database
USE SoftUni

-- 13. Departments Total Salaries
SELECT DepartmentID, SUM(Salary) AS TotalSalary FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID ASC

-- 14. Employees Minimum Salaries
SELECT DepartmentID, MIN(Salary) AS MinimumSalary FROM Employees
WHERE DepartmentID IN (2, 5, 7) AND HireDate > CONVERT(DATETIME2, '2000-01-01')
GROUP BY DepartmentID

-- 15. Employees Average Salaries
SELECT * INTO AverageSalaries FROM Employees
WHERE Salary > 30000

DELETE FROM AverageSalaries
WHERE ManagerID = 42

UPDATE AverageSalaries
SET Salary = Salary + 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS AverageSalary FROM AverageSalaries
GROUP BY DepartmentID

-- 16. Employees Maximum Salaries
SELECT DepartmentID, MAX(Salary) AS MaxSalary FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-- 17. Employees Count Salaries
SELECT COUNT(*) AS [Count] FROM Employees AS e
WHERE ManagerID IS NULL

-- 18. *3rd Highest Salary
SELECT DepartmentID, Salary AS ThirdHighestSalary FROM
(
   SELECT 
      *, 
      DENSE_RANK() OVER
      (PARTITION BY DepartmentID ORDER BY Salary DESC)
      AS SalaryRank
   FROM Employees
) AS RankingBySalarySubquery
WHERE SalaryRank = 3
GROUP BY DepartmentID, Salary

-- Solution using DISTINCT function
SELECT DISTINCT DepartmentID, Salary AS ThirdHighestSalary FROM
(
   SELECT 
      *, 
      DENSE_RANK() OVER
      (PARTITION BY DepartmentID ORDER BY Salary DESC)
      AS SalaryRank
   FROM Employees
) AS RankingBySalarySubquery
WHERE SalaryRank = 3

-- 19. **Salary Challenge
SELECT TOP 10 FirstName, LastName, DepartmentID FROM Employees AS e
WHERE Salary > (
                  SELECT AVG(Salary) FROM Employees AS se
                  WHERE e.DepartmentID = se.DepartmentID
               )
ORDER BY DepartmentID ASC
