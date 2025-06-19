-- Subject             : SQL Server some and any
-- Created By          : Selcuk KILINC
-- Executed SQL Version: Microsoft SQL Server 2019 

-- Suggestions : These scripts run on AdventureWorks2019 sample database.

-- Explanation: The SOME and ANY operators are used in a WHERE clause to compare a scalar value with a single-column result set of values.
-- SOME and ANY are semantically equivalent.

USE AdventureWorks2019

--- Sample-1: It retrieves non Bikes sub-categories

select ProductSubcategoryID,Name 
from Production.ProductSubcategory
where ProductCategoryID <> some ( 
select ProductCategoryID 
from Production.ProductCategory
where Name='Bikes'
)

--- Sample-2: It returns all the employee addresses that are in Canada

    SELECT AddressLine1, City
    FROM Person.Address
    WHERE StateProvinceID = any(
       SELECT StateProvinceID
       FROM Person.StateProvince
       WHERE CountryRegionCode <> 'CA'
	   )

--- Sample-3: The WHERE clause in the main query checks for ProductID < ANY (3, 4), which is the same as ProductID < 3 OR ProductID < 4

    select * from Production.Product where ProductID < any(select 3 union all select 4)

--- Sample-4: The WHERE clause in the main query checks for ProductID >= ANY (990, 995), which is the same as ProductID >= 990 OR ProductID >= 995
    
	select * from Production.Product where ProductID >= some(select 990 union all select 995)

-- ALL Operator
-- Explanation: A row is returned if the scalar comparison to the single-column result set is true for all values in the column.

--- Sample-1:

select * from Production.ProductCategory where ProductCategoryID != all(select 1 union all select 2)

--- Sample-2:

CREATE TABLE T1
(ID int) ;
GO
INSERT T1 VALUES (1) ;
INSERT T1 VALUES (2) ;
INSERT T1 VALUES (3) ;
INSERT T1 VALUES (4) ;

IF 3 < ALL (SELECT ID FROM T1)
PRINT 'TRUE' 
ELSE
PRINT 'FALSE' ;

drop table T1

--- Sample-3: It returns nothing because you cannot compare a scalar value with (863,869)

SELECT [Name],ProductID
FROM [Production].[Product]
WHERE [ProductID] = ALL
(
    SELECT [ProductID] FROM [Sales].[SalesOrderDetail] WHERE [OrderQty] > 40
);
GO

---Sample-4:

SELECT [Name],ProductID
FROM [Production].[Product]
WHERE [ProductID] > ALL
(
    SELECT [ProductID] FROM [Sales].[SalesOrderDetail] WHERE [OrderQty] > 40
)
order by ProductID asc  



-------------- Try to realise the difference between SOME-ANY and ALL ----------------------------------

---Sample-1

-- Create a sample table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2),
    Department VARCHAR(50),
    IsActive BIT
);

-- Insert sample data
INSERT INTO Employees VALUES
(1, 'John', 'Doe', 50000, 'IT', 1),
(2, 'Jane', 'Smith', 60000, 'HR', 1),
(3, 'Mike', 'Johnson', 55000, 'IT', 0),
(4, 'Emily', 'Brown', 62000, 'Finance', 1),
(5, 'David', 'Wilson', 58000, 'Marketing', 1);


-- ALL Operator
SELECT * FROM Employees
WHERE Salary > ALL (
    SELECT Salary FROM Employees
    WHERE Department = 'IT'
);

-- ANY Operator
SELECT * FROM Employees
WHERE Salary > ANY (
    SELECT Salary FROM Employees
    WHERE Department = 'HR'
);

drop table Employees

---Sample-2

-- Create a sample table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2),
    CategoryID INT
);

-- Insert sample data
INSERT INTO Products VALUES
(1, 'Laptop', 1200, 1),
(2, 'Smartphone', 800, 1),
(3, 'Tablet', 500, 1),
(4, 'Desk', 300, 2),
(5, 'Chair', 150, 2);

-- Using ANY operator
SELECT ProductName, Price
FROM Products
WHERE Price > ANY (
    SELECT Price
    FROM Products
    WHERE CategoryID = 2
);

-- Using ALL operator
SELECT ProductName, Price
FROM Products
WHERE Price > ALL (
    SELECT Price
    FROM Products
    WHERE CategoryID = 2
);

--ANY operator:

--The query selects products where the price is greater than ANY price of products in category 2.
--This will return all products with a price greater than the lowest price in category 2 (150 in this case).


--ALL operator:

--The query selects products where the price is greater than ALL prices of products in category 2.
--This will return all products with a price greater than the highest price in category 2 (300 in this case).

drop table Products