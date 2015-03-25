-- =============================================
-- Author:		Adam
-- Create date: 5/12/2007
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[threeOrderItemReturnGet] 
	@returnNumber int,
	@returnType varchar(20),
	@unprocessedOnly bit = 1
AS
BEGIN
	
	SET NOCOUNT ON;

  	SELECT header.orderref,
			itemReturn.returnNumber, 
			itemReturn.returnType,
			itemReturn.returnProcessed,
			itemReturnDetails.returnReason as returnReason, 
			oldProduct.productName as oldHandsetName, 
			header.IMEI as oldIMEI, 
			(CASE WHEN itemReturn.returnType = 'Direct' THEN header.ICCID ELSE '' END) AS oldICCID,
			newProduct.productName as newHandsetName,
			itemReturnDetails.IMEI as newIMEI,
			ISNULL(deposit.depositAmount, 0) as depositAmount
	FROM threeOrderItemReturn itemReturn 
	INNER JOIN threeOrderItemReturnDetails itemReturnDetails
	ON itemReturn.returnNumber = itemReturnDetails.returnNumber
	AND itemReturn.returnType = itemReturnDetails.returnType
	INNER JOIN h3giOrderHeader header
	ON itemReturn.orderRef = header.orderRef
	INNER JOIN h3giProductcatalogue oldProduct
	ON header.catalogueVersionId = oldProduct.catalogueVersionId
	AND header.phoneProductCode = oldProduct.productFamilyId
	LEFT OUTER JOIN h3giProductcatalogue newProduct
	ON itemReturnDetails.catalogueVersionId = newProduct.catalogueVersionId
	AND itemReturnDetails.catalogueProductId = newProduct.catalogueProductId
	LEFT OUTER JOIN h3giOrderDeposit deposit
	ON header.orderref = deposit.orderref
	WHERE (itemReturn.returnNumber = @returnNumber)
	AND (itemReturn.returnType = @returnType)
	AND ( (@unprocessedOnly = 0) OR (@unprocessedOnly = 1 AND itemReturn.returnProcessed = 0))
	
END


GRANT EXECUTE ON threeOrderItemReturnGet TO b4nuser
GO
