-- Subject             : SQL Server cte
-- Created By          : Selcuk KILINC
-- Executed SQL Version: Microsoft SQL Server 2022

-- Suggestions : These scripts run on AdventureWorks2019 sample database.

-- Explanation: A common table expression (CTE) is a temporary named result set derived from a simple query. 
-- It exists within the scope of a SELECT, INSERT, DELETE, UPDATE, or CREATE VIEW statement.

use AdventureWorks2019;

-- Sample-1: select CTE 
-- The following query uses a CTE to display the number of employees under each department in AdventureWorks2019

with DepartmentEmployees(Dep_id,Dep_Name,Quantity) as
(
	select d.DepartmentID,d.Name,COUNT(e.BusinessEntityID) as Employee_Count
	from HumanResources.Department as d
	left join HumanResources.EmployeeDepartmentHistory as edh on d.DepartmentID=edh.DepartmentID
	inner join HumanResources.Employee as e on edh.BusinessEntityID=e.BusinessEntityID
	where edh.EndDate is null
	group by d.DepartmentID,d.Name
) 
select Dep_id,Dep_Name,Quantity
from DepartmentEmployees

---NOTE: The WITH clause requires the preceding statement to be terminated with a semicolon (;).

-- Sample-2: Basic Recursion sample
-- Create a table and insert some data

-- Create an employee table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    ManagerID INT
);

-- Insert sample data
INSERT INTO Employees (EmployeeID, Name, ManagerID)
VALUES 
    (1, 'John Doe', NULL),
    (2, 'Jane Smith', 1),
    (3, 'Bob Johnson', 1),
    (4, 'Alice Brown', 2),
    (5, 'Charlie Davis', 2),
    (6, 'Eve Wilson', 3),
    (7, 'Frank Miller', 3),
	(8, 'Nelson Miller', 5);

--- Basic Recursive Query
--- The output of the query shows how employees are organized hierarchically.
;with EmployeeHierarchy as
(
  select EmployeeID,Name,       ---> anchor member
         ManagerID,1 as [Level] 
  from Employees
  where ManagerID is null

  union all 

  select e.EmployeeID, e.Name, e.ManagerID, eh.Level + 1    ---> recursive member
  from Employees e
  inner join EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy
ORDER BY Level, EmployeeID;


--- Sample-3: Limit the recursion
--- You can limit the number of recursions by specifying a MAXRECURSION query hint.
--- If we restrict the recursion, it gets an error.
--- Error: The statement terminated. The maximum recursion (n) has been exhausted before statement completion.


;with EmployeeHierarchy as
(
  select EmployeeID,Name,       ---> anchor member
         ManagerID,1 as [Level] 
  from Employees
  where ManagerID is null

  union all 

  select e.EmployeeID, e.Name, e.ManagerID, eh.Level + 1    ---> recursive member
  from Employees e
  inner join EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy
ORDER BY Level, EmployeeID
OPTION (MAXRECURSION 2)


-- NOTE:The OPTION (MAXRECURSION 0) clause in SQL is used to set the maximum recursion depth for recursive common table expressions (CTEs)
-- SQL Server 2005: Default limit of 100 levels, cannot be increased.

-- Clean the environment
drop table Employees



