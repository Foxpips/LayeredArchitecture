



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetRetailerName
** Author			:	Gearóid Healy
** Date Created		:	05/07/2005
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure the name of a retailer
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/

create Procedure [dbo].[h3giGetRetailerName]

	@RetailerCode varchar(20)

as

	select retailername
	from h3giretailer with(nolock)
	where retailercode = @RetailerCode





GRANT EXECUTE ON h3giGetRetailerName TO b4nuser
GO
GRANT EXECUTE ON h3giGetRetailerName TO helpdesk
GO
GRANT EXECUTE ON h3giGetRetailerName TO ofsuser
GO
GRANT EXECUTE ON h3giGetRetailerName TO reportuser
GO
GRANT EXECUTE ON h3giGetRetailerName TO b4nexcel
GO
GRANT EXECUTE ON h3giGetRetailerName TO b4nloader
GO
