-- ========================================================
-- Author:		Stephen Quin	
-- Create date: 10/12/07
-- Description:	Gets the returns queue for business orders
-- ========================================================
CREATE PROCEDURE [dbo].[threeBusinessOrderReturnQueueGet]
	@searchType AS varchar(20)AS
BEGIN
	SELECT  DISTINCT itemReturn.returnNumber AS returnRef,
			orderHeader.orderRef,
			ISNULL(administrator.firstName, '') + ' ' + ISNULL(administrator.middleInitial, '') + ' ' + ISNULL(administrator.lastName, '') AS name,			
			address.fullAddress AS address,
			organization.tradingName AS companyName,
			itemReturn.returnDate
	FROM	threeOrderHeader orderHeader
			INNER JOIN threeOrderItem item
			ON item.orderRef = orderHeader.orderRef
			AND item.parentItemId IS NOT NULL
			INNER JOIN threeOrganization organization
			ON organization.organizationId = orderHeader.organizationId
			INNER JOIN threeOrganizationAddress address
			ON address.organizationId = organization.organizationId
			AND addressType IN ('Registered','Business')
			INNER JOIN threePerson administrator
			ON administrator.organizationId = organization.organizationId		
			AND personType = 'Administrator1'
			LEFT OUTER JOIN threeOrderItemReturn itemReturn
			ON itemReturn.orderRef = orderHeader.orderRef
	WHERE	itemReturn.returnType = @searchType
			AND orderHeader.orderStatus = 312
			AND item.itemReturned = 1
			AND itemReturn.returnProcessed = 0
END


GRANT EXECUTE ON threeBusinessOrderReturnQueueGet TO b4nuser
GO
