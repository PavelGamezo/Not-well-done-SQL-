USE LibraryDatabase
GO

CREATE OR ALTER TRIGGER UpdateCreatedDateByTrigger
ON UserBooks
AFTER INSERT
AS UPDATE UserBooks
	SET CreatedDate = GETDATE()
	WHERE Id IN (SELECT Id FROM inserted)
GO

CREATE OR ALTER TRIGGER UpdateExpiredDateByTrigger
ON Users
AFTER INSERT, UPDATE
AS UPDATE Users
	SET ExpiredDate = DATEADD(DAY, -365, GETDATE())
	WHERE Id IN (SELECT Id FROM inserted)
GO

CREATE OR ALTER TRIGGER UpdateAgeByTrigger
ON Users
AFTER INSERT, UPDATE
AS UPDATE Users
	SET Age = DATEDIFF(DAY, BirthDate, GETDATE())
	WHERE Id IN (SELECT Id FROM inserted)

create unique nonclustered index UserBooks_UserId_BookId_Idx
on UserBooks(BookId, UserId)

CREATE UNIQUE NONCLUSTERED INDEX Books_Name_AuthorId_Idx
on Books(Name, AuthorId)

CREATE UNIQUE NONCLUSTERED INDEX Authors_FirstName_LastName_Country_Idx
ON Authors(FirstName, LastName, Country)