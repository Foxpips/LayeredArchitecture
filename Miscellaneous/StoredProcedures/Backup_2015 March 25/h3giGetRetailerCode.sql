



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetRetailerCode
** Author			:	Gearóid Healy
** Date Created		:	05/07/2005
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure the code of a retailer
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/

CREATE  Procedure [dbo].[h3giGetRetailerCode]

	@RetailerName varchar(50)

as

	select retailercode
	from h3giretailer with(nolock)
	where retailername = @RetailerName





GRANT EXECUTE ON h3giGetRetailerCode TO b4nuser
GO
GRANT EXECUTE ON h3giGetRetailerCode TO helpdesk
GO
GRANT EXECUTE ON h3giGetRetailerCode TO ofsuser
GO
GRANT EXECUTE ON h3giGetRetailerCode TO reportuser
GO
GRANT EXECUTE ON h3giGetRetailerCode TO b4nexcel
GO
GRANT EXECUTE ON h3giGetRetailerCode TO b4nloader
GO
