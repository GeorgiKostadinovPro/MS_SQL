-- 08. Create Table Users
CREATE TABLE Users
(
Id BIGINT PRIMARY KEY IDENTITY NOT NULL,
Username VARCHAR(30) UNIQUE NOT NULL,
[Password] VARCHAR(26) NOT NULL,
ProfilePicture VARBINARY(MAX),
LastLoginTime DATETIME2,
IsDeleted VARCHAR(5) NOT NULL,

CHECK (DATALENGTH(ProfilePicture) <= 2000)
)

INSERT INTO Users(Username, [Password], IsDeleted)
VALUES ('Georgi', '12345', 'false'),
       ('Lyubo', '123456', 'false'),
	   ('Kriso', '1234567', 'false'),
	   ('Vanessa', '12345678', 'true'),
	   ('Alexandra', '123456789', 'true')