

/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threeOrganizationCreate
** Author			:	Adam Jasinski 
** Date Created		:	02/10/2007
**					
**********************************************************************************************************************
**				
** Description		:					
**					
**********************************************************************************************************************
**									
** Change Control	:	 02/10/2007 - Adam Jasinski - Created
**                  :    13/01/11 - Stephen Mooney - Added organization telephone number
**
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[threeOrganizationCreate]
		@organizationType varchar(30),
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
		@currentMobileOperator nvarchar(50) = '' ,
		@promotionCode varchar(12) = '',
		@mediaTrackingCode varchar(20) = '',
		@organizationId int out,
		@telephoneAreaCode VARCHAR(10) = '',
		@telephoneNumber VARCHAR(15) = ''
AS
BEGIN

	SET @organizationId = 0;

	INSERT INTO [dbo].[threeOrganization]
           ([organizationType]
           ,[industryType]
           ,[registeredName]
           ,[tradingName]
           ,[registeredNumber]
			,[numberOfEmployees]
           ,[currentOwnershipTimeYY]
           ,[currentOwnershipTimeMM]
			,[numberOfDevicesRequired]
			,[pricePlanRequiredPeopleSoftId]
			,[currentMonthlyMobileSpend]
			,[intentionToPort]
			,[currentMobileOperator]
			,[promotionCode]
			,[mediaTrackingCode]
			,[telephoneAreaCode] 
			,[telephoneNumber]
)
     VALUES
           (
			@organizationType,
			@industryType,
			@registeredName,
			@tradingName,
			@registeredNumber,
			@numberOfEmployees,
			@currentOwnershipTimeYY,
			@currentOwnershipTimeMM,
			@numberOfDevicesRequired,
			@pricePlanRequiredPeopleSoftId,
			@currentMonthlyMobileSpend,
			@intentionToPort,
			@currentMobileOperator,
			@promotionCode,
			@mediaTrackingCode,
			@telephoneAreaCode,
			@telephoneNumber
		   );

	IF @@ERROR = 0 SET @organizationId = SCOPE_IDENTITY();

END



GRANT EXECUTE ON threeOrganizationCreate TO b4nuser
GO
GRANT EXECUTE ON threeOrganizationCreate TO ofsuser
GO
GRANT EXECUTE ON threeOrganizationCreate TO reportuser
GO
