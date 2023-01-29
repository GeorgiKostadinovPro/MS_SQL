-- 02. One-To-Many Relationship
CREATE TABLE Models
(
ModelID INT NOT NULL,
[Name] VARCHAR(50) NOT NULL,
ManufacturerID INT NOT NULL
)

CREATE TABLE Manufacturers
(
ManufacturerID INT NOT NULL,
[Name] VARCHAR(50) NOT NULL,
EstablishedOn DATETIME2 NOT NULL
)

INSERT INTO Models(ModelID, [Name], ManufacturerID)
VALUES (101, 'X1', 1),
       (102, 'i6', 1),
       (103, 'Model S', 2),
       (104, 'Model X', 2),
       (105, 'Model 3', 2),
       (106, 'Nova', 3)

INSERT INTO Manufacturers(ManufacturerID, [Name], EstablishedOn)
VALUES (1, 'BMW', '1916-03-07'),
       (2, 'Tesla', '2003-01-01'),
       (3, 'Lada', '1966-05-01')

ALTER TABLE Models
ADD CONSTRAINT PK_Models_ModelID PRIMARY KEY (ModelID)

ALTER TABLE Manufacturers
ADD CONSTRAINT PK_Manufacturers_ManufacturerID PRIMARY KEY (ManufacturerID)

ALTER TABLE Models
ADD CONSTRAINT FK_Models_ManufacturerID
FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers(ManufacturerID)