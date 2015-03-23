CREATE PROC [dbo].[H3GIGetRunSheet]

@TodaysSheet bit = 0,
@DateFrom varchar(40) = '',
@DateTo varchar(40) = ''

AS

DECLARE @GMDB varchar(40)
DECLARE @SQL varchar(400)



IF @TodaysSheet = 1
BEGIN
	DECLARE @Yest DateTime
	SET	@Yest = DateAdd(dd, -1, GetDate())
	SET	@DateFrom = Cast(Day(@Yest) as varchar(2)) + '/' + Cast(Month(@Yest) as varchar(2)) + '/' + Cast(Year(@Yest) as varchar(4))
	SET @DateTo = Cast(Day(GetDate()) as varchar(2)) + '/' + Cast(Month(GetDate()) as varchar(2)) + '/' + Cast(Year(GetDate()) as varchar(4))
END

CREATE TABLE #temp (orderRef int, statusDesc varchar(40))

SELECT @GMDB = idValue FROM config with(nolock) WHERE idName = 'OFS4GMDatabase'
SET @SQL = 'INSERT INTO #temp SELECT GOH.OrderRef, GS.StatusDesc FROM ' + @GMDB + '..gmOrderHeader GOH
			inner join ' + @GMDB + '..gmStatus GS on GOH.StatusID = GS.StatusID WHERE GS.statusID in (3, 4, 40, 41, 42)'
EXEC (@SQL)

SELECT 
	b4n.OrderRef, 
	(select MAX(StatusDate) FROM b4nOrderHistory BOH where b4n.OrderRef = BOH.OrderRef AND OrderStatus = 309) as DispatchedDate,
	(select StatusDesc from #temp WHERE OrderRef = b4n.OrderRef)as Status,
	b4n.billingForeName + ' ' + b4n.BillingSurName as CustomerName,
	REPLACE (CASE WHEN LEN(viewAddress.apartmentNumber) > 0 THEN viewAddress.apartmentNumber + ' ' ELSE '' END +
			 CASE WHEN LEN(viewAddress.houseNumber) > 0 THEN viewAddress.houseNumber + ' ' ELSE '' END +
			 viewAddress.houseName + ' ' +  DeliveryAddr2 + ' ' + deliveryAddr3 + ' ' + deliveryCity + ' ' + deliveryCounty , '  ', ' ') as Address,
	DeliveryNote as DeliveryNote,
	DeliveryTelephone,
	DeliveryMobile,
	WorkPhoneAreaCode + ' ' + workPhoneNumber as WorkPhone,
	HomePhoneAreaCode + ' ' + HomePhoneNumber as HomePhone,
	daytimeContactAreaCode + ' ' + dayTimeContactNumber as ContactNumber
	
FROM b4nOrderHeader b4n with(nolock)
	inner join h3giOrderHeader HOH on b4n.OrderRef = HOH.OrderRef
	inner join viewOrderAddress viewAddress 
		ON b4n.orderRef = viewAddress.orderRef
		AND viewAddress.addressType = 'Delivery'
WHERE b4n.OrderRef in 
(
	SELECT DISTINCT OrderRef 
	FROM 	b4nOrderHistory with(nolock)
	WHERE 	OrderStatus = 309
	AND		(@DateFrom = '' OR (StatusDate > @DateFrom))
	AND		(@DateTo = '' OR (StatusDate < @DateTo))

)
	AND b4n.OrderRef in (select OrderRef from #Temp)
AND deliveryCounty = 'Dublin'


GRANT EXECUTE ON H3GIGetRunSheet TO b4nuser
GO
GRANT EXECUTE ON H3GIGetRunSheet TO ofsuser
GO
GRANT EXECUTE ON H3GIGetRunSheet TO reportuser
GO
