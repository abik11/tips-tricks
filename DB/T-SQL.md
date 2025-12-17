## T-SQL 
**Transact-SQL** is Microsoft extension for SQL and it is used in Microsfoft SQL Server. It is really complex, actually T-SQL is full featured programming language with variables, procedures, functions, transactions, error handling and many many more. Probably the best SQL dialect ever!
 
### Stored procedures
One of the most important SQL features! A poor thing is that almost every database management system has its own syntax to define stored procedures. You can use transactions, variables, input and output parameters and many more! 
```sql
CREATE PROCEDURE EmployeeReport
(
    @StartDate datetime = '2017-01-01 00:00:00.000' --a parameter with default value
)
AS
BEGIN
    SELECT *
    FROM Employees
    WHERE HireDate > @StartDate
END

--Usage:
EXEC EmployeeReport
```

### TVF
TVF (Table Valued Function) or UDF (User Defined Function) are SQL functions that return tables and their results may be used in a query in **SELECT**, **WHERE** or **HAVING** statement. Their definition may look like stored procedures but functionality is rather closer to views.
```sql
CREATE FUNCTION EmployeeReport
(
    @StartDate datetime = '2017-01-01 00:00:00.000' --a parameter with default value
)
RETURNS TABLE
AS
RETURN
    SELECT *
    FROM Employees
    WHERE HireDate > @StartDate

--Usage:
SELECT EmployeeNumber FROM dbo.EmployeeReport('2017-06-01 00:00:00.000')
```
It is good to know that there are quite many other differences bettween UDFs and procedures. You cannot use **INSERT**, **UPDATE** or **DELETE** inside of a function. Also you cannot change the function's parameters as you can do in procedures (with **out** keyword). It is impossible to use transactions inside of a function which make sense if you cannot change anything. A function must take at least one parameter and must return a value (procedure mustn't). You cannot call stored procedure inside of a function and you cannot use **try-catch** block.

### Case statement
Case statement allows to select some specified value depending on some column. It is like switch statement in C# or C++. It is very easy to use and sometimes life-saving!
```sql
SELCT CASE [Type] 
	WHEN 0 THEN 'Normal'
    WHEN 1 THEN 'Important' 
    WHEN 2 THEN 'Critical'
FROM Task
```
Really nice use of case statement is to return some specified value if some column is **null**.
```sql
SELECT CASE 
	WHEN [Image] IS NULL THEN 'NO_IMAGE'
    ELSE 'IMAGE_OK'
    END
FROM Employee
```

### Coalesce 
**Coalesce** can be used to set some default value that will be returned in results instead of **null**. It is easy to use and very handy and useful! Here in the following example everytime when there will be **null** in *Work* column, the value *Unemployeed* will be returned.
```sql
SELECT [Name], COALESCE([Work], 'Unemployeed')
FROM Employee
```
Inside **Coalesce** some statements can be used, see the following example:
```sql
SELECT
	COALESCE(CASE du.NewName
		WHEN '' THEN NULL
		WHEN '-' THEN NULL
		ELSE du.NeweName 
		END, d.Name) AS Name
FROM Department d
LEFT OUTER JOIN [DeptUpdate] du 
ON d.CostCenter = du.CostCenter AND d.Name = du.Name
```

### Rollup 
**Rollup** is another way to group data. It groups the result by specified hierarchy. In the following example *MovementHistoryReport* will be grouped first by *Week* and then each group will be internally grouped also by *Location*.
```sql
SELECT  COALESCE([Week], 'TOTAL'), 
		[Location], 
        COUNT(*) AS WrongCount
FROM MovementHistoryReport
GROUP BY ROLLUP([Week], [Location])
```

### CTE
**Common Table Expression** allows to extract some parts of a query, especially subqueries, into a structure that is similar to a temporary table or a view and can be used in your query to make it much more readable and cleaner. This is by far the most useful syntax structure to build advanced and complex SQL queries that will still be very clean and easy to understand. Moreover what is worth knowing, CTE has better efficiency for large data sets than most other methods (but worse for small). Here is a very simple example presenting the syntax:
```sql
WITH TmpEmployee AS (
	SELECT [EmployeeNo], [Name] 
    FROM Employee
 ),
 TmpAccess As (
	SELECT [EmployeeNo], [Date] 
    FROM EmployeeAccess
 )
 SELECT * 
 FROM TmpEmployee te
 JOIN TmpAccess ta ON te.[EmployeeNo] = ta.[EmployeeNo]
 WHERE [Name] LIKE '%Kozak%'
```
Here you can see a bit more complex example where CTE allows to keep the query very simple and easy to understand!
```sql
WITH CommentCount AS (
	SELECT EmployeeOid, COUNT(Oid) AS CommentCount
	FROM Comment
	WHERE GCRecord IS NULL AND Date > '2017-06-01 00:00:00.000'
	GROUP BY EmployeeOid
),
LeaderTmp AS (
	SELECT EmployeeOid, SectionOid
	FROM Leader
)
SELECT 
	e.Name, e.EmployeeNo, s.Name as Section, ll.Line, 
    COALESCE(cc.CommentCount, 0) AS [Count], e.Title
FROM LeaderTmp lt 
LEFT OUTER JOIN CommentCount cc ON lt.EmployeeOid = cc.EmployeeOid
LEFT OUTER JOIN Employee e ON lt.EmployeeOid = e.OID
LEFT OUTER JOIN Section s ON lt.SectionOid = s.OID
LEFT OUTER JOIN LayoutLocation ll ON s.LayoutLocationOid = ll.OID
WHERE e.Status != 'Terminated' AND ll.Line IS NOT NULL
```
In the given example, *Comment* can be joined with *Leader* by *EmployeeOid* to count how many comments has each leader. To achieve this goal, first we've got CTE with comments and then we've got CTE with leaders. Then we left outer join those two CTE. It must be this kind of join because we want to see also leaders that have no comments at all and for **null** values in *CommentCount* using **coalesce** we put there 0 in results.<br />
This is a great example of how CTE can keep complex queries very tidy and a good example how to count some rows with left outer join, allowing us to see where there are no associated rows.

### Cross apply
Logically CROSS APPLY is like running a function or a join for every row separately. It sounds really woryfing when it comes to query performance, but the good news is that it's just how it looks from the logical point of view. Under the hood the left side and right side are executed just once if possible (it might not work like that in case of multi-statement TVF) and combined with a nested loop. So CROSS APPLY is a really nice tool, let's see an example of how to use it - it is great option if you for example need to "join" one table with another, but you don't want all the rows from the other table. For example, let's take AdventureWorks database and let's see a query that gets top 2 most expensive products for each sales order:
```sql
SELECT oh.SalesOrderID, MostExpensiveProducts.*
FROM SalesLT.SalesOrderHeader oh
CROSS APPLY (
	SELECT TOP 2 p.Name, p.ListPrice
	FROM SalesLT.SalesOrderDetail od
	JOIN SalesLT.Product p ON p.ProductID = od.ProductID
	WHERE od.SalesOrderID = oh.SalesOrderID
	ORDER BY p.ListPrice DESC
) MostExpensiveProducts
```
For each row in `SalesLT.SalesOrderHeader` we just have at most 2 coresponding rows from `SalesLT.SalesOrderDetail` and `SalesLT.Product`. If there is no match on the right side than the row from left side is discarded - if we would like this row to be included in the result we could use OUTER APPLY instead of CROSS APPLY (similarily like with INNER JOIN and LEFT OUTER JOIN).

With CROSS APPLY it is possible to write queries in an elegent way that would result to be very cumbersome with just classical JOINs.

### Merge
**Merge** statement allows to *compare* two tables and decide what to do with the differences between, to do some inerts, update or deletes. It can express quite a lot with just a few lines of code. The following query is a great example. It compares *Employee* and *NewEmplImport* tables basing on *Oid* field (it looks similar to **join**) and then when two rows match in both tables, the first one is updated according to the second. All not matching rows are added to the first table. This way *Employee* will have its old content but also all the new data from *NewEmplImport*. This operation is sometimes called **upsert** as it is a mix of **up**date and in**sert**.
```sql
MERGE Employee AS T       --Target
USING NewEmplImport AS S  --Source
ON T.Oid = S.Oid
WHEN MATCHED THEN
	UPDATE SET T.SalesAmount = S.SalesAmount
WHEN NOT MATCHED THEN
	INSERT (Name, Number) VALUES (S.Name, S.Number);
```
Merge can be combined with **CTE** becoming really powerfull combo. Here is an example:
```sql
WITH DepartmentUpdate AS (
	SELECT
		d.Name,
		COALESCE(CASE du.ChangeName
			WHEN '' THEN NULL
			WHEN '-' THEN NULL
			ELSE du.ChangeName 
			END, d.Name) AS [NewName],
		du.CostCenter,
		CASE du.[Delete]
			WHEN 'delete' THEN 20171010
			ELSE NULL
			END AS GCRecord
	FROM Department d
	LEFT OUTER JOIN [DeptUpdate$] du 
	ON d.CostCenter = du.CostCenter AND d.Name = du.Name
)
MERGE Department AS T
USING DepartmentUpdate AS S
ON T.Name = S.Name AND T.CostCenter = S.CostCenter
WHEN MATCHED THEN
	UPDATE SET 
		T.Name = S.[NewName],
		T.GCRecord = S.GCRecord;
```

### Window functions basics

Window functions allow to run some operations on specified partitions of the result data and not just on the whole set. `OVER` keyword is used to define a window for window functions to work on, it may use `PARTITION BY` to define which column will be used to specify partitions and `ORDER BY` to sort the data inside of each partition (there are also other operators like `ROWS` and `RANGE`). Window functions available are for example classic aggregate functions like `SUM`, `AVG`, `COUNT`, but also ranking functions like `RANK`, `DENSE_RANK`, `ROW_NUMBER` and `NTILE`.

See here an example of a `AVG` window function (query works on AdventureWorks database):
```sql
SELECT * FROM
(
	SELECT
		pc.Name AS Category,
		p.Name AS Product,
		p.ListPrice,
		AVG(p.ListPrice) OVER(PARTITION BY pc.Name) AS AverageCategoryPrice
	FROM SalesLT.Product p
	JOIN SalesLT.ProductCategory pc ON pc.ProductCategoryID = p.ProductCategoryID
) PriceByCategory
WHERE ListPrice > PriceByCategory.AverageCategoryPrice
```
The result are all products which price is higher than the average price to which the product belong. Average price for the product category is calculated with `AVG ... OVER`.

#### Get first row of a group
Imagine that you have a *GROUP BY* query, but you really want to get is the first row of each group. It is very easy to achieve with **ROW_NUMBER** function:
```sql
WITH firstPOItem AS (
    SELECT PONumber,
           ROW_NUMBER() OVER(PARTITION BY Product_id ORDER BY PODate) AS row_number
)
SELECT *
FROM firstPOItem
WHERE row_number = 1
```
This way for example you can list first *PO Numbers* for every product.

### Date-time functions
Handling dates is very often used and crucial skill while programming in SQL. Thankfully there are few extremely useful and easy to use functions that makes programmers lifes easier. 
```sql
SELECT GETDATE() --returns current datetime
SELECT DATEPART(DAY, GETDATE())
SELECT DATEPART(WEEK, GETDATE())
SELECT DATEPART(MONTH, GETDATE())
SELECT DAY(GETDATE())
SELECT MONTH(GETDATE())
SELECT YEAR(GETDATE())
SELECT DATEDIFF(WEEK, GETDATE(), '1995-05-25 00:00:00.000')
SELECT DATEDIFF_BIG(WEEK, GETDATE(), '1995-05-25 00:00:00.000')
SELECT EOMONTH('1995-05-25 00:00:00.000') --returns the last day of the month of given date
SELECT DATEADD(YEAR, 10, GETDATE())
```

### Convert string of yyyyMMddhhmmss format to datetime
It is very common that a string has to be converted to datetime, but the format of `yyyyMMddhhmmss` may cause some more problems. You can use the **STUFF** function to change the format of the string, put some chars into the string and prepare it to be converted, see the example:
```sql
SELECT CAST(STUFF(STUFF(STUFF('20180525222200', 13, 0, ':'), 11, 0, ':'), 9, 0, ' ') AS DATETIME)
--it will create the string: '20180525 22:22:00', and such string can be easily converted
```

### Find rows from last 20 minutes
A nice use case for **DATEDIFF** function is to find all the rows from last 20 minutes by some date. Here is an example:
```sql
SELECT ScanDate, Code FROM Material
WHERE DATEDIFF(MINUTE, ScanDate, GETDATE()) < 20
```
Be careful with **DATEDIFF** because it can be very slow in comparison with simple datetime comparison. The above query can be also written like this - being quite faster:
```sql
SELECT ScanDate, Code FROM Material
WHERE ScanDate > DATEADD(MINUTE, -20, GETDATE())
```

### Complex order by
It is possible to switch the column that you want to use for **order by** using **case** statements, so that some data will be ordered by different column than other. Nice trick!
```sql
SELECT * 
FROM Employees
ORDER BY Sex, 
	CASE Sex
    WHEN 'M' THEN Name
    WHEN 'F' THEN CAST(Birthdate AS NVARCHAR)
    ELSE EmployeeNumber
    END
```
Remember that all of the columns you put in **case** statement to order by must be of the same type, otherwise you will have to cast them.

### Find a table by name or phrase
```sql
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Impo%Data'
```

### Create table if not exists
In many SQL scripts it may be useful to create a table only if it doesn't exist yet. To make it you just have to use the **if not exists** expression that will check the result of a little query trying to find a table with the given name. If the result set will be empty the **create table** command will be executed: 
```sql
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ImportantData' AND xtype='U')
    CREATE TABLE [Corpo].[dbo].[ImportantData]([Text] [varchar](256) NULL);
```
Also you can make it like this (which is really great way):
```sql
IF OBJECT_ID('[dbo].[ImportantData]') IS NULL
    CREATE TABLE [dbo].[ImportantData]([Text] [varchar](256) NULL);
```

### Transaction with Try/Catch
It might be a very good idea to put a transaction in try-catch block, here is how to do it correctly:
```sql
BEGIN TRY
BEGIN TRANSACTION
--sql code
COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@trancount > 0
        ROLLBACK TRANSACTION
    ;THROW
END CATCH
```
Read more, much more, [here](http://www.sommarskog.se/error_handling/Part1.html).

### Strings with diacritical marks
To be able to store strings with diacritical marks or even more - different alpabets, you should use **nvarchar** type (which uses UTF) and mark the string as unicode with **N** prefix:
```sql
SELECT 'ęóąśłżźć' --eoaslzzc
SELECT N'ęóąśłżźć' --ęóąśłżźć
```

### How to get string length with spaces
There is a very popular function in T-SQL called **LEN**, it is often used to get the length of some string value. It has one disadvantage that it is not counting spaces, so if you want to know the total length of the raw string you have to use another function called **DATALENGTH**. It is very simple to use. Here you can see an example showing the difference between both functions:
```sql
SELECT LEN(' '), DATALENGTH(' ') --returns 0 and 1
```
Be careful with **nvarchar** type because **DATALENGTH** actually returns the number of bytes of a given string, for **nvarchar** it will return the number of characters multiplied by two because every char is encoded as 16 bits (2 bytes). See the result of the following query as proof:
```sql
SELECT DATALENGTH('A'), DATALENGTH(N'A') --returns 1 and 2
```

### Join/Concat strings from query
If you use **SQL Server 2017** or newer you can use new aggregate function called **STRING_AGG**:
```sql
SELECT s.Name, STRING_AGG(a.Name, ', ')
FROM System_Application sa
JOIN System s ON sa.SystemId = s.Id
JOIN Application a ON sa.ApplicationId = a.Id
GROUP BY s.Name
```
For older versions you can use **FOR XML PATH** syntax:
```sql
SELECT CAST(a.Name + ';' AS VARCHAR(MAX))
FROM System_Application sa
JOIN System s ON sa.SystemId = s.Id
JOIN Application a ON sa.ApplicationId = a.Id
FOR XML PATH ('')
```

### Sleep
You can make T-SQL script or procedure to wait for a given time with **WAITFOR** command, for example here it will sleep for 10 seconds:
```sql
WAITFOR DELAY '00:00:10'
```
