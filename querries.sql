DECLARE @Username VARCHAR(50);
SET @Username = 'john_doe';

DECLARE @Password VARCHAR(50);
SET @Password = 'password123';

SELECT * FROM [dbo].[User] WHERE [Username] = @Username AND [Password] = @Password