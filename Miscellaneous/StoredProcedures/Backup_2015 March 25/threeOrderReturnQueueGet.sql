
-- =============================================
-- Author:		Stephen Quin
-- Create date: 07/12/07
-- Description:	Gets the returns queue
-- =============================================
CREATE PROCEDURE [dbo].[threeOrderReturnQueueGet] 
	@returnType AS varchar(20),
	@max int = 1000
AS
BEGIN
	--SQL 2005 hint - we can just say SELECT TOP @max

	SET ROWCOUNT @max	--old SQL 2000 way

	SELECT	
	itemReturn.returnNumber AS returnRef, 
			b4nHeader.orderref,
			COALESCE(REG.firstname, b4nHeader.billingForename) AS forename,
			COALESCE(REG.middleInitial, h3giHeader.initials) AS initials,
			COALESCE(REG.surname, b4nHeader.billingSurName) AS surname,
			COALESCE(REG.addrHouseName, h3giHeader.billingHouseName) AS houseName,
			COALESCE(REG.addrHouseNumber, h3giHeader.billingHouseNumber) AS houseNumber,
			COALESCE(REG.addrStreetName, b4nHeader.billingAddr1) AS address1,
			COALESCE(REG.addrLocality, b4nHeader.billingAddr2) AS address2,
			b4nHeader.billingAddr3 AS address3,
			COALESCE(REG.addrTownCity, b4nHeader.billingCity) AS city,
			COALESCE(REG.addrCounty, b4nHeader.billingCounty) AS county,
			b4nHeader.billingCountry AS country,
			itemReturn.returnDate,
--			CASE 
--				WHEN VOP.PrePay = 0 THEN 'Contract' 
--				WHEN VOP.PrePay = 1 THEN 'PrePay' 
--				WHEN VOP.PrePay = 2 THEN 'Upgrade' 
--			END AS custType,
			VOP.PrePay AS orderType
--			orderType.Title as orderType
	FROM	b4nOrderheader b4nHeader WITH(nolock) 
			INNER JOIN h3giOrderHeader h3giHeader WITH(nolock) 
			ON h3giHeader.orderRef = b4nHeader.orderRef
			INNER JOIN viewOrderPhone VOP 
			ON VOP.orderRef = b4nHeader.orderRef 
--			INNER JOIN h3giOrderType orderType
--			ON VOP.Prepay = orderType.orderTypeId
			LEFT OUTER JOIN threeOrderItemReturn itemReturn WITH (nolock)
			ON itemReturn.orderRef = b4nHeader.orderRef
			LEFT OUTER JOIN h3giRegistration REG
			ON REG.orderRef = b4nHeader.OrderRef
	WHERE	itemReturn.returnType = @returnType
			AND b4nHeader.status IN (312, 400)
			AND h3giHeader.itemReturned = 1
			AND itemReturn.returnProcessed = 0
	ORDER BY returnRef

	SET ROWCOUNT 0
END



GRANT EXECUTE ON threeOrderReturnQueueGet TO b4nuser
GO
GRANT EXECUTE ON threeOrderReturnQueueGet TO ofsuser
GO
GRANT EXECUTE ON threeOrderReturnQueueGet TO reportuser
GO
