CREATE proc dbo.b4nCleanUpAnonymousCustomers
as
begin
	 

if exists(select customerid from b4ncustomer with(nolock) where customerid <= 100000  and customerid > 85000 ) 
		begin 
		
				insert into b4nReportCleanup 
			 select 'h3gi',
			isnull(max(customerId),0),getdate() from b4ncustomer with(nolock) where customerid <= 100000  and customerid > 85000 

			

		delete  from b4ncustomer  where customerid <= 100000  
			and customerid > 100 

		delete  from b4nbasket  where customerid <= 100000  
			and customerid > 100 


		 end 

end




GRANT EXECUTE ON b4nCleanUpAnonymousCustomers TO b4nuser
GO
GRANT EXECUTE ON b4nCleanUpAnonymousCustomers TO ofsuser
GO
GRANT EXECUTE ON b4nCleanUpAnonymousCustomers TO reportuser
GO
