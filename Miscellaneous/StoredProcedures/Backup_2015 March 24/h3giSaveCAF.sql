

/*********************************************************************************************************************																				
* Procedure Name	: [h3giSaveCAF]
* Author			: Niall Carroll
* Date Created		: 07/11/2005
* Version			: 1.0.0
*					
**********************************************************************************************************************
* Description		: Inserts a new record if none exist for the CAF, otherwise updates existing record
**********************************************************************************************************************
* Returns			: 
**********************************************************************************************************************
* Change Control	: 
**********************************************************************************************************************/
CREATE   PROCEDURE [dbo].[h3giSaveCAF]
	@OrderRef				int,
	@StoreName				varchar(103),
	@SalesAssoicateName		varchar(50),
	@StorePhone				varchar(30),
	@RequestDate			DateTime,
	@MSISDN					varchar(30),
	@Title					varchar(30),
	@FirstName				varchar(50),
	@Surname				varchar(50),
	@Address				varchar(250),
	@City					varchar(50),
	@Country				varchar(50),
	@AlternativeNumber		varchar(30),
	@CurrentMobileNumber	varchar(30),
	@CurrentNetwork			int,
	@CurrentPackage			int,
	@CurrentAccount			varchar(50),
	@UseAlternativeDate		int,
	@AlternativeDD			int,
	@AlternativeMM			int,
	@AlternativeYY			int,
	@AlternativeHH			int,
	@AlternativeMin			int
AS

IF EXISTS (SELECT OrderRef FROM h3giCAF WITH(NOLOCK) WHERE OrderRef = @OrderRef)
BEGIN
	UPDATE h3giCAF 
	SET		StoreName				= @StoreName,
			SalesAssoicateName		= @SalesAssoicateName,
			StorePhone				= @StorePhone,
			RequestDate				= @RequestDate,
			MSISDN					= @MSISDN,
			Title					= @Title,
			FirstName				= @FirstName,
			Surname					= @Surname,
			Address					= @Address,
			City					= @City,
			Country					= @Country,
			AlternativeNumber		= @AlternativeNumber,
			CurrentMobileNumber		= @CurrentMobileNumber,
			CurrentNetwork			= @CurrentNetwork,
			CurrentPackage			= @CurrentPackage,
			CurrentAccount			= @CurrentAccount,
			UseAlternativeDate		= @UseAlternativeDate,
			AlternativeDD			= @AlternativeDD,
			AlternativeMM			= @AlternativeMM,
			AlternativeYY			= @AlternativeYY,
			AlternativeHH			= @AlternativeHH,
			AlternativeMin			= @AlternativeMin
	WHERE
		OrderRef = @OrderRef
END
ELSE
BEGIN
	INSERT INTO h3giCAF
		(OrderRef,
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
		AlternativeMin)
	VALUES
		(@OrderRef,
		@StoreName,
		@SalesAssoicateName,
		@StorePhone,
		@RequestDate,
		@MSISDN,
		@Title,
		@FirstName,
		@Surname,
		@Address,
		@City,
		@Country,
		@AlternativeNumber,
		@CurrentMobileNumber,
		@CurrentNetwork,
		@CurrentPackage,
		@CurrentAccount,
		@UseAlternativeDate,
		@AlternativeDD,
		@AlternativeMM,
		@AlternativeYY,
		@AlternativeHH,
		@AlternativeMin)
END

DECLARE @AltDate DateTime

IF @AlternativeDD > 0 AND @AlternativeDD < 40
BEGIN
	SET @AltDate = 	CAST(			Cast(@AlternativeDD as varchar(2)) + '/' + 
									Cast(@AlternativeMM as varchar(2)) + '/' +
									Cast(@AlternativeHH as varchar(4))
									AS DateTime)
END
ELSE
BEGIN
	SET @AltDate = GetDate()
END
UPDATE h3giOrderHeader SET 	currentMobileCAFCompleted = 'Yes',
							currentMobileSalesAssociatedName = @SalesAssoicateName,
							currentMobileAltDatePort = @AltDate,
							
							currentMobileAccountNumber = @CurrentMobileNumber,
							currentMobilePackage = CASE @CurrentPackage
								WHEN 1 THEN 'P'
								WHEN 2 THEN 'C'
								WHEN 3 THEN 'M'
								WHEN 4 THEN 'M'
							END
WHERE OrderRef = @OrderRef

UPDATE h3giOrderExistingMobileDetails SET 	currentMobileCAFCompleted = 'Yes',
							currentMobileAltDatePort = @AltDate,
							currentMobileAccountNumber = @CurrentMobileNumber,
							currentMobilePackage = CASE @CurrentPackage
								WHEN 1 THEN 'P'
								WHEN 2 THEN 'C'
								WHEN 3 THEN 'M'
								WHEN 4 THEN 'M'
							END
WHERE OrderRef = @OrderRef
					
				




GRANT EXECUTE ON h3giSaveCAF TO b4nuser
GO
GRANT EXECUTE ON h3giSaveCAF TO ofsuser
GO
GRANT EXECUTE ON h3giSaveCAF TO reportuser
GO
