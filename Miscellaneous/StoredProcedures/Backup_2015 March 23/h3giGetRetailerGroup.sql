
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetRetailerGroup
** Author		:	Peter Murphy
** Date Created		:	24/03/06
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure returns a single group ID for a retailer
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/


create procedure dbo.h3giGetRetailerGroup

@RetailerCode varchar(20) = ''

AS


select GroupID from h3giSMSGroupDetail where RetailerCode = @RetailerCode



GRANT EXECUTE ON h3giGetRetailerGroup TO b4nuser
GO
GRANT EXECUTE ON h3giGetRetailerGroup TO ofsuser
GO
GRANT EXECUTE ON h3giGetRetailerGroup TO reportuser
GO
