-- Subject             : SQL Server Ranking Functions
-- Created By          : Selcuk KILINC
-- Executed SQL Version: Microsoft SQL Server 2019 


--- The ROW_NUMBER( ) function returns the number of a row in the result set, starting at 1 for the first row.

use AdventureWorks2019
go

--- example - 1  
SELECT ROW_NUMBER(  ) OVER(ORDER BY LastName, FirstName) as rownum,
       FirstName, LastName
FROM Person.Person

--- example - 2 
--- The following example uses the PARTITION BY clause to rank the same result set within each department
    SELECT  d.Name, ROW_NUMBER(  )
      OVER(PARTITION BY d.Name ORDER BY LastName, FirstName) as rownum,
      e.BusinessEntityID, FirstName, LastName
    FROM HumanResources.Employee e
    LEFT JOIN Person.Person c
    ON e.BusinessEntityID = c.BusinessEntityID
	LEFT JOIN HumanResources.EmployeeDepartmentHistory as dh on e.BusinessEntityID=dh.BusinessEntityID
	LEFT JOIN HumanResources.Department as d on dh.DepartmentID=d.DepartmentID 

--- The DENSE_RANK( ) function returns the rank of rows in a result set without gaps in the ranking .

    SELECT
      DENSE_RANK(  ) OVER(ORDER BY LastName) DenseRank,
      RANK(  ) OVER(ORDER BY LastName) Rank,
      BusinessEntityID, FirstName, LastName
    FROM Person.Person

--- The NTILE(n) function groups the nodes in an ordered state according to the parameter it takes.

    SELECT NTILE(3) OVER (ORDER BY ListPrice) GroupID,
      ProductID, Name, ListPrice
    FROM Production.Product
    WHERE ListPrice > 0
    



