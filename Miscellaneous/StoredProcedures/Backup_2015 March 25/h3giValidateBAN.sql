

/*********************************************************************************************************************
**
** Procedure Name : h3giValidateBAN
** Author   : Niall Carroll
** Date Created  : 04/07/2006
**
**********************************************************************************************************************
**
** Description  : Check the Validity of a provided BAN (with optional DOB check), returns CustomerID if OK
**
**********************************************************************************************************************
**
** Change Control : 1.0.0 - Initial version
**		1.1.0 - Attila Pall  Modified to use the new h3giUpgrade table
**		1.1.1 - Attila Pall  Now also returns the data of the price plan package and the price plan - band associations
**		1.1.2 - Alex Coll  Now checks to make the BAN has not been locked, and checks the attempt count to lock the BAN if appropriate
**		1.2.0 - Adam Jasinski Added mobileNumber; added @customerPrepay parameter; removed cursors
**		27/01/2009 - John O'Sullivan -	Added support for magic test numbers - allows us to get into the upgrade flow on prod
**		20/06/2012 - Stephen Quin	 -	Changed the stored proc to just validate the data entered by the user rather
**										than checking the eligibility of the user
**		27/09/2012 - Stephen Quin	 -	DateUsed window expanded to 8 weeks
**		14/11/2012 - Stephen Quin	 -	DateUsed reduced back to 2 weeks
**		10/12/2012 - Simon Markey	 -	Added isExchange variable to check if the action being carried out is an exchange
**										as opposed to an upgrade
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giValidateBAN]
		@BAN				VARCHAR(50) = '' OUTPUT,
        @mobileNumberArea   VARCHAR(3)  = '' OUTPUT,
        @mobileNumberMain   VARCHAR(7)  = '' OUTPUT,
        @isExchange			BIT			= 0,
        @customerPrepay     INT         = 2, -- 2 is contract upgrade, 3 is prepay upgrade
        @DOB				DATETIME	= '01 Jan 1900',
        @CheckDOB			BIT         = 0,
        @IgnoreLock			BIT			= 0,
        @AttemptCount		INT         = 0,
        @validateBAN		BIT
AS
BEGIN
	IF ((@BAN = '') AND (@mobileNumberArea  = '' OR @mobileNumberMain = ''))
		RAISERROR('Usage error: Either BAN or mobile number must be provided', 16, 1);    
    
    IF ((@mobileNumberMain <> '') AND (@customerPrepay  = 3))
    BEGIN
		IF (SELECT COUNT(*) FROM h3giUpgrade WITH (NOLOCK) WHERE mobileNumberAreaCode = @mobileNumberArea AND mobileNumberMain = @mobileNumberMain AND eligibilityStatus = 1 AND customerPrepay = 3 ) > 1
        RAISERROR('Duplicate mobile number found', 16, 1);
    END
        
    DECLARE @UpgradeId   INT
    DECLARE @DateUsed	 DATETIME
    DECLARE @DateOfBirth DATETIME
    DECLARE @Message     VARCHAR(100)
    
    IF(@isExchange = 1)
    BEGIN
    SELECT @UpgradeId = UpgradeId FROM h3giUpgrade WHERE BillingAccountNumber = @BAN
    RETURN @UpgradeId
	END
	
	--check that the user entered a correct BAN but an incorrect mobile number
	IF(@mobileNumberArea != '' AND @mobileNumberMain != '') -- do we need to do this check? might be coming from a BAN only screen - telesales in Sprint for example
	BEGIN
		IF EXISTS(SELECT * FROM h3giUpgrade WITH (NOLOCK) WHERE BillingAccountNumber = @BAN AND (mobileNumberAreaCode != @mobileNumberArea OR mobileNumberMain != @mobileNumberMain))
		BEGIN
			SET @Message = 'BAN Validation: BAN is valid mobile number is not BAN: ' + @BAN
			EXEC h3GiLogAuditEvent 0, 2104, @Message, 0
			RETURN -2104
		END
	END
	
	SELECT	@UpgradeId = UpgradeId, 
			@DateOfBirth = DateOfBirth, 
			@DateUsed = DateUsed, 		
			@BAN = BillingAccountNumber, 
			@mobileNumberArea = mobileNumberAreaCode, 
			@mobileNumberMain = mobileNumberMain 
	FROM	h3giUpgrade WITH (NOLOCK)
	WHERE	(BillingAccountNumber = @BAN OR (mobileNumberAreaCode = @mobileNumberArea AND mobileNumberMain = @mobileNumberMain)) 
	AND		customerPrepay = @customerPrepay
      
    --check to see if this is a test number
	IF(dbo.h3giIsTestUpgradeNumber(@BAN, @mobileNumberMain) = 1)
	BEGIN
		--this is one of our magic test numbers 
		IF(@UpgradeId IS NULL)
		BEGIN
			SET @Message = 'BAN Validation: Test upgrade record not found BAN: ' + @BAN
			EXEC h3GiLogAuditEvent 0, 2100, @Message, 0
			RETURN -2100
		END
		--set date used to null
		UPDATE h3giUpgrade SET eligibilityStatus = 1 WHERE UpgradeId = @UpgradeId		
	END
    
    IF @UpgradeId IS NULL
    BEGIN
		SET @Message = 'BAN Validation: BAN not found  BAN: ' + @BAN
		EXEC h3GiLogAuditEvent 0, 2100, @Message, 0
		RETURN -2100
    END
                    
    IF @CheckDOB = 1
    BEGIN
		IF @AttemptCount > 3
		BEGIN
			UPDATE h3giUpgrade SET Locked = 1 WHERE UpgradeId = @UpgradeId
        END
        ELSE
		BEGIN
			IF @AttemptCount = 1
			BEGIN
				UPDATE h3giUpgrade SET Locked = 0 WHERE UpgradeId = @UpgradeId
			END
		END
        
        IF(@IgnoreLock = 0)
		BEGIN
			IF ((SELECT Locked FROM h3giUpgrade WITH (NOLOCK) WHERE UpgradeId = @UpgradeId) = 1)
			BEGIN
				SET @Message = 'BAN Validation: BAN Locked, too many unsuccessful login attempts. ' + @BAN
				EXEC h3GiLogAuditEvent 0, 2103, @Message, 0
				RETURN -2103
			END
        END
        
        IF @DOB != @DateOfBirth
        BEGIN
			SET @Message = 'BAN Validation: DOB Invalid For BAN ' + @BAN
			EXEC h3GiLogAuditEvent 0, 2102, @Message, 0
			RETURN -2102
        END
    END
    
    DECLARE @twoWeekWindow DATETIME
    SET @twoWeekWindow = DATEADD(dd,-14,GETDATE())
    
    IF(@DateUsed >= @twoWeekWindow)
    BEGIN
		SET @Message = 'BAN Validation: BAN has been used - ' + @BAN + ' Date used -' + CONVERT(VARCHAR(100), @DateUsed)
        EXEC h3GiLogAuditEvent 0, 2101, @Message, 0
        RETURN -2101
    END
    
    RETURN @UpgradeId

END






GRANT EXECUTE ON h3giValidateBAN TO b4nuser
GO
