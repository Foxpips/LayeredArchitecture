


/*********************************************************************************************************************																				
* Procedure Name	: [h3giOrderAmalgationDocket]
* Author			: Niall Carroll
* Date Created		: 21/03/2006
* Version			: 1.0.0
*					
**********************************************************************************************************************
* Description		: Returns a list of orders for amalg of order dockets (Confirm Screen)
**********************************************************************************************************************
* Change Control	: 1.0.0 - Initial Version
*					: 1.0.1 - Peter Murphy -24/04/06 - Added Billing Names to selection
*
*					01/10/08	-	Stephen Quin	-	Split the deliveryAddr1 field to remove the '<!!-!!>' characters
*														and then concatenate each part and return as deliveryAddr1
*************************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giOrderAmalgationDocket]
	@OrderRefList varchar(4000)
AS

SELECT

	HB.BatchID, 
	HBO.OrderRef, 
	billingForeName, 
	billingSurName, 
	deliveryForeName, 
	deliverySurName,
	CASE WHEN LEN(viewAddress.apartmentNumber) > 0 THEN viewAddress.apartmentNumber + ' ' ELSE '' END +
	CASE WHEN LEN(viewAddress.houseNumber) > 0 THEN viewAddress.houseNumber + ' ' ELSE '' END +
	viewAddress.houseName AS deliveryAddr1,
	deliveryAddr2, 
	deliveryAddr3, 
	deliveryCity, 
	deliveryCounty, 
	ccNumber, VOP.productName, 
	1 as qty,
 	BOL.Price, 
	'' as IMEI, 
	'' as SCCID, 
	HB.Courier, 
	isnull(VOP.PrePay, '-1') as PrePay, 
	REG.firstname, 
	REG.surname
FROM 
	h3giBatch HB inner join h3giBatchOrder HBO on HB.BatchID = HBO.BatchID
		inner join h3giOrderHeader HOH on HOH.OrderRef = HBO.OrderRef
		inner join b4nOrderHeader BOH on BOH.OrderRef = HOH.OrderRef
		inner join b4nOrderLine BOL on BOH.OrderRef = BOL.Orderref
		inner join viewOrderAddress viewAddress on BOH.orderRef = viewAddress.orderRef
		and viewAddress.addressType = 'Delivery'
		inner join viewOrderPhone VOP on VOP.OrderRef = HOH.OrderRef
		left outer join h3giRegistration REG on REG.orderref = HOH.orderref
WHERE 
	HBO.OrderRef in (SELECT Value FROM fnSplitter(@OrderRefList))
ORDER BY
	HBO.AddedOrder


GRANT EXECUTE ON h3giOrderAmalgationDocket TO b4nuser
GO
GRANT EXECUTE ON h3giOrderAmalgationDocket TO ofsuser
GO
GRANT EXECUTE ON h3giOrderAmalgationDocket TO reportuser
GO
