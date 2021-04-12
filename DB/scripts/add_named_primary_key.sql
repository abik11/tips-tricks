/* Create table with named primary key */
CREATE TABLE [dbo].[Test] (
  [Id] INT IDENTITY(1,1) NOT NULL,
  CONSTRAINT [PK_Test] PRIMARY KEY CLUSTERED
  ([Id] ASC)
)

/* Alter table to add named primary key */
ALTER TABLE [dbo].[Test]
ADD CONSTRAINT [PK_Test] PRIMARY KEY CLUSTERED
([Id] ASC)
