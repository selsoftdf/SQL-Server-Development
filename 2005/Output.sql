-- Subject             : SQL Server output clause
-- Created By          : Selcuk KILINC
-- Version             : 1.0
-- Executed SQL Version: Microsoft SQL Server 2019 

-- Suggestions : Run the scripts step by step. First, we need to create a table and generate data.


--The OUTPUT clause returns information about rows affected by an INSERT, UPDATE, or DELETE statement. 
--This result set can be returned to the calling application and used for requirements such as controlling, archiving or logging.

-- Creating Test Environment

-- Create the EmployeeTraining table
CREATE TABLE EmployeeTraining (
    TrainingID       INT IDENTITY(5,5) PRIMARY KEY,
    EmployeeID       INT NOT NULL,
    TrainingName     NVARCHAR(100) NOT NULL,
    TrainingDate     DATE NOT NULL,
    CompletionStatus NVARCHAR(20) CHECK (CompletionStatus IN ('Completed', 'In Progress', 'Not Started'))
);

-- Generating records
INSERT INTO EmployeeTraining (EmployeeID, TrainingName, TrainingDate, CompletionStatus)
VALUES
(1001, 'Cybersecurity Basics', '2025-01-15', 'Completed'),
(1002, 'Data Privacy Regulations', '2025-02-20', 'Completed'),
(1003, 'Advanced Excel Training', '2025-03-10', 'In Progress'),
(1004, 'Project Management Fundamentals', '2025-04-05', 'Not Started'),
(1005, 'Effective Communication', '2025-03-22', 'Completed'),
(1001, 'Leadership Development', '2025-05-01', 'In Progress'),
(1006, 'Time Management', '2025-04-18', 'Completed'),
(1007, 'Remote Work Best Practices', '2025-02-28', 'Completed'),
(1008, 'Conflict Resolution', '2025-06-05', 'Not Started'),
(1002, 'Agile Methodology Overview', '2025-05-15', 'Completed');


select * from EmployeeTraining


--- 1- Use OUTPUT INTO with an INSERT statement
--- The following example inserts a row into the EmployeeTraining table and 
--- uses the OUTPUT clause to return the results of the statement to the 
--- @log table variable.

declare @log table (
    TrainingID       INT,
    EmployeeID       INT,
    TrainingName     NVARCHAR(100),
    TrainingDate     DATE,
    CompletionStatus NVARCHAR(20));

insert into EmployeeTraining 
output inserted.TrainingID,inserted.EmployeeID,inserted.TrainingName,inserted.TrainingDate,inserted.CompletionStatus
into @log
values(1002,'T-SQL Programming','2025-06-14','Not Started')


select * from @log

select * from EmployeeTraining

--- 2- Use OUTPUT with a DELETE statement
--- OUTPUT DELETED.* indicates that the results of the DELETE statement, that is, 
--- all columns in the deleted rows, will be retrieved.
--- It can be useful to delete things in a controlled way.


delete from EmployeeTraining
output deleted.*
where TrainingID=55

select * from EmployeeTraining

--- 3- Use OUTPUT INTO with an UPDATE statement
--- The following example is an UPDATE example. 
--- New records and old records are hold in the @logEmployee table variable.

declare @logEmployee table(
id				    int  identity(1,1),
EmployeeID          int,
NewTrainingDate     date,
OldlogEmployee      date,
NewCompletionStatus nvarchar(20),
OldCompletionStatus nvarchar(20)
)

update EmployeeTraining
set TrainingDate = GETDATE(),
    CompletionStatus = 'Not Started'
	output inserted.EmployeeID,
	       inserted.TrainingDate,
	       deleted.TrainingDate,
		   inserted.CompletionStatus,
		   deleted.CompletionStatus
	into @logEmployee
where EmployeeID=1001

select * from @logEmployee

select * from EmployeeTraining



------ To clean the environment

drop table EmployeeTraining



