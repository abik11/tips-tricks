-- temporarily remove index
DROP INDEX IX_ColumnThatShouldBeNotNull
ON [dbo].[TableName]

-- make sure that no row has null value in the column
UPDATE [dbo].[TableName]
SET ColumnThatShouldBeNotNull = 1
WHERE ColumnThatShouldBeNotNull IS NULL

-- modify the column
ALTER TABLE [dbo].[TableName]
ALTER COLUMN ColumnThatShouldBeNotNull INT NOT NULL

-- create temporarily removed index
CREATE INDEX IX_ColumnThatShouldBeNotNull
ON [dbo].[TableName] (ColumnThatShouldBeNotNull)
