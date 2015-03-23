


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giUpdateSalesAssociateData
** Author			:	?
** Date Created		:	
** Version			:	1.1.0
**					
**********************************************************************************************************************
**				
** Description		:	SETs an ICCID/IMEI/Slingbox serial
**					
**********************************************************************************************************************
**									
** Change Control	:	1 AUG 2013 Simon Markey new sproc for updating retailer info for click collect orders
**********************************************************************************************************************/
CREATE proc [dbo].[h3giUpdateSalesAssociateData]
@OrderRef 		INT,
@salesAssociateId int,
@salesAssociateName varchar(100)
AS

UPDATE h3giorderHeader 
SET mobileSalesAssociatesNameId = @salesAssociateId,
	currentMobileSalesAssociatedName  = @salesAssociateName
WHERE OrderRef = @OrderRef

GRANT EXECUTE ON h3giUpdateSalesAssociateData TO b4nuser
GO
GRANT EXECUTE ON h3giUpdateSalesAssociateData TO reportuser
GO
