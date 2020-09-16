ALTER TABLE [BankAccount]
ADD IsBlocked BIT

EXEC ('
    UPDATE [BankAccount]
    SET IsBlocked = 0
')

ALTER TABLE [BankAccount]
ALTER COLUMN IsBlocked BIT NOT NULL
