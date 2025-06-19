-- Subject             : SQL Server Execute As
-- Created By          : Selcuk KILINC
-- Executed SQL Version: Microsoft SQL Server 2019 

-- Suggestions : Run the scripts step by step. First, we need to create a proc 


use AdventureWorks2019
go
--- create 2 user:  admin ---> it can be sysadmin and low_user ---> it has very limited privileges
--- then login with these 2 users 

--- In this case, the user calling the procedure must have access to the Vendor table.
create proc sp_GetVendor
with execute as caller
as
select AccountNumber,
       Name,
       CreditRating 
from Purchasing.Vendor

exec sp_GetVendor

drop proc sp_GetVendor

--- This procedure works with the schema owner's authorizations. 
--- It works even if the calling user does not have access to the Vendor table.

create proc dbo.sp_GetVendor
with execute as owner
as
select AccountNumber,
       Name,
       CreditRating 
from Purchasing.Vendor

exec dbo.sp_GetVendor

--- Allow low_user to execute the procedure
GRANT EXECUTE ON dbo.sp_GetVendor TO low_user

drop proc sp_GetVendor

---
create proc dbo.sp_GetVendor
with execute as 'low_user'
as
select AccountNumber,
       Name,
       CreditRating 
from Purchasing.Vendor

exec dbo.sp_GetVendor

-- It cannot acess
EXECUTE AS user='low_user'
GO
SELECT * from Purchasing.Vendor
GO
REVERT
GO

--- It can access
EXECUTE AS user='low_user'
GO
   exec dbo.sp_GetVendor
GO
REVERT
GO

---- clean environment

drop proc sp_GetVendor