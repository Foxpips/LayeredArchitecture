
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threeBusinessProvisioningSearch
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	Search for business provisioning file number from audit table				
**					
**********************************************************************************************************************
**									
** Change Control	:	05/11/2007 - Adam Jasinski - Created
**
**********************************************************************************************************************/
CREATE PROCEDURE dbo.threeBusinessProvisioningSearch
	@OrderRef 	int = null,
	@IMEI 		varchar(25) = null,
	@ICCID		varchar(25) = null
AS
BEGIN

	SELECT	orderHeader.orderRef, 
				orderHeader.orderDate, 
				dbo.fn_getClassDescriptionByCode('StatusCode', orderHeader.orderStatus) as Status,
				orderHeader.channelCode,
				(person.firstName + ' ' + person.lastName) as Name, 
				 address.fullAddress as Address, 
				orderItem.IMEI, 
				orderItem.ICCID, 
				salesAudit.sequence_no as ProvisioningNo
	FROM         threeOrderHeader AS orderHeader 
	INNER JOIN   threeOrderItem AS orderItem ON orderHeader.orderRef = orderItem.orderRef AND orderItem.parentItemId IS NOT NULL 
	INNER JOIN	 h3giSalesCapture_Audit AS salesAudit ON orderHeader.orderRef = salesAudit.orderref 
	INNER JOIN	 threeOrganization AS organization ON orderHeader.organizationId = organization.organizationId 
	INNER JOIN	 threePerson AS person ON organization.organizationId = person.organizationId AND person.personType = 'Contact' 
	INNER JOIN	 threeOrganizationAddress AS address ON organization.organizationId = address.organizationId AND address.addressType = 'BillingBusiness'
	WHERE COALESCE(@OrderRef, orderHeader.orderRef) = orderHeader.orderRef
	AND COALESCE(@IMEI, orderItem.IMEI) = orderItem.IMEI
	AND COALESCE(@ICCID, orderItem.ICCID) = orderItem.ICCID
	ORDER BY orderHeader.orderRef, orderItem.IMEI, orderItem.ICCID

END

GRANT EXECUTE ON threeBusinessProvisioningSearch TO b4nuser
GO
GRANT EXECUTE ON threeBusinessProvisioningSearch TO reportuser
GO
