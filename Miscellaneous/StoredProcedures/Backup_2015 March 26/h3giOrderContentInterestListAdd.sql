

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giOrderContentInterestAdd
** Author			:	Audrey Pender
** Date Created		:	27/02/2007
**					
**********************************************************************************************************************
**				
** Description		:	Adds content interest items to dbo.h3giOrderContentInterest & dbo.h3giOrderContentInterestDetails table			
**
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giOrderContentInterestListAdd]
	@contentInterestList VARCHAR(4000),
	@orderRef int,
	@email VARCHAR(255)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @NewTranCreated INT

	SET @NewTranCreated = 0


	IF @@TRANCOUNT = 0 	
		SET @NewTranCreated = 1

		BEGIN TRANSACTION 

			DECLARE @contentInterestId INT

			EXEC dbo.h3giOrderContentInterestAdd
				@orderRef = @orderRef,
				@email = @email,
				@contentInterestId = @contentInterestId OUT

			EXEC dbo.h3giOrderContentInterestDetailsAdd
				@contentInterestID = @contentInterestId,
				@contentInterestList = @contentInterestList

			IF @@ERROR <> 0 GOTO ERR_HANDLER


			IF @NewTranCreated=1 AND @@TRANCOUNT > 0
		COMMIT TRANSACTION 

	ERR_HANDLER:

		PRINT 'h3giOrderContentInterestListAdd: Rolling back...'

		IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION  

END


GRANT EXECUTE ON h3giOrderContentInterestListAdd TO b4nuser
GO
GRANT EXECUTE ON h3giOrderContentInterestListAdd TO ofsuser
GO
GRANT EXECUTE ON h3giOrderContentInterestListAdd TO reportuser
GO
