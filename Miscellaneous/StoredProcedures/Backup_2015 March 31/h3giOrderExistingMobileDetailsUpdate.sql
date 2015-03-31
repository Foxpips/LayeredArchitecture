

/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.h3giOrderExistingMobileDetailsUpdate
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
CREATE PROCEDURE [dbo].[h3giOrderExistingMobileDetailsUpdate]
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
	IF EXISTS (SELECT * FROM h3giOrderExistingMobileDetails WHERE orderref = @orderref)
	BEGIN
		UPDATE h3giOrderExistingMobileDetails
		SET	intentionToPort =	@intentionToPort,
			currentMobileNetwork =  @currentMobileNetwork,
			currentMobileArea = @currentMobileArea,
			currentMobileNumber = @currentMobileNumber,
			currentMobilePackage = @currentMobilePackageType,
			currentMobileAccountNumber = @currentMobileAccountNumber,
			currentMobileAltDatePort = @currentMobileAltDatePort,
			currentMobileCAFCompleted = @currentMobileCAFCompleted,
			currentPrepayTransfer = @currentPrepayTransfer
		WHERE orderref = @orderRef	
	END
	ELSE
	BEGIN
		EXEC [dbo].[h3giOrderExistingMobileDetailsCreate] 			
			@orderref,
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
END


GRANT EXECUTE ON h3giOrderExistingMobileDetailsUpdate TO b4nuser
GO
