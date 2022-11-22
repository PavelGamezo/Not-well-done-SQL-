USE LibraryDatabase;
GO

CREATE PROCEDURE GiveBookToUser @userEmail nvarchar(100), 
								@authorFirstName nvarchar(50), 
								@authorLastName nvarchar(50), 
								@bookName nvarchar(100) AS
BEGIN
	Declare @userName nvarchar(100)
	SET @userName = (SELECT CONCAT(FirstName,' ', LastName) FROM Users WHERE (@userEmail = Users.Email))
	IF @bookName = ANY (SELECT BookName FROM UsersInfo WHERE @userName = UserFullName)
		PRINT 'User have this book'
	ELSE IF(NOT EXISTS(SELECT NAME FROM Books WHERE NAME = @bookName))
		PRINT('This book is not excist')
	ELSE IF(NOT EXISTS(SELECT BookName FROM UsersInfo WHERE BookName = @bookName))
		PRINT('This book is reserved')
	ELSE
		INSERT INTO UserBooks VALUES
		(
			(SELECT Id FROM Users Where Email = @userEmail),
			(SELECT Id FROM Books WHERE NAME = @bookName),
			'1900-01-01',
			0
		);
END;
GO

--‘”Õ ÷»ŒÕ¿À ¬€ƒ¿◊»  Õ»√» Õ¿ 60 ƒÕ≈…

ALTER TABLE UserBooks
ADD ToCharge MONEY NOT NULL DEFAULT 0;

CREATE FUNCTION GetCharge (@dateOfCreating date, @dateCount int)
	RETURNS MONEY
BEGIN 
	
	DECLARE @result MONEY
	DECLARE @term int
	SET @term = DATEDIFF(DAY, @dateOfCreating, GETDATE())
	IF(@term <= @dateCount)
		SET @result = 0
	ELSE
		SET @result = (@term - @dateCount) * 2.7
	RETURN @result
END;
GO

CREATE PROCEDURE ChargeUser @userEmail nvarchar(100),
						    @bookId int AS
BEGIN 
	DECLARE @id int;
	SET @id = (SELECT Id FROM Users WHERE Email = @userEmail)
	DECLARE @date date
	SET @date = (SELECT CreatedDate FROM UserBooks WHERE BookId = @bookId)
	UPDATE UserBooks
	SET ToCharge = (SELECT dbo.GetCharge(@date, 60))
END;
GO

CREATE PROCEDURE ReturnBook @userEmail NVARCHAR(100),
							@authorFirstName NVARCHAR(100),
							@authorLastName NVARCHAR(100),
							@bookName NVARCHAR(100) AS
BEGIN
	DECLARE @bookId int,
			@charge int;
	SET @bookId = (SELECT Id FROM Books WHERE Name = @bookName)
	EXECUTE ChargeUser @userEmail, @bookId
	SET @charge = (SELECT ToCharge FROM UserBooks WHERE BookId = @bookId)
	PRINT(@charge)
	DELETE FROM UserBooks WHERE BookId = @bookId
END;
GO