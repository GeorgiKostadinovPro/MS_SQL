CREATE DATABASE NationalTouristSitesOfBulgaria

USE NationalTouristSitesOfBulgaria

CREATE TABLE Categories
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Locations
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
Municipality VARCHAR(50),
Province VARCHAR(50)
)

CREATE TABLE Sites
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(100) NOT NULL,
LocationId INT NOT NULL,
CategoryId INT NOT NULL,
Establishment VARCHAR(15)

CONSTRAINT FK_Sites_Locations
FOREIGN KEY (LocationId) REFERENCES Locations(Id),

CONSTRAINT FK_Sites_Categories
FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
)

CREATE TABLE Tourists
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
Age INT NOT NULL,
PhoneNumber VARCHAR(20) NOT NULL,
Nationality VARCHAR(30) NOT NULL,
Reward VARCHAR(20),

CONSTRAINT CHK_Tourists_Age
CHECK (Age BETWEEN 0 AND 120)
)

CREATE TABLE SitesTourists
(
TouristId INT NOT NULL,
SiteId INT NOT NULL

CONSTRAINT PK_SitesTourists
PRIMARY KEY (TouristId, SiteId),

CONSTRAINT FK_SitesTourists_Tourists
FOREIGN KEY (TouristId) REFERENCES Tourists(Id),

CONSTRAINT FK_SitesTourists_Sites
FOREIGN KEY (SiteId) REFERENCES Sites(Id),
)

CREATE TABLE BonusPrizes
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE TouristsBonusPrizes
(
TouristId INT NOT NULL,
BonusPrizeId INT NOT NULL

CONSTRAINT PK_TouristsBonusPrizes
PRIMARY KEY (TouristId, BonusPrizeId),

CONSTRAINT FK_TouristsBonusPrizes_Tourists
FOREIGN KEY (TouristId) REFERENCES Tourists(Id),

CONSTRAINT FK_TouristsBonusPrizes_BonusPrizes
FOREIGN KEY (BonusPrizeId) REFERENCES BonusPrizes(Id),
)