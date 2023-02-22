USE Bitbucket

-- 05. Commits
SELECT Id, [Message], RepositoryId, ContributorId FROM Commits
ORDER BY Id ASC, 
[Message] DESC,
RepositoryId ASC,
ContributorId ASC

-- 06. Front-end 
SELECT Id, [Name], Size FROM Files
WHERE Size > 1000 AND [Name] LIKE '%html%'
ORDER BY Size DESC,
Id ASC,
[Name] ASC

-- 07. Issue Assignment
SELECT i.Id, u.Username + ' : ' + i.Title As IssueAssignee FROM Issues AS i
JOIN Users As u ON i.AssigneeId = u.Id
ORDER BY i.Id DESC,
IssueAssignee ASC

-- 08. Single Files
SELECT fParents.Id, fParents.[Name], CONCAT(fParents.Size, 'KB') AS Size FROM Files AS fChildren
FULL OUTER JOIN Files As fParents ON fChildren.ParentId = fParents.Id
WHERE fChildren.Id IS NULL
ORDER BY fParents.Id ASC,
fParents.[Name] ASC,
fParents.[Size] DESC

-- 09. Commits in Repositories
SELECT TOP(5) r.Id, r.[Name], COUNT(c.Id) AS Commits FROM Repositories AS r
LEFT JOIN Commits As c ON r.Id = c.RepositoryId
LEFT JOIN RepositoriesContributors AS rc ON r.Id = rc.RepositoryId
GROUP BY r.Id, r.[Name]
ORDER BY Commits DESC,
r.Id ASC,
r.[Name] ASC

-- 10. Average Size
SELECT u.Username, AVG(f.Size) AS Size FROM Users AS u
INNER JOIN Commits AS c ON u.Id = c.ContributorId
INNER JOIN Files AS f ON c.Id = f.CommitId
GROUP BY u.Username
ORDER BY Size DESC,
u.Username ASC