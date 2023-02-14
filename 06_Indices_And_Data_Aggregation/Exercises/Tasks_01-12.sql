-- Part I – Queries for Gringotts Database
USE Gringotts

-- 01. Records’ Count
SELECT COUNT(*) AS [Count] FROM WizzardDeposits

-- 02. Longest Magic Wand
SELECT MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits

-- 03. Longest Magic Wand per Deposit Groups
SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits
GROUP BY DepositGroup

-- 04. Smallest Deposit Group per Magic Wand Size
SELECT TOP 2 DepositGroup FROM
(
   SELECT 
      DepositGroup, 
      AVG(MagicWandSize) AS AverageWandSizePerDepositGroup 
   FROM WizzardDeposits
   GROUP BY DepositGroup
) AS AverageWandSizeSubquery
ORDER BY AverageWandSizePerDepositGroup ASC

-- 05. Deposits Sum
SELECT 
   DepositGroup, 
   SUM(DepositAmount) AS TotalSum 
FROM WizzardDeposits
GROUP BY DepositGroup

-- 06. Deposits Sum for Ollivander Family
SELECT 
   DepositGroup, 
   SUM(DepositAmount) AS TotalSum 
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

-- 07. Deposits Filter
SELECT 
   DepositGroup, 
   SUM(DepositAmount) AS TotalSum 
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

-- 08. Deposit Charge
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator ASC,
DepositGroup ASC

-- 09. Age Groups
SELECT AgeGroup, COUNT(*) AS WizzardCount FROM
( 
   SELECT 
      CASE
      WHEN [Age] BETWEEN 0 AND 10 THEN '[0-10]'
	  WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]'
	  WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]'
	  WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]'
	  WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]'
	  WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]'
      ELSE '[61+]'
      END AS AgeGroup
   FROM WizzardDeposits
) AS AgeGroupsSubquery
GROUP BY AgeGroup

-- 10. First Letter
SELECT * FROM
( 
   SELECT 
      LEFT(FirstName, 1) 
      AS FirstLetter 
   FROM WizzardDeposits
   WHERE DepositGroup = 'Troll Chest'
) AS GetFirstLetterSubquery
GROUP BY FirstLetter
ORDER BY FirstLetter ASC

-- 11. Average Interest
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS AverageInterest FROM WizzardDeposits
WHERE DepositStartDate > CONVERT(DATE, '1985-01-01')
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC,
IsDepositExpired ASC

-- 12. *Rich Wizard, Poor Wizard
SELECT SUM(DepositDifference) AS SumDifference FROM
( 
   SELECT *, (DepositAmount - NextDepositAmount) AS [DepositDifference] FROM
   ( 
      SELECT
         DepositAmount,
         LEAD(DepositAmount, 1) OVER
         (ORDER BY Id ASC)
         AS NextDepositAmount
      FROM WizzardDeposits
   ) AS GetCurrentAndNextWizzardDepositSubquery
) AS GetDepositDifferenceSubquery