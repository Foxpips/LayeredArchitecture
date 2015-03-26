/*********************************************************************************************************************																				
* Procedure Name	: [h3giOrderAmalgationSelection]
* Author			: Niall Carroll
* Date Created		: 21/03/2006
* Version			: 1.0.0
*					
**********************************************************************************************************************
* Description		: Returns a list of orders for amalg of order dockets (Selection Screen)
**********************************************************************************************************************
* Change Control	: 
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giOrderAmalgationSelection]
	@ccNumber varchar(100)
AS

SELECT 
	BOH.OrderRef, 
	BHIS.StatusDate, 
	VOP.prePay, 
	VOP.ProductName, 
	BOH.deliveryForename + ' ' + BOH.deliverySurName CustName,
	CASE WHEN LEN(viewAddress.apartmentNumber) > 0 THEN viewAddress.apartmentNumber + ' ' ELSE '' END +
	CASE WHEN LEN(viewAddress.houseNumber) > 0 THEN viewAddress.houseNumber + ' ' ELSE '' END +
	viewAddress.houseName AS deliveryAddr1,
	deliveryAddr2,
	deliveryAddr3,
	deliveryCity,
	deliveryCounty

FROM b4nOrderHeader  BOH
	INNER JOIN h3gibatchOrder HBO ON BOH.OrderRef = HBO.OrderRef
	INNER JOIN h3giBatch HB ON HBO.BatchID = HB.BatchID
	INNER JOIN b4nOrderhistory BHIS ON BHIS.OrderRef = BOH.OrderRef AND BHIS.OrderStatus = 151
	INNER JOIN viewOrderPhone VOP ON BOH.Orderref = VOP.OrderRef
	INNER Join viewOrderAddress viewAddress 
		ON BOH.orderRef = viewAddress.orderRef
		AND viewAddress.addressType = 'Delivery'
WHERE
	ccNumber = @ccNumber


GRANT EXECUTE ON h3giOrderAmalgationSelection TO b4nuser
GO
GRANT EXECUTE ON h3giOrderAmalgationSelection TO ofsuser
GO
GRANT EXECUTE ON h3giOrderAmalgationSelection TO reportuser
GO
