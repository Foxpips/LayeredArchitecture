

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetCCDetailsForTimePeriod
** Author			:	Niall Carroll
** Date Created		:	26 May 2006
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Returns a list orders and their cc details for a given amount of hours
**					
*************************************************************************************************************************
**									
** Change Control	:	15/06/2006 - Peter Murphy - Add customer's Email address to the dataset
**
**						03/10/2008 - Stephen Quin - Delivery Address details now retrieved from the viewOrderAddress View
*************************************************************************************************************************/

CREATE  PROCEDURE [dbo].[h3giGetCCDetailsForTimePeriod]
	@HoursToCheck int = -1
AS

IF @HoursToCheck > 0 
	SET @HoursToCheck = 0 - @HoursToCheck
DECLARE @OrderRefs TABLE(orderRef INT PRIMARY KEY)

INSERT INTO @OrderRefs
	SELECT	orderRef
	FROM	b4nOrderHeader 
	WHERE	orderDate > DateAdd(hh, -1000000, GetDate())

SELECT	b4nHeader.billingForename, 
		h3giHeader.billingHouseNumber, 
		b4nHeader.billingSurname, 
		b4nHeader.billingAddr1, 
		b4nHeader.billingAddr2, 
		b4nHeader.billingAddr3, 
		b4nHeader.billingCity, 
		b4nHeader.billingCounty,
		b4nHeader.deliveryForeName, 
		b4nHeader.deliverySurName, 
		CASE WHEN LEN(viewAddress.apartmentNumber) > 0 THEN viewAddress.apartmentNumber + ' ' ELSE '' END +
		CASE WHEN LEN(viewAddress.houseNumber) > 0 THEN viewAddress.houseNumber + ' ' ELSE '' END +
		viewAddress.houseName AS deliveryAddr1, 
		viewAddress.street, 
		viewAddress.locality, 
		viewAddress.city, 
		viewAddress.county,
		transLog.chargeAmount,
		b4nHeader.ccNumber,
		classCode.b4nClassDesc as CCTypeID,
		b4nHeader.ccExpiryDate,
		orderRefs.orderRef,
		h3giHeader.retailerCode,
		orderLine.gen6,
		b4nHeader.email
FROM	@OrderRefs orderRefs 
		INNER JOIN b4nOrderHeader b4nHeader
		ON b4nHeader.orderRef = orderRefs.orderRef 
		INNER JOIN h3giOrderHeader h3giHeader 
			ON h3giHeader.OrderRef = orderRefs.orderRef
		INNER JOIN b4nCCTransactionLog transLog 
			ON transLog.B4NOrderRef = orderRefs.orderRef
			AND transLog.transactionItemType = 0
		INNER JOIN b4nOrderLine orderLine 
			ON orderLine.OrderRef = orderRefs.orderRef
		INNER JOIN b4nClassCodes classCode 
			ON classCode.b4nClassSysID = 'CreditCard' 
			AND classCode.b4nClassCode = Cast(b4nHeader.ccTypeID as varchar(2))
		INNER JOIN viewOrderAddress viewAddress 
			ON viewAddress.orderRef = orderRefs.orderRef
			aND viewAddress.addressType = 'Delivery'
WHERE	orderLine.gen6 = '1'
		AND	((transLog.TransactionType = 'FULL' AND transLog.resultCode = 0) OR (transLog.TransactionType = 'SHADOW' AND transLog.resultCode = 0))
		AND	h3giHeader.retailerCode in ('BFN01','BFN02')


GRANT EXECUTE ON h3giGetCCDetailsForTimePeriod TO b4nuser
GO
GRANT EXECUTE ON h3giGetCCDetailsForTimePeriod TO ofsuser
GO
GRANT EXECUTE ON h3giGetCCDetailsForTimePeriod TO reportuser
GO
