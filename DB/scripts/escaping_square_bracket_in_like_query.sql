/** Method 1 **/
SELECT * FROM [dbo].[News]
WHERE Title LIKE '[[]Important]%'

/** Method 2 **/
SELECT * FROM [dbo].[News]
WHERE Title LIKE '\[Important]%' ESCAPE '\'
