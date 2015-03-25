

/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.h3giGetSimpleOrderInfo
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:					
**					
**********************************************************************************************************************
**									
** Change Control	:				-	Adam Jasinski	-	Created
**						30/07/13	-	Stephen Quin	-	ProductName and isLinked returned
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giGetSimpleOrderInfo]
	@orderRef int = 0, 
	@p2 int = 0
AS
BEGIN
	DECLARE @productNameAttributeId INT
	SET @productNameAttributeId = dbo.fn_GetAttributeByName('Product Name')

	SELECT 
		hoh.orderRef,
		hoh.channelCode,
		hoh.retailerCode,
		hoh.storeCode,
		boh.GoodsPrice as totalAmount,
		boh.status as orderStatus,
		hoh.orderType,
		boh.orderDate,
		CASE WHEN hoh.Proxy = 'Y' THEN 1 ELSE 0 END as isProxyOrder,		
		CASE WHEN sr.rolename = 'Internal' THEN 1 ELSE 0 END as isInternalOrder,
		hoh.fraudDecisionFlow as isFraudMember,
		CASE WHEN dep.depositId IS NOT NULL THEN 1 ELSE 0 END as hasDeposit,
		CASE ISNULL(link.linkedOrderRef,'') 
			WHEN '' THEN 0
			ELSE 1 
		END AS isLinked,
		ISNULL(apf2.attributeValue,'') AS productDisplayName,
		cat.peoplesoftID,
		hoh.isTestOrder
	FROM h3giOrderHeader hoh WITH(NOLOCK)
	INNER JOIN b4nOrderHeader boh WITH(NOLOCK)
		ON hoh.orderRef = boh.orderRef
	INNER JOIN h3giProductCatalogue cat WITH(NOLOCK)
		ON hoh.catalogueVersionID = cat.catalogueVersionID
		AND hoh.phoneProductCode = cat.productFamilyId
	LEFT OUTER JOIN h3giOrderDeposit dep WITH(NOLOCK)
		ON dep.orderRef = boh.orderRef	
	LEFT OUTER JOIN smapplicationusers su WITH(NOLOCK)
		ON hoh.telesalesID = su.userid
	LEFT OUTER JOIN smrole sr WITH(NOLOCK)
		on su.roleid = sr.roleid
	LEFT OUTER JOIN h3giLinkedOrders link WITH(NOLOCK)
		ON hoh.orderRef = link.orderRef
	LEFT OUTER JOIN b4nAttributeProductFamily apf2 WITH(NOLOCK) 
		ON apf2.productFamilyId = hoh.phoneProductCode
		AND apf2.attributeId = @productNameAttributeId
	WHERE hoh.orderRef = @orderRef
END





GRANT EXECUTE ON h3giGetSimpleOrderInfo TO b4nuser
GO
