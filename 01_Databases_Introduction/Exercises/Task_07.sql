-- 07. Create Table People
CREATE TABLE People
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(200) NOT NULL,
Picture VARBINARY(MAX),
Height DECIMAL(3, 2),
[Weight] DECIMAL(5, 2),
Gender CHAR(1) NOT NULL,
Birthdate DATE NOT NULL,
Biography NVARCHAR(MAX),

CHECK (DATALENGTH(Picture) <= 2000000),
CHECK (Gender IN ('m', 'f'))
)

INSERT INTO People([Name], Height, [Weight], Gender, Birthdate)
VALUES ('Georgi', 1.92, 95, 'm', '2003-07-14'),
       ('Lyubo', 1.75, 70, 'm', '2003-10-14'),
	   ('Kriso', 1.85, 85, 'm', '2003-12-15'),
	   ('Vanessa', 1.70, 70, 'f', '2003-09-15'),
	   ('Alexandra', 1.72, 62, 'f', '2003-05-18')