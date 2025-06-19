-- Subject             : SQL Server PIVOT and UNPIVOT
-- Created By          : Selcuk KILINC
-- Executed SQL Version: Microsoft SQL Server 2019 

-- Suggestions : Run the scripts step by step. First, we need to create a table and generate data.

-- PIVOT and UNPIVOT are SQL Server operations that allow you to transform data between rows and columns

--- PIVOT
--- PIVOT transforms rows into columns by aggregating data. 
--- It takes values from one column and spreads them across multiple columns as headers.

--SELECT <non-pivoted columns>, [column1], [column2], ...
--FROM (
--    <source query>
--) AS SourceTable
--PIVOT (
--    <aggregate function>(<value column>)
--    FOR <pivot column> IN ([column1], [column2], ...)
--) AS PivotTable

-- Original data
CREATE TABLE Sales (
    SalesYear INT,
    Quarter VARCHAR(10),
    Amount DECIMAL(10,2)
)

INSERT INTO Sales VALUES
(2023, 'Q1', 1000),
(2023, 'Q2', 1200),
(2023, 'Q3', 1100),
(2023, 'Q4', 1300),
(2024, 'Q1', 1150),
(2024, 'Q2', 1400),
(2024, 'Q3', 1250),
(2024, 'Q4', 1500)

---- Source table
select * from Sales

---- Example-1 pivot column is Quarter

select SalesYear,Q1,Q2,Q3,Q4
from (
select SalesYear, Quarter, Amount 
from Sales
) Source_Table
pivot(
sum(Amount)
for Quarter in (Q1,Q2,Q3,q4)
) as Pivot_Table

---- Example-2 pivot column is SalesYear

select Quarter,[2023] as [Year_2023],[2024] as [Year_2024] 
from(
select SalesYear, Quarter, Amount 
from Sales
)SourceTable
pivot(
sum(Amount)
for SalesYear in ([2023],[2024])
) as PivotTable

--- UNPIVOT
--- UNPIVOT does the reverse - it transforms columns into rows, 
--- converting column headers back into row values.

--SELECT <columns>, <pivot column>, <value column>
--FROM (
--    <source query>
--) AS SourceTable
--UNPIVOT (
--    <value column> FOR <pivot column> IN (<column list>)
--) AS UnpivotTable


-- Create pivoted table
CREATE TABLE SalesPivoted (
    SalesYear INT,
    Q1 DECIMAL(10,2),
    Q2 DECIMAL(10,2),
    Q3 DECIMAL(10,2),
    Q4 DECIMAL(10,2)
)

INSERT INTO SalesPivoted VALUES
(2023, 1000, 1200, 1100, 1300),
(2024, 1150, 1400, 1250, 1500)

--- Example

---- source table

select SalesYear,Quantity,Amount
from(
select SalesYear,Q1,Q2,Q3,Q4 
from SalesPivoted
) as ST
unpivot(
Amount for Quantity in (Q1,Q2,Q3,Q4)
) as UPT


---- clean test environment

drop table Sales
drop table SalesPivoted