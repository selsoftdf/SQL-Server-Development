-- Subject             : SQL Server top clause
-- Created By          : Selcuk KILINC
-- Executed SQL Version: Microsoft SQL Server 2022
 

-- Suggestions : Run the scripts step by step. First, we need to create a database and then create a table and generate data.
--               Once you have prepared the environment, you can start to understand the TOP clause. 
--               Again, run step by step and observe the results.
--               At the end you can drop your database. 


-- Preparing the environment
-- Step 1: Create database
create database Top_Sample;


-- Step 2: Create table and generate data
use Top_Sample
go

create table Projects(
Project_ID   varchar(20) not null,
Project_Name varchar(50),
Progress     int,
City		 varchar(20)
)

insert into Projects values('XYZ-1','Project 1',10,'Riyadh')
insert into Projects values('XYZ-2','Project 2',11,'Jeddah')
insert into Projects values('XYZ-3','Project 3',20,'Riyadh')
insert into Projects values('XYZ-4','Project 4',20,'Jeddah')
insert into Projects values('XYZ-5','Project 5',40,'Riyadh')
insert into Projects values('XYZ-6','Project 6',50,'Dammam')
insert into Projects values('XYZ-7','Project 7',55,'Riyadh')
insert into Projects values('XYZ-8','Project 8',65,'Riyadh')
insert into Projects values('XYZ-9','Project 9',70,'Riyadh')
insert into Projects values('XYZ-10','Project 10',80,'Riyadh')

alter table Projects
add constraint PK_Projects primary key(Project_ID)

-----------------------------------------To understand the topic------------------------------------------

--- Sample 1: top n clause
--- Retrieves the data from row 1 of the Project table in the default sort order.

select top 1 Project_ID,Project_Name,Progress,City 
from Projects

--- Sample 2: top n clause
--- It orders the results by the "Progress" column in ascending order, meaning it will return the 2 rows with the lowest progress values.

select top 2 Project_ID,Project_Name,Progress,City
from Projects
order by Progress asc

--- Sample 3: top (n) clause
--- You can also use parentheses. It returns same as previous one's data set.

select top (2) Project_ID,Project_Name,Progress,City
from Projects
order by Progress asc

--- Sample 4: top (n) clause
--- The advantage of parentheses is that you can do this dynamically

declare @n integer=3

select top(@n) Project_ID,Project_Name,Progress,City
from Projects
order by Progress asc 

--- Sample 5: top n with ties
--- "with ties" clause includes any additional rows that have the same value for "Progress" as the last row selected.

select top 3 with ties Project_ID,Project_Name,Progress,City
from Projects
order by Progress asc 

--- Sample 6: top (x) percent
--- It shows the x percent of data

declare @x integer = 40

select top (@x) percent Project_ID,Project_Name,Progress,City
from Projects
order by Progress asc 

--- Sample 7: top (y) percent with ties 
--- We can use percent and "with ties" at the same time but if we want to use TOP N WITH TIES clause, we need to put ORDER BY clause

declare @y int=30

select  top(@y) percent with ties Project_ID,Project_Name,Progress,City 
from Projects
order by Progress asc


--- Sample 8: update top(n)
--- This script updates the top 3 rows in the "Projects" table

update top(3) Projects
set Project_Name=Project_Name+'00'


select * from Projects

--- Sample 9: update top(n)
--- If you need to use TOP to apply updates in a meaningful order, you must use TOP with ORDER BY in a subselection statement

update Projects
set Project_Name=tbl.Project_Name+'00'
from (select top 3 * from Projects order by Progress desc) as tbl
where Projects.Project_ID=tbl.Project_ID and Projects.City=tbl.City 


select * from Projects


---- Sample 10
---- It deletes the top 1 country

delete top (1) from Projects
where Project_Name like '%00'

select * from Projects


---- Sample 11
---- It deletes the TOP n records in a meaningful order


delete from Projects
where Project_ID in ( select top (2) Project_ID from Projects order by Project_ID desc)

select * from Projects



---- Sample 12
---- We can also use percent with delete to remove n percent of record from the table.

delete top(50) percent from Projects

---- Last Step: Drop the database 
---- We can drop the database

use master
go
drop database Top_Sample;
