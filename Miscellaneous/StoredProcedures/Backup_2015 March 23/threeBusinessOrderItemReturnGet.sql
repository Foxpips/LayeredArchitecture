
-- =============================================
-- Author:		Adam
-- Create date: 5/12/2007
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[threeBusinessOrderItemReturnGet] 
	@returnNumber int,
	@returnType varchar(20),
	@unprocessedOnly bit = 1
AS
BEGIN
	
	SET NOCOUNT ON;

  	SELECT item.orderRef,
			item.itemId as orderItemId,
			itemReturn.returnNumber, 
			itemReturn.returnType,
			itemReturn.returnProcessed,
			itemReturnDetails.returnReason as returnReason, 
			oldProduct.productName as oldHandsetName, 
			item.IMEI as oldIMEI, 
			(CASE WHEN itemReturn.returnType = 'Direct' THEN item.ICCID ELSE '' END) AS oldICCID,
			ISNULL(newProduct.productName, '') as newHandsetName,
			itemReturnDetails.IMEI as newIMEI,
			item.endUserName as userName,
			ISNULL(deposit.depositAmount, 0) as depositAmount
	FROM threeOrderItemReturn itemReturn 
	INNER JOIN threeOrderItemReturnDetails itemReturnDetails
	ON itemReturn.returnNumber = itemReturnDetails.returnNumber
	AND itemReturn.returnType = itemReturnDetails.returnType
	INNER JOIN threeOrderItem item
	ON itemReturn.orderRef = item.orderRef
	AND itemReturnDetails.orderItemId = item.itemId
	INNER JOIN threeOrderItemProduct oldProduct
	ON item.itemId = oldProduct.itemId
	AND oldProduct.productType = 'HANDSET'
	LEFT OUTER JOIN h3giProductcatalogue newProduct
	ON itemReturnDetails.catalogueVersionId = newProduct.catalogueVersionId
	AND itemReturnDetails.catalogueProductId = newProduct.catalogueProductId
	LEFT OUTER JOIN h3giOrderDeposit deposit
	ON itemReturn.orderref = deposit.orderref
	WHERE (itemReturn.returnNumber = @returnNumber)
	AND (itemReturn.returnType = @returnType)
	AND item.parentItemId IS NOT NULL
	AND ( (@unprocessedOnly = 0) OR (@unprocessedOnly = 1 AND itemReturn.returnProcessed = 0))
	ORDER BY orderItemId;
	
END



GRANT EXECUTE ON threeBusinessOrderItemReturnGet TO b4nuser
GO
GRANT EXECUTE ON threeBusinessOrderItemReturnGet TO ofsuser
GO
GRANT EXECUTE ON threeBusinessOrderItemReturnGet TO reportuser
GO
