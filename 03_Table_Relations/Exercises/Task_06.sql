-- 06. University Database
CREATE DATABASE University

USE University

CREATE TABLE Subjects
(
SubjectID INT PRIMARY KEY IDENTITY NOT NULL,
SubjectName NVARCHAR(50) NOT NULL
)

CREATE TABLE Majors
(
MajorID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Students
(
StudentID INT PRIMARY KEY IDENTITY NOT NULL,
StudentNumber NVARCHAR UNIQUE NOT NULL,
StudentName NVARCHAR(50) NOT NULL,
MajorID INT NOT NULL,

CONSTRAINT FK_Students_Majors
FOREIGN KEY (MajorID) REFERENCES Majors(MajorID) 
)

CREATE TABLE Payments
(
PaymentID INT PRIMARY KEY IDENTITY NOT NULL,
PaymentDate DATETIME2 NOT NULL,
PaymentAmount DECIMAL(10, 2) NOT NULL,
StudentID INT NOT NULL,

CONSTRAINT FK_Payments_Students
FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
)

CREATE TABLE Agenda
(
StudentID INT NOT NULL,
SubjectID INT NOT NULL,

CONSTRAINT PK_Agenda_StudentID_SubjectID
PRIMARY KEY (StudentID, SubjectID),

CONSTRAINT FK_Agenda_Students
FOREIGN KEY (StudentID) REFERENCES Students(StudentID),

CONSTRAINT FK_Agenda_Subjects
FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
)