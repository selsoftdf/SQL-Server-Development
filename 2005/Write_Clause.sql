-- Subject             : SQL Server .write clause
-- Created By          : Selcuk KILINC
-- Executed SQL Version: Microsoft SQL Server 2019 

-- Suggestions : Run the scripts step by step. First, we need to create a table and generate data.

-- In SQL Server, the .WRITE method allows you to update columns with large data types 
-- such as varchar(max), nvarchar(max), and varbinary(max). 
-- This is especially useful for performance when working with large text or binary data.

-- Creating Test Table

CREATE TABLE ArticleContentTable (
    ArticleID INT PRIMARY KEY,
    Content   VARCHAR(max)
);

-- Generating some data

INSERT INTO ArticleContentTable (ArticleID, Content)
VALUES 
  (1, 'SQL Server supports partial updates on large value data types.'),
  (2, 'This is a sample article about data manipulation in SQL Server.');

select * from ArticleContentTable

--- 1-Replacing a specific part

update ArticleContentTable
set Content.write('modifies',20,7)
where ArticleID=1

select * from ArticleContentTable

--- 2-Add new 

--- add new to the end
UPDATE ArticleContentTable
SET Content.WRITE(' It explains the WRITE method.', NULL, 0)
WHERE ArticleID = 2;

select * from ArticleContentTable

--- add new at the beginning

update ArticleContentTable
set Content.write('WRITE Clause:',0,0)
where ArticleID=2

select * from ArticleContentTable


--- 3-Delete

UPDATE ArticleContentTable
SET Content.WRITE('', 20, 8)
WHERE ArticleID = 1;

select * from ArticleContentTable

--- 4- Replace all string after index n 

UPDATE ArticleContentTable
SET Content.WRITE('SELCUK', 4, NULL)
where ArticleID=1

select * from ArticleContentTable

--- Cleaning the environment
drop table ArticleContentTable



