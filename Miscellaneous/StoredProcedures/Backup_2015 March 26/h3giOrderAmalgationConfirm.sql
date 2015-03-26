
/*********************************************************************************************************************																				
* Procedure Name	: [h3giOrderAmalgationConfirm]
* Author			: Niall Carroll
* Date Created		: 21/03/2006
* Version			: 1.0.0
*					
**********************************************************************************************************************
* Description		: Returns a list of orders for amalg of order dockets (Confirm Screen)
**********************************************************************************************************************
* Change Control	: 1.0.0 - Initial Version
*			: 1.0.1 - Peter Murphy - 25/04/06 - Added PhoneStatus, OrderStatus, BatchStatus selection
**********************************************************************************************************************/

CREATE  PROCEDURE [dbo].[h3giOrderAmalgationConfirm]
	@OrderRefList varchar(4000)
AS

DECLARE @SQL varchar(5000)

DECLARE @GMDB varchar(40)
SELECT @GMDB = idValue FROM config WHERE idName = 'OFS4GMDatabase'

SET @SQL = 'SELECT 
	BOH.OrderRef, 
	BHIS.StatusDate, 
	CASE VOP.prePay
		WHEN 1 THEN ''Prepay''
		WHEN 0 THEN ''Contract''
	END AS type, 
	VOP.ProductName, 
	BOH.deliveryForename + '' '' + BOH.deliverySurName as CustName,
	CASE WHEN LEN(viewAddress.apartmentNumber) > 0 THEN viewAddress.apartmentNumber + '' '' ELSE '''' END +
	CASE WHEN LEN(viewAddress.houseNumber) > 0 THEN viewAddress.houseNumber + '' '' ELSE '''' END +
	viewAddress.houseName + '' '' + deliveryAddr2 + '' '' + deliveryAddr3 + 
	'' '' + deliveryCity + '' '' + deliveryCounty as DelAddr,

	gms_ol.statusDesc as PhoneStatus,
	gms_oh.statusDesc as OrderStatus,

	C.b4nClassDesc as BatchStatus

FROM b4nOrderHeader  BOH
	INNER JOIN h3gibatchOrder HBO ON BOH.OrderRef = HBO.OrderRef
	INNER JOIN h3giBatch HB ON HBO.BatchID = HB.BatchID
	INNER JOIN b4nOrderhistory BHIS ON BHIS.OrderRef = BOH.OrderRef AND BHIS.OrderStatus = 151
	INNER JOIN viewOrderPhone VOP ON BOH.Orderref = VOP.OrderRef
	INNER JOIN viewOrderAddress viewAddress ON BOH.orderRef = viewAddress.orderRef
		AND viewAddress.addressType = ''Delivery''
		AND viewAddress.orderRef IN (' + @OrderRefList + ')

	inner join b4nClassCodes C on HB.Status = C.b4nClassCode AND C.b4nClassSysID = ''BatchStatus''

	inner join ' + @GMDB + '..gmorderheader GMOH on GMOH.orderRef = BOH.OrderRef
	inner join ' + @GMDB + '..gmOrderLine GMOL on GMOL.OrderHeaderID = GMOH.OrderHeaderID AND gen3 = ''Y''
	inner join ' + @GMDB + '..gmStatus gms_ol on gms_ol.StatusID = gmol.StatusID AND gms_ol.TypeCode = ''IPQ''
	inner join ' + @GMDB + '..gmStatus gms_oh on gms_oh.StatusID = gmoh.StatusID AND gms_oh.TypeCode = ''OPQ''
WHERE
	BOH.OrderRef in (' + @OrderRefList + ')'

Print(@SQL)
EXEC(@SQL)


GRANT EXECUTE ON h3giOrderAmalgationConfirm TO b4nuser
GO
GRANT EXECUTE ON h3giOrderAmalgationConfirm TO ofsuser
GO
GRANT EXECUTE ON h3giOrderAmalgationConfirm TO reportuser
GO
