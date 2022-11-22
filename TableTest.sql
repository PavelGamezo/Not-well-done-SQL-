USE LibraryDatabase;
GO

SELECT * FROM UsersInfo
EXEC GiveBookToUser 'pupkov@yandex.ru', 'Yanka', 'Kupala', 'Mahila lva'

UPDATE UserBooks
SET CreatedDate = '2020-10-21' WHERE BookId = (SELECT Id FROM Books WHERE NAME = 'Pavel')
EXECUTE ReturnBook 'pupkov@yandex.ru', 'Yanka', 'Kupala', 'Kurhan'
GO