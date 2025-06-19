-- Subject             : SQL Server Ranking Functions
-- Created By          : Selcuk KILINC
-- Executed SQL Version: Microsoft SQL Server 2019 

---- Sample - 1 

begin try
          select 10/0
		  print 'We cannot see this message!'
end try

begin catch
           print 'An error occured!'
		   print 'Error line: '+ cast(error_line() as varchar(10))
		   print 'Error number: '+ cast(error_number() as varchar(10))
		   print 'Error message: '+ error_message()
end catch

print 'After TRY-CATCH'


---- Sample - 2

begin try
     begin tran
	  
	  insert into Sales.Currency values('XXXX','XXXX dirham',GETDATE())
	  
	  commit tran
	  select 'Transaction Committed'
end try 

begin catch
           if @@TRANCOUNT>0
		    rollback tran

		   select 'Transaction Rollbacked'
		   select ERROR_NUMBER()   as 'Error No',
		          ERROR_LINE()     as 'Error Line',
				  ERROR_MESSAGE()  as 'Error Message',
				  ERROR_SEVERITY() as 'Error Severity'
end catch


