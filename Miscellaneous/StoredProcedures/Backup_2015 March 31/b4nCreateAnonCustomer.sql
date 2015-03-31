


/****** Object:  Stored Procedure dbo.b4nCreateAnonCustomer    Script Date: 23/06/2005 13:31:04 ******/

/*********************************************************************************************************************
**																					
** Procedure Name	:	b4nCreateAnonCustomer
** Author			:	Neil Murtagh
** Date Created		:	06/05/2005
** Version			:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored creates anonymous user ids
**					
**********************************************************************************************************************
**									
** Change Control	: 	
**						
**********************************************************************************************************************/


 
CREATE  PROCEDURE [dbo].[b4nCreateAnonCustomer]
	@storeID int,
	@zoneID int,
	@customerType int = 0,
	@affinityGroupId int =0,
	@customerID int output
as
 
begin
 
	declare @err int
	
	set nocount on

	BEGIN TRAN
	
	set @CustomerID = (Select isnull(max(customerid), 1) from b4ncustomer WITH(TABLOCKX) where customerid < 100000 )
	set @err = 1
	
	while(@err <> 0)
	begin
		set @CustomerID = @CustomerID + 1
		
		insert into b4nCustomer with(rowlock)
		(customerID, storeID, zoneID,createDate,modifyDate, affinityGroupId, customerType) 
		values
		(@CustomerID,@StoreID,@zoneID,getdate(),getdate(), @affinityGroupId, @customerType)
		set @err = @@error
	end

	COMMIT

	select @CustomerID as customerID
	
	end
 







GRANT EXECUTE ON b4nCreateAnonCustomer TO b4nuser
GO
GRANT EXECUTE ON b4nCreateAnonCustomer TO ofsuser
GO
GRANT EXECUTE ON b4nCreateAnonCustomer TO reportuser
GO
