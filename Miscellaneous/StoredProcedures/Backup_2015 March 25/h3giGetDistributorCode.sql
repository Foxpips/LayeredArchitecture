


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetDistributorCode
** Author		:	Peter Murphy
** Date Created		:	22/09/06
**					
**********************************************************************************************************************
**				
** Description		:	Returns the Distributor Code for a specified retailer
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - 22/09/06 - Initial version
**						
**********************************************************************************************************************/

create procedure dbo.h3giGetDistributorCode

@RetailerCode varchar(20)

as

begin

	select distributorcode from h3giretailer where retailercode = @retailercode

end

GRANT EXECUTE ON h3giGetDistributorCode TO b4nuser
GO
GRANT EXECUTE ON h3giGetDistributorCode TO ofsuser
GO
GRANT EXECUTE ON h3giGetDistributorCode TO reportuser
GO
