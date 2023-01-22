-- 13. Movies Database
CREATE DATABASE Movies

USE Movies

CREATE TABLE Directors
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
DirectorName VARCHAR(30) NOT NULL,
Notes VARCHAR(255)
)

CREATE TABLE Genres
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
GenreName VARCHAR(30) NOT NULL,
Notes VARCHAR(255)
)

CREATE TABLE Categories
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
CategoryName VARCHAR(30) NOT NULL,
Notes VARCHAR(255)
)

CREATE TABLE Movies
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Title VARCHAR(50) NOT NULL,
DirectorId INT NOT NULL,
CopyrightYear INT NOT NULL,
[LENGTH] DECIMAL(3, 2) NOT NULL,
GenreId INT NOT NULL,
CategoryId INT NOT NULL,
Rating DECIMAL(2, 1),
Notes VARCHAR(MAX),

CONSTRAINT FK_Movies_Directors
FOREIGN KEY (DirectorId) REFERENCES Directors(Id),

CONSTRAINT FK_Movies_Genres
FOREIGN KEY (GenreId) REFERENCES Genres(Id),

CONSTRAINT FK_Movies_Categories
FOREIGN KEY (CategoryId) REFERENCES Categories(Id),

CONSTRAINT CK_Movies_CopyrightYear
CHECK (CopyrightYear >= 1888)
)

INSERT INTO Directors(DirectorName)
VALUES ('Stanley Kubrick'),
       ('Alfred Hitchcock'),
       ('Akira Kurosawa'),
       ('Steven Spielberg'),
       ('Martin Scorsese')

INSERT INTO Genres(GenreName)
VALUES ('Action'),
       ('Comedy'),
       ('SCI-FI'),
       ('Thriller'),
       ('Drama')

INSERT INTO Categories(CategoryName)
VALUES ('for kids'),
       ('for teenagers'),
       ('for adults'),
       ('for kids and teenagers'),
       ('for teenagers and adults')

INSERT INTO Movies(Title, DirectorId, CopyrightYear, [LENGTH], GenreId, CategoryId)
VALUES ('The Wolf of Wall Street', 5, 2007, 3, 2, 5),
       ('War of the Worlds', 4, 2005, 2, 3, 5),
       ('A Clockwork Orange', 1, 1971, 2.16, 5, 3),
       ('Seven Samurai', 3, 1954, 3.27, 5, 5),
       ('Psycho', 2, 1960, 1.49, 4, 3)