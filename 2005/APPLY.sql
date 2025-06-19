-- Subject             : SQL Server APPLY
-- Created By          : Selcuk KILINC
-- Executed SQL Version: Microsoft SQL Server 2019 

-- Suggestions : Run the scripts step by step. First, we need to create a table and generate data.

--- cross apply
--- CROSS APPLY returns only rows from the left table where the right-side expression returns at least one row. 
--- It's equivalent to an INNER JOIN but works with table-valued functions and correlated subqueries.

--SELECT columns
--FROM left_table
--CROSS APPLY (right_expression) AS alias


-- Create sample tables
CREATE TABLE Employees (
    EmployeeID INT,
    Name VARCHAR(50),
    DepartmentID INT
)

CREATE TABLE Orders (
    OrderID INT,
    EmployeeID INT,
    OrderDate DATE,
    Amount DECIMAL(10,2)
)

INSERT INTO Employees VALUES
(1, 'John Smith', 10),
(2, 'Jane Doe', 20),
(3, 'Bob Wilson', 10),
(4, 'Alice Brown', 30)

INSERT INTO Orders VALUES
(101, 1, '2024-01-15', 1500.00),
(102, 1, '2024-02-20', 2000.00),
(103, 2, '2024-01-25', 1200.00),
(104, 3, '2024-03-10', 1800.00),
(105, 3, '2024-03-15', 2200.00),
(106, 3, '2024-04-05', 1600.00)
-- Note: Employee 4 (Alice) has no orders

---- cross apply sample

select e.Name,o.OrderID,o.OrderDate, o.Amount 
from Employees as e
cross apply(
 select  OrderID,OrderDate, Amount
 from Orders 
 where e.EmployeeID=Orders.EmployeeID

) as o

---- outer apply

select e.Name,o.OrderID,o.OrderDate, o.Amount 
from Employees as e
outer apply(
 select  OrderID,OrderDate, Amount
 from Orders 
 where e.EmployeeID=Orders.EmployeeID
) as o

---- APPLY with table-valued functions

CREATE or ALTER FUNCTION dbo.GetEmployeeOrders(@EmployeeID INT, @TopN INT)
RETURNS TABLE
AS
RETURN (
    SELECT TOP (@TopN) OrderID, OrderDate, Amount
    FROM Orders
    WHERE EmployeeID = isnull(@EmployeeID,EmployeeID)
    ORDER BY OrderDate DESC
)

select e.Name,tvf.* 
from Employees as e
cross apply dbo.GetEmployeeOrders(e.EmployeeID,5) as tvf


---- Using System Table-Valued Functions

-- Using STRING_SPLIT (available in SQL Server 2016+)
CREATE TABLE Products (
    ProductID INT,
    ProductName VARCHAR(100),
    Tags VARCHAR(500)  -- Comma-separated tags
)

INSERT INTO Products VALUES
(1, 'Laptop', 'electronics,computer,portable'),
(2, 'Phone', 'electronics,mobile,communication'),
(3, 'Desk', 'furniture,office,wood')


select p.ProductName,
       t.value as Tags
from Products as p
cross apply string_split(p.Tags,',') as t


---- Clean Environment

drop table Products
drop table Employees
drop table Orders





