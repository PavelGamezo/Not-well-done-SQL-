CREATE DATABASE LibraryDatabase
DROP DATABASE LibraryDatabase
USE LibraryDatabase

CREATE TABLE Authors
(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	FirstName NVARCHAR(100),
	LastName NVARCHAR(100),
	Country NVARCHAR(50),
	BirthDate DATETIME 
);

CREATE TABLE Books
(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name NVARCHAR(100),
	Year DATETIME NULL,
	AuthorId INT NOT NULL,
	constraint FK_AuthorId foreign key (AuthorId) references Authors(Id) on delete cascade
);

CREATE TABLE Users
(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	FirstName NVARCHAR(100),
	LastName NVARCHAR(100),
	Email NVARCHAR(100),
	BirthDate DATETIME,
	Age INT NOT NULL,
	Address NVARCHAR(200),
	ExpiredDate DATETIME NULL
);

CREATE TABLE UserBooks
(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	UserId INT NOT NULL,
	BookId INT NOT NULL,
	CreatedDate DATETIME NULL,
	constraint FK_UserId FOREIGN KEY (UserId) REFERENCES Users (Id) ON DELETE CASCADE,
	constraint FK_BookId FOREIGN KEY (BookId) REFERENCES Books (Id) ON DELETE CASCADE
);