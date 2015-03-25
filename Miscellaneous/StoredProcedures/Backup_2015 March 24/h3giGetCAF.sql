

-----------------------------


/*********************************************************************************************************************																				
* Procedure Name	: [h3giGetCAF]
* Author			: Niall Carroll
* Date Created		: 07/11/2005
* Version			: 1.0.0
*					
**********************************************************************************************************************
* Description		: Returns Details for CAF form
**********************************************************************************************************************
* Returns			: 
**********************************************************************************************************************
* Change Control	: 
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giGetCAF]
@OrderRef int
AS

IF EXISTS (SELECT OrderRef FROM h3giCAF WHERE OrderRef = @OrderRef)
BEGIN
SELECT 
	OrderRef,			
	StoreName,			
	SalesAssoicateName,
	StorePhone,
	RequestDate,
	MSISDN,
	Title,
	FirstName,
	Surname,
	Address,
	City,
	Country,	
	AlternativeNumber,	
	CurrentMobileNumber,
	CurrentNetwork,	
	CurrentPackage,	
	CurrentAccount,	
	UseAlternativeDate,
	AlternativeDD,	
	AlternativeMM,	
	AlternativeYY,	
	AlternativeHH,	
	AlternativeMin		
FROM
	[dbo].[h3giCAF] WITH (NOLOCK)
WHERE
	Orderref = @OrderRef
END
ELSE
BEGIN


-- ALT DATE PROCESSING
DECLARE @AltPortDate 	DateTime
DECLARE @AlternativeDD 	int
DECLARE @AlternativeMM 	int
DECLARE @AlternativeYY 	int
DECLARE @AlternativeHH 	int
DECLARE @AlternativeMin int	
DECLARE @UseAlt 		int

SELECT @AltPortDate = currentMobileAltDatePort FROM [h3giOrderExistingMobileDetails] WHERE OrderRef = @OrderRef

IF IsNull (@AltPortDate, 0) < GetDate() 
	SET @AltPortDate = 0

PRINT Cast(@AltPortDate as varchar(50))
IF @AltPortDate = 0
BEGIN 

	SET @AlternativeDD = 1
	SET @AlternativeMM = 1
	SET @AlternativeYY = 2000
	SET @AlternativeHH = 1
	SET @AlternativeMin = 1
END
ELSE
BEGIN

	IF @AltPortDate IS NULL
	BEGIN
		SET @AlternativeDD = 99
		SET @AlternativeMM = 99
		SET @AlternativeYY = 99
		SET @AlternativeHH = 99
		SET @AlternativeMin = 99
		SET @UseAlt = - 1
	END
	ELSE
	BEGIN
		SET @AlternativeDD = DatePart(dd, 	@AltPortDate)
		SET @AlternativeMM = DatePart(MM, 	@AltPortDate)
		SET @AlternativeYY = DatePart(YYYY, @AltPortDate)
		SET @AlternativeHH = DatePart(HH, 	@AltPortDate)
		SET @AlternativeMin = DatePart(mm, 	@AltPortDate)
	END

END



-- Customer Name/ Address (Contract Vs Prepay)
DECLARE @Title 				varchar(50)
DECLARE @FirstName 			varchar(50)
DECLARE @Surname 			varchar(50)
DECLARE @Address 			varchar(250)
DECLARE @City 				varchar(50)
DECLARE @County 			varchar(50)
DECLARE @AlternativeNumber 	varchar(50)


IF EXISTS(SELECT OrderRef FROM h3giRegistration WHERE OrderRef = @OrderRef)
BEGIN 
	PRINT 'PREPAY - REG'

	SELECT 
		@Title 				= Title,
		@FirstName			= firstname,
		@Surname			= surname,
		@Address			= REPLACE(LTRIM(addrHouseNumber + ' ' + addrHouseName + ' ' + addrStreetName + ' ' + addrLocality), '  ', ' '),
		@City				= addrTownCity,
		@County				= addrCounty,
		@AlternativeNumber	= daytimeContactAreaCode + ' ' + daytimeContactNumber
	FROM 
		h3giRegistration
	WHERE 
		OrderRef = @OrderRef
END
ELSE
BEGIN
	PRINT 'CONTRACT'

	SELECT 
		@Title 				= h3giOrderHeader.Title,
		@FirstName			= billingForeName,
		@Surname			= billingSurname,
		@Address			= REPLACE(LTRIM(billingAddr1 + ' ' + billingAddr2 + ' ' + billingAddr3), '  ', ' '),
		@City				= billingCity,
		@County				= billingCounty,
		@AlternativeNumber	= daytimeContactAreaCode + ' ' + daytimeContactNumber
	FROM 
		h3giOrderHeader inner join b4nOrderHeader on h3giOrderHeader.OrderRef = b4nOrderHeader.OrderRef
	WHERE 
		h3giOrderHeader.OrderRef = @OrderRef

	IF @Title IS NULL OR @Title = '0'
		SET @Title = '100'
END


IF IsNull (@AltPortDate, 0) < GetDate() 
	SET @AltPortDate = 0

SELECT 
		HOH.OrderRef					AS OrderRef,
		HR.RetailerName + ' - ' 
		+ StoreName						AS StoreName,	
		currentMobileSalesASsociatedName 
										AS SalesASsoicateName,
		storePhoneNumber 				AS StorePhone,
		OrderDate 						AS RequestDate,
		MSISDN							AS MSISDN,


		@Title							AS Title,
		@FirstName			 			AS FirstName,
		@Surname						AS Surname,
		@Address						AS Address,
		@City							AS City,
		@County							AS County,
		'Ireland' 						AS Country,
		@AlternativeNumber				AS AlternativeNumber,


		EMD.currentMobileArea + ' ' + 
		EMD.currentMobileNumber 			AS CurrentMobileNumber,
		EMD.currentMobileNetwork			AS CurrentNetwork,
		EMD.currentMobilePackage 			AS CurrentPackage,
		EMD.currentMobileAccountNumber		AS CurrentAccount, 
		
		CASE @AltPortDate
			WHEN 0 THEN 0 
			ELSE 1
		END 							AS UseAlternativeDate,
		IsNull(@AlternativeDD,99)		AS AlternativeDD,
		IsNull(@AlternativeMM,99)		AS AlternativeMM,
		IsNull(@AlternativeYY,99)		AS AlternativeYY,
		IsNull(@AlternativeHH,99)		AS AlternativeHH,
		IsNull(@AlternativeMin,99)		AS AlternativeMin

	FROM h3giOrderHeader HOH
		INNER JOIN b4nOrderHeader BOH 		ON HOH.OrderRef = BOH.OrderRef
		INNER JOIN h3giRetailerStore HRS 	ON HOH.RetailerCode = HRS.RetailerCode AND HOH.StoreCode = HRS.StoreCode
		INNER JOIN h3giRetailer HR 			ON HOH.RetailerCode = HR.RetailerCode 
		INNER JOIN h3giOrderExistingMobileDetails EMD
		ON HOH.orderref = EMD.orderref
		LEFT OUTER JOIN h3giICCID HI 		ON HOH.ICCID = HI.ICCID 

	WHERE HOH.OrderRef = @OrderRef
END




GRANT EXECUTE ON h3giGetCAF TO b4nuser
GO
GRANT EXECUTE ON h3giGetCAF TO ofsuser
GO
GRANT EXECUTE ON h3giGetCAF TO reportuser
GO
