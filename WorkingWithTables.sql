USE LibraryDatabase;
GO

INSERT INTO Authors VALUES
('Yanka', 'Kupala', 'Belarus', '1882-07-07'),
('Taras', 'Shevchenko', 'Ukraine', '1814-03-09'),
('Lev', 'Tolstoy', 'Russia', '1828-09-09')

INSERT INTO Books VALUES
('Kurhan', '1912-06-21', (SELECT Authors.Id FROM Authors WHERE FirstName = 'Yanka' AND LastName = 'Kupala')),
('Mahila lva', '1920-02-20', (SELECT Authors.Id FROM Authors WHERE FirstName = 'Yanka' AND LastName = 'Kupala')),
('Zaveschanie', '1859-12-25', (SELECT Authors.Id FROM Authors WHERE FirstName = 'Taras' AND LastName = 'Shevchenko')),
('Voina i Mir', '1867-01-01', (SELECT Authors.Id FROM Authors WHERE FirstName = 'Lev' AND LastName = 'Tolstoy')),
('Detstvo', '1852-11-01', (SELECT Authors.Id FROM Authors WHERE FirstName = 'Lev' AND LastName = 'Tolstoy'))

INSERT INTO Users VALUES
('Pavel', 'Gamezo', 'pasha@gmail.com', '2002-04-20', 20, 'Kazintsa 122', NULL),
('Ivan', 'Ivanov', 'ivanov@gmail.com', '2002-04-20', 20, 'Kazintsa 56', NULL),
('Vladislav', 'Pupkov', 'pupkov@yandex.ru', '2003-01-10', 19, 'Timiryazeva 87', NULL)

INSERT INTO UserBooks VALUES
(
	(SELECT Id FROM Users Where FirstName = 'Pavel' AND LastName = 'Gamezo'),
	(SELECT Id FROM Books WHERE NAME = 'Zaveschanie'),
	'1900-01-01',
	0
),
(
	(SELECT Id FROM Users Where FirstName = 'Ivan' AND LastName = 'Ivanov'),
	(SELECT Id FROM Books WHERE NAME = 'Detstvo'),
	'1900-01-01',
	0
),
(
	(SELECT Id FROM Users Where FirstName = 'Vladislav' AND LastName = 'Pupkov'),
	(SELECT Id FROM Books WHERE NAME = 'Voina i Mir'),
	'1900-01-01',
	0
)

-- —Œ«ƒ¿Õ»≈ œ–≈ƒ—“¿¬À≈Õ»ﬂ
CREATE VIEW UsersInfo AS
SELECT UserBooks.UserId AS UserId,
		CONCAT(Users.FirstName, ' ', Users.LastName) AS UserFullName,
		Users.Age AS UserAge,
		Concat(Authors.FirstName, ' ', Authors.LastName) AS AuthorFullName,
		Books.NAME AS BookName,
		Books.Year As BookYear
FROM UserBooks RIGHT JOIN Users ON UserBooks.UserId = Users.Id 
LEFT JOIN Books ON UserBooks.BookId = Books.Id
LEFT JOIN Authors ON UserBooks.Id = Authors.Id
GO

CREATE PROCEDURE DeleteUsersByExpiredDate AS
BEGIN
	--If select UserId from UsersInfo where BookName is not null
	--Delete from Users where Users.ExpiredDate < GETDATE()
	DECLARE @userWithBook NVARCHAR(50)
	SET @userWithBook = (SELECT UserFullName FROM UsersInfo where (select ExpiredDate from Users) < GETDATE() AND BookName IS NOT NULL)
	SELECT @userWithBook
	DELETE FROM Users WHERE Id = (SELECT Id FROM UsersInfo WHERE ExpiredDate < GETDATE() AND BookName IS NULL)
END;
GO