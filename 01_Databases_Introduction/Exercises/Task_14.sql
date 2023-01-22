-- 14. Car Rental Database
CREATE DATABASE CarRental

USE CarRental

CREATE TABLE Categories
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
CategoryName VARCHAR(30) NOT NULL,
DailyRate DECIMAL(2, 1),
WeeklyRate DECIMAL(2, 1),
MonthlyRate DECIMAL(2, 1),
WeekendRate DECIMAL(2, 1)
)

CREATE TABLE Cars
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
PlateNumber VARCHAR(30) NOT NULL,
Manufacturer VARCHAR(50) NOT NULL,
Model VARCHAR(30) NOT NULL,
CarYear DATE NOT NULL,
CategoryId INT NOT NULL,
Doors INT NOT NULL,
Picture VARBINARY(MAX),
Condition VARCHAR(30) NOT NULL,
Available BIT NOT NULL,

CONSTRAINT FK_Cars_Categories
FOREIGN KEY (CategoryId) REFERENCES Categories(Id),

CONSTRAINT CK_Cars_Available
CHECK (Available IN (0, 1))
)

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
Id INT PRIMARY KEY IDENTITY NOT NULL,
DriverLicenceNumber VARCHAR(50) NOT NULL,
FullName VARCHAR(100) NOT NULL,
[Address] VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
ZIPCode VARCHAR(50),
Notes VARCHAR(MAX)
)

CREATE TABLE RentalOrders
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
EmployeeId INT NOT NULL,
CustomerId INT NOT NULL,
CarId INT NOT NULL,
TankLevel DECIMAL(5, 2) NOT NULL,
KilometrageStart INT NOT NULL,
KilometrageEnd INT NOT NULL,
StartDate DATETIME2 NOT NULL,
EndDate DATETIME2 NOT NULL,
TotalDays DECIMAL(2, 1),
RateApplied BIT NOT NULL,
TaxRate DECIMAL(5, 2) NOT NULL,
OrderStatus VARCHAR(50) NOT NULL,
Notes VARCHAR(MAX)

CONSTRAINT FK_RentalOrders_Employees
FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),

CONSTRAINT FK_RentalOrders_Customers
FOREIGN KEY (CustomerId) REFERENCES Customers(Id),

CONSTRAINT FK_RentalOrders_Cars
FOREIGN KEY (CarId) REFERENCES Cars(Id)
)

INSERT INTO Categories(CategoryName)
VALUES ('Sedan'),
       ('Sports Car'),
       ('Minivan')

INSERT INTO Cars(PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Condition, Available)
VALUES ('CA 7321 BH', 'Volkswagen', 'Passat 2021', '2021', 1, 4, 'Excellent', 1),
       ('CA 0474 PH', 'Porsche', '911 Turbo S', '2022', 2, 2, 'Excellent', 0),
       ('PB 4181 KC', 'Toyota', 'Toyota Sienna', '2020', 3, 4, 'Very Good', 1)

INSERT INTO Employees(FirstName, LastName, Title)
VALUES ('Georgi', 'Kostadinov', 'Department Manager'),
       ('Lyuboslav', 'Veliev', 'Rent Agent'),
       ('Kristyan', 'Simov', 'Rent Agent')

INSERT INTO Customers(DriverLicenceNumber, FullName, [Address], City)
VALUES ('287207439', 'Stefko Tsonovski', 'Trakia, Plovdiv', 'Plovidv'),
       ('286208432', 'Miroslav Uzunov', 'Trakia, Plovdiv', 'Plovidv'),
       ('289209435', 'Pavel Kulishev', 'Center, Sofia', 'Sofia')

INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, StartDate, EndDate, RateApplied, TaxRate, OrderStatus)
VALUES (2, 1, 3, 71.29, 0, 240, '2023-01-07', '2023-01-15', 1, 3.20, 'Pending'),
       (3, 2, 1, 65.30, 0, 260, '2023-01-09', '2023-01-20', 1, 2.15, 'Completed'),
       (2, 3, 2, 58.45, 0, 340, '2023-01-16', '2023-02-03', 0, 5.60, 'Awaiting Payment')