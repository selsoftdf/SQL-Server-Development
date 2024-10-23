-- Subject             : SQL Server output clause
-- Created By          : Selcuk KILINC
-- Version             : 1.0
-- Executed SQL Version: Microsoft SQL Server 2019 

-- Suggestions : Run the scripts step by step. First, we need to create a table and generate data.


--The OUTPUT clause returns information about rows affected by an INSERT, UPDATE, or DELETE statement. 
--This result set can be returned to the calling application and used for requirements such as controlling, archiving or logging.

------ Preparing the environment
------ Step 1: Create a table and generate data

 CREATE TABLE OutputSample
    (
        ID int NOT NULL,
        Description varchar(100) NOT NULL,
    )

    INSERT INTO OutputSample (ID, Description) VALUES (1, 'row 1')
    INSERT INTO OutputSample (ID, Description) VALUES (2, 'row 2')
    INSERT INTO OutputSample (ID, Description) VALUES (3, 'row 3')

----- Sample 1: delete


		create table #log(
		 ID 		  int,
		 Description  varchar(100),
		 Insert_Date  datetime default(getdate())
		)

		delete from OutputSample
		output deleted.ID,deleted.Description into #log(ID,Description)
		where ID=3

		select * from #log

		select * from OutputSample

		drop table #log

----- Sample 2: insert

		create table #log(
		 ID 		  int,
		 Description  varchar(100),
		 Insert_Date  datetime default(getdate())
		)

		insert OutputSample(ID,Description) 
		output inserted.ID,inserted.Description into #log(ID,Description)
		values(3,'row 3')

	    insert OutputSample(ID,Description) 
		output inserted.ID,inserted.Description into #log(ID,Description)
		values(4,'row 4')

		insert OutputSample(ID,Description) 
		output inserted.ID,inserted.Description into #log(ID,Description)
		values(4,'row 4')

		select * from #log

		select * from OutputSample

		drop table #log

----- Sample 3: update
		create table #log(
		 ID 		  int,
		 Description  varchar(100),
		 Insert_Date  datetime default(getdate())
		)

	    update OutputSample
		set ID=5, Description='row 5'
		output deleted.ID,deleted.Description into #log(ID,Description)
		where ID=4


		select * from #log

		select * from OutputSample

		drop table #log


----- Sample 4: delete and insert sample

      delete top (1) from OutputSample
	  output deleted.*

	  insert into OutputSample 
	  output inserted.*
	  values(1,'row 1')


	  select * from OutputSample

----- Sample 5: update sample

	  
	  ;with cte as(
	  	   select *,ROW_NUMBER() over(partition by ID order by ID asc) as rwn 
	       from OutputSample
	  )

	   update cte
	   set ID=4, Description='row 4'
	   output deleted.ID,deleted.Description, inserted.ID, inserted.Description
	   where ID=5 and rwn=1


	  select * from OutputSample

----- Sample 6: update sample

		create table #log(
				 Insert_ID 		     int null,
				 Insert_Description  varchar(100) null,
				 Delete_ID           int null,
				 Delete_Description  varchar(100) null,
				 dml_type     char(1),
				 Insert_Date  datetime default(getdate())
				)


	   insert into OutputSample(ID,Description)
	   output inserted.ID,inserted.Description,'I' into #log(Insert_ID,Insert_Description,dml_type)
	   values(6,'row 6'),(7,'row 7')

	   select * from #log

	   update OutputSample
	   set ID=70, Description='row 70'
	   output inserted.ID,inserted.Description,deleted.ID,deleted.Description,'U' into #log(Insert_ID,Insert_Description,Delete_ID,Delete_Description,dml_type)
	   where ID=7

	   select * from #log

	   delete OutputSample
	   output deleted.ID,deleted.Description,'D' into #log(Delete_ID,Delete_Description,dml_type)
	   where ID=70
		
		select * from #log
		select * from OutputSample

		drop table #log


------ To clean the environment

drop table OutputSample


