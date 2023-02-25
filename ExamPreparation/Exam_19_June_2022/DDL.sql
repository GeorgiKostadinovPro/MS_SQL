CREATE DATABASE Zoo

USE Zoo

CREATE TABLE Owners
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(15) NOT NULL,
[Address] VARCHAR(50)
)

CREATE TABLE AnimalTypes
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
AnimalType VARCHAR(30) NOT NULL 
)

CREATE TABLE Cages
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
AnimalTypeId INT NOT NULL

CONSTRAINT FK_Cages_AnimalTypes
FOREIGN KEY (AnimalTypeId) REFERENCES AnimalTypes(Id)
)

CREATE TABLE Animals
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(30) NOT NULL,
BirthDate DATE NOT NULL,
OwnerId INT,
AnimalTypeId INT NOT NULL

CONSTRAINT FK_Animals_Owners
FOREIGN KEY (OwnerId) REFERENCES Owners(Id),

CONSTRAINT FK_Animals_AnimalTypes
FOREIGN KEY (AnimalTypeId) REFERENCES AnimalTypes(Id)
)

CREATE TABLE AnimalsCages
(
CageId INT NOT NULL,
AnimalId INT NOT NULL

CONSTRAINT PK_AnimalsCages
PRIMARY KEY (CageId, AnimalId),

CONSTRAINT FK_AnimalsCages_Cages
FOREIGN KEY (CageId) REFERENCES Cages(Id),

CONSTRAINT FK_AnimalsCages_Animals
FOREIGN KEY (AnimalId) REFERENCES Animals(Id)
)

CREATE TABLE VolunteersDepartments
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(15) NOT NULL,
[Address] VARCHAR(50),
AnimalId INT,
DepartmentId INT NOT NULL

CONSTRAINT FK_Volunteers_Animals
FOREIGN KEY (AnimalId) REFERENCES Animals(Id),

CONSTRAINT FK_Volunteers_VolunteersDepartments
FOREIGN KEY (DepartmentId) REFERENCES VolunteersDepartments(Id)
)