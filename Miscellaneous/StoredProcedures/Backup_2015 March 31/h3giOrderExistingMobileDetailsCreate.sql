
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.h3giOrderExistingMobileDetailsCreate
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:					
**					
**********************************************************************************************************************
**									
** Change Control	:	 - Adam Jasinski - Created
**
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giOrderExistingMobileDetailsCreate
			@orderref int,
			@intentionToPort	char,
            @currentMobileNetwork	varchar(20) = '',
			@currentMobileArea	varchar(10) = '',
			@currentMobileNumber	varchar(15) = '',
			@currentMobilePackageType	varchar(20) = '',
			@currentMobileAccountNumber varchar(20) = '',
			@currentMobileAltDatePort smalldatetime = null,
			@currentMobileCAFCompleted varchar(20) = '',
			@currentPrepayTransfer bit = 0

AS
BEGIN
	IF(EXISTS (SELECT * FROM [dbo].[h3giOrderExistingMobileDetails] WHERE [orderref] = @orderref))
	BEGIN
		EXEC h3giOrderExistingMobileDetailsUpdate @orderref,
			@intentionToPort,
            @currentMobileNetwork,
			@currentMobileArea,
			@currentMobileNumber,
			@currentMobilePackageType,
			@currentMobileAccountNumber,
			@currentMobileAltDatePort,
			@currentMobileCAFCompleted,
			@currentPrepayTransfer
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[h3giOrderExistingMobileDetails]
			   ([orderref]
			   ,[currentMobileNetwork]
			   ,[currentMobileArea]
			   ,[currentMobileNumber]
			   ,[intentionToPort]
			   ,[currentMobilePackage]
			   ,[currentMobileAccountNumber]
			   ,[currentMobileAltDatePort]
			   ,[currentMobileCAFCompleted]
			   ,[currentPrepayTransfer])
		 VALUES
			   (@orderref,
				@currentMobileNetwork,
				@currentMobileArea,
				@currentMobileNumber,
				@intentionToPort,
				@currentMobilePackageType,
				@currentMobileAccountNumber,
				@currentMobileAltDatePort,
				@currentMobileCAFCompleted,
				@currentPrepayTransfer
			);
	 END
END

GRANT EXECUTE ON h3giOrderExistingMobileDetailsCreate TO b4nuser
GO
