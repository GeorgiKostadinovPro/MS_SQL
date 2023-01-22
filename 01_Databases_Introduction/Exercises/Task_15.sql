-- 15. Hotel Database
CREATE DATABASE Hotel

USE Hotel

CREATE TABLE Employees
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Title VARCHAR(50) NOT NULL,
Notes VARCHAR(MAX)
)

CREATE TABLE Customers
(
AccountNumber CHAR(7) PRIMARY KEY NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
PhoneNumber CHAR(10) NOT NULL,
EmergencyName VARCHAR(50) NOT NULL,
EmergencyNumber VARCHAR(50) NOT NULL,
Notes VARCHAR(MAX)
)

CREATE TABLE RoomStatus
(
RoomStatus VARCHAR(50) PRIMARY KEY NOT NULL,
Notes VARCHAR(MAX)
)

CREATE TABLE RoomTypes
(
RoomType VARCHAR(50) PRIMARY KEY NOT NULL,
Notes VARCHAR(MAX)
)

CREATE TABLE BedTypes
(
BedType VARCHAR(50) PRIMARY KEY NOT NULL,
Notes VARCHAR(MAX)
)

CREATE TABLE Rooms
(
RoomNumber VARCHAR(10) PRIMARY KEY NOT NULL,
RoomType VARCHAR(50) NOT NULL,
BedType VARCHAR(50) NOT NULL,
Rate DECIMAL(2, 1) NOT NULL,
RoomStatus VARCHAR(50) NOT NULL,
Notes VARCHAR(MAX),

CONSTRAINT FK_Rooms_RoomType
FOREIGN KEY (RoomType) REFERENCES RoomTypes(RoomType),

CONSTRAINT FK_Rooms_BedTypes
FOREIGN KEY (BedType) REFERENCES BedTypes(BedType),

CONSTRAINT FK_Rooms_RoomStatus
FOREIGN KEY (RoomStatus) REFERENCES RoomStatus(RoomStatus)
)

CREATE TABLE Payments
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
EmployeeId INT NOT NULL,
PaymentDate DATETIME2 NOT NULL,
AccountNumber CHAR(7) NOT NULL,
FirstDateOccupied DATETIME2 NOT NULL,
LastDateOccupied DATETIME2 NOT NULL,
TotalDays INT,
AmountCharged DECIMAL(10, 2) NOT NULL,
TaxRate DECIMAL(5, 2) NOT NULL,
TaxAmount DECIMAL(5, 2) NOT NULL,
PaymentTotal DECIMAL(10, 2) NOT NULL,
Notes VARCHAR(MAX)

CONSTRAINT FK_Payments_Employees
FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),

CONSTRAINT FK_Payments_Customers
FOREIGN KEY (AccountNumber) REFERENCES Customers(AccountNumber)
)

CREATE TABLE Occupancies
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
EmployeeId INT NOT NULL,
DateOccupied DATETIME2 NOT NULL,
AccountNumber CHAR(7) NOT NULL,
RoomNumber VARCHAR(10) NOT NULL,
RateApplied BIT NOT NULL,
PhoneCharge BIT NOT NULL

CONSTRAINT FK_Occupancies_Employees
FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),

CONSTRAINT FK_Occupancies_Customers
FOREIGN KEY (AccountNumber) REFERENCES Customers(AccountNumber)
)

INSERT INTO Employees(FirstName, LastName, Title)
VALUES ('Georgi', 'Kostadinov', 'Hotel Manager'),
       ('Lyuboslav', 'Veliev', 'Hotel receptionist'),
       ('Kristyan', 'Simov', 'Reservation agent')

INSERT INTO Customers(AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber)
VALUES ('F108663', 'Stefko', 'Tsonovski', '0836342343', 'Stefko Tsonovski', '0846342343'),
       ('F108657', 'Mrioslav', 'Uzunov', '0846583678', 'Miroslav Uzunov', '0856583678'),
       ('F108745', 'Pesho', 'Peshev', '0876454639', 'Pesho Peshev', '0877454639')

INSERT INTO RoomStatus(RoomStatus)
VALUES ('Occupied'),
       ('Not occupied'),
       ('Out of Order')

INSERT INTO RoomTypes(RoomType)
VALUES ('Small'),
       ('Medium'),
       ('Large')

INSERT INTO BedTypes(BedType)
VALUES ('Air Bed'),
       ('Water Bed'),
       ('Convertible Bed')

INSERT INTO Rooms(RoomNumber, RoomType, BedType, Rate, RoomStatus)
VALUES ('502 A', 'Small', 'Air Bed', 7.8, 'Not occupied'),
       ('404 A', 'Large', 'Water Bed', 9.2, 'Occupied'),
       ('200 A', 'Medium', 'Convertible Bed', 8.5, 'Out of Order')

INSERT INTO Payments(EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied
, LastDateOccupied, AmountCharged, TaxRate, TaxAmount, PaymentTotal)
VALUES (2, '2023-01-05', 'F108663', '2023-01-05', '2023-01-10', 150.20, 3.50, 10.50, 160.70),
       (3, '2023-01-06', 'F108745', '2023-01-06', '2023-01-11', 140.50, 4.50, 11.50, 152.00),
       (2, '2023-01-07', 'F108657', '2023-01-07', '2023-01-12', 130.80, 2.50, 9.50, 140.30)

INSERT INTO Occupancies(EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge)
VALUES (3, '2023-01-05', 'F108663', '502 A', 1, 1),
       (2, '2023-01-06', 'F108745', '404 A', 0, 1),
       (2, '2023-01-07', 'F108657', '200 A', 1, 0)