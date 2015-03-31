

/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threeOrganizationUpdate
** Author			:	Adam Jasinski 
** Date Created		:	04/10/2007
**					
**********************************************************************************************************************
**				
** Description		:					
**					
**********************************************************************************************************************
**									
** Change Control	:	 04/10/2007 - Adam Jasinski - Created
**                  :    13/01/2011 - Stephen Mooney - Added organization telephone number
**                  :    15/02/2013 - Sorin Oboroceanu - Fixed a bug related to registeredNumber
**
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[threeOrganizationUpdate]
		@organizationId int,
		@industryType varchar(40),
		@registeredName nvarchar(75),
		@tradingName nvarchar(75),
		@registeredNumber varchar(10),
		@numberOfEmployees int,
		@currentOwnershipTimeYY smallint = 0,
		@currentOwnershipTimeMM tinyint = 0,
		@numberOfDevicesRequired int,
		@pricePlanRequiredPeopleSoftId varchar(50),
		@currentMonthlyMobileSpend money,
		@intentionToPort bit,
		@currentMobileOperator nvarchar(50) = '',
		@promotionCode varchar(12) = '',
		@mediaTrackingCode varchar(20) = '',
		@removeChildRows bit = 0,
		@telephoneAreaCode VARCHAR(10) = '',
		@telephoneNumber VARCHAR(15) = ''

AS
BEGIN

	DECLARE 
		@NewTranCreated int,
		@RC int
	SET @NewTranCreated = 0
	SET @RC=0

	IF @@TRANCOUNT = 0 	--if not in a transaction context yet
	BEGIN
		SET @NewTranCreated = 1
		BEGIN TRANSACTION 	--then create a new transaction
	END

	IF @removeChildRows = 1
	BEGIN
		DELETE FROM [dbo].[threeOrganizationAddress]
		WHERE organizationId = @organizationId;

		DELETE FROM [dbo].[threePerson]
		WHERE organizationId = @organizationId;

		IF @@ERROR <> 0 GOTO ERR_HANDLER; 
	END



	UPDATE [dbo].[threeOrganization]
    SET
           [industryType] = @industryType
           ,[registeredName] = @registeredName
           ,[tradingName] = @tradingName
           ,[registeredNumber] = @registeredNumber
           ,[currentOwnershipTimeYY] = @currentOwnershipTimeYY
           ,[currentOwnershipTimeMM] = @currentOwnershipTimeMM
			,[numberOfDevicesRequired] = @numberOfDevicesRequired
			,[pricePlanRequiredPeopleSoftId] = @pricePlanRequiredPeopleSoftId
			,[currentMonthlyMobileSpend] = @currentMonthlyMobileSpend
			,[intentionToPort] = @intentionToPort
			,[currentMobileOperator] = @currentMobileOperator
			,[promotionCode]		= @promotionCode
			,[mediaTrackingCode]	= @mediaTrackingCode
			,[telephoneAreaCode] = @telephoneAreaCode
			,[telephoneNumber] = @telephoneNumber
			
     WHERE organizationId = @organizationId;

	IF @@ERROR <> 0 GOTO ERR_HANDLER;

		

	IF @NewTranCreated=1 AND @@TRANCOUNT > 0
		 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
	RETURN 0

	ERR_HANDLER:
		PRINT 'threeOrganizationUpdate: Rolling back...'
		IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION  --rollback all changes
		RETURN -1		--return error code
END





GRANT EXECUTE ON threeOrganizationUpdate TO b4nuser
GO
