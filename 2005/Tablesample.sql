-- Subject             : SQL Server tablesample
-- Created By          : Selcuk KILINC
-- Version             : 1.0
-- Executed SQL Version: Microsoft SQL Server 2019 

-- Suggestions : These scripts run on AdventureWorks2019 sample database.
--               Read the comments and run script step by step

use AdventureWorks2019
go

--- Sample 1: tablesample(n percent)
--- The PERCENT parameter attempts to produce a result set close to the specified percentage, but does not guarantee exactly the specified percentage. 

select * from Sales.SalesOrderDetail tablesample(2 percent)

--- Sample 2: tablesample(n rows)
--- The following statement returns approximately 1000 rows. I never get 1000 rows :)
--- Keep in mind: If you make the ROWS value too small there is a chance that you can get no data returned from the query. It depends on the table size. 

select * from Sales.SalesOrderDetail tablesample(1000 rows)

--- Sample 3: tablesample(30 percent) repeatable(5)
--- If you want to get same data set, you should use repeatable parameter.
--- Once you replace the parameter with a different number, it changes the data set.

select * from Sales.SalesOrderDetail tablesample(10 percent) repeatable(5)

--- Sample 4: create random 
--- if you want to retrieve data randomly you can use it with top clause
--- Keep the parameter as big numbers to avoid of empty result set.
--- You can get 50 random records below script

select top(50) * from Person.Person tablesample(10000 rows)

--- Very Important Note!!!: The TABLESAMPLE clause cannot be used with views or in an inline table-valued function.
--- Variables are not allowed in the TABLESAMPLE or REPEATABLE clauses. tablesample(@n percent) does not work.
