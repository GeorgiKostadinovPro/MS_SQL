USE Bitbucket

GO
-- 11. All User Commits
CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(30))
RETURNS INT
AS
BEGIN
    DECLARE @userId INT = (
	   SELECT Id FROM Users
	   WHERE Username = @username
    )

    DECLARE @commitsCount INT = (
	   SELECT COUNT(Id) FROM Commits
	   WHERE ContributorId = @userId
	)

	RETURN @commitsCount
END

SELECT dbo.udf_AllUserCommits('UnderSinduxrein')

GO
-- 12. Search for Files
CREATE PROCEDURE usp_SearchForFiles @fileExtension VARCHAR(100)
AS 
BEGIN
    SELECT f.Id, f.[Name], CONCAT(f.Size, 'KB') AS Size FROM Files AS f
    WHERE f.[Name] LIKE CONCAT('%.', @fileExtension)
	ORDER BY f.Id ASC,
	f.[Name] ASC,
	f.Size DESC
END

GO

EXEC usp_SearchForFiles 'txt' 