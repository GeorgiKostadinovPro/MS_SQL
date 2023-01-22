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

-- 09. Change Primary Key
ALTER TABLE Users
DROP CONSTRAINT PK__Users__3214EC07CFD633A9

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (Id, Username)

-- 10. Add Check Constraint
ALTER TABLE Users
ADD CONSTRAINT CK_Users_Password CHECK (LEN([Password]) >= 5)

-- 11. Set Default Value of a Field
ALTER TABLE Users
ADD CONSTRAINT DF_Users_LastLoginTime DEFAULT GETDATE() FOR LastLoginTime

-- 12. Set Unique Field
ALTER TABLE Users
DROP CONSTRAINT PK_Users

ALTER TABLE Users
ADD CONSTRAINT PK_Users_Id PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT CK_Users_Username CHECK (LEN(Username) >= 3)