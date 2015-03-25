




CREATE   PROCEDURE dbo.h3giAccessoryOrderBatchGet 
	@orderRef int 
AS
BEGIN
	SELECT
		pc.catalogueProductID
		,bol.productId productFamilyId
		,pc.productType
		,dbo.fn_GetS4NAttributeValueByProductFamilyId('Product Name',bol.productId) productDisplayName
		,dbo.fn_GetS4NAttributeValueByProductFamilyId('DescriptiON',bol.productId) productDescriptiON
		,dbo.fn_GetS4NAttributeValueByProductFamilyId('Base Image Name - Small (.jpg OR .gif)',bol.productId) productImage
		,dbo.fn_GetS4NAttributeValueByProductFamilyId('Corporate Link - HANDset',bol.productId) productMoreInfoLink
		,dbo.fn_GetS4NAttributeValueByProductFamilyId('Base Price',bol.productId) shop4nowBasePrice
		,pc.productBasePrice
		,pc.peoplesoftId productPeoplesoftId
		,pc.productChargeCode
		,bol.orderLineId
		,bol.refunded
		,ISNULL(cc.passRef,'') transactionPassRef
	FROM b4norderheader boh
	INNER JOIN h3giOrderHeader hoh
		ON hoh.orderRef = boh.orderRef
	INNER JOIN b4nOrderLine bol
		ON bol.orderRef = boh.orderRef
	INNER JOIN h3giProductCatalogue pc
		ON pc.catalogueVersiONId = hoh.catalogueVersiONId
		AND pc.catalogueProductId = dbo.fnGetCatalogueProductIdFROMS4NProductId(bol.productId)
	left outer join b4nccTransactionLog cc 
		on cc.b4nOrderRef = boh.OrderRef and cc.ResultCode = 0 
		and TransactionType in ('FULL', 'SETTLE') and transactionItemType = 0
	WHERE boh.orderRef = @orderRef
	AND pc.productType = 'ACCESSORY'
END





GRANT EXECUTE ON h3giAccessoryOrderBatchGet TO b4nuser
GO
GRANT EXECUTE ON h3giAccessoryOrderBatchGet TO ofsuser
GO
GRANT EXECUTE ON h3giAccessoryOrderBatchGet TO reportuser
GO
