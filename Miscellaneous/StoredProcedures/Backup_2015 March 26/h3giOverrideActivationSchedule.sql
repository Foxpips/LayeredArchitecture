/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giOverrideActivationSchedule
** Author			:	Niall Carroll
** Date Created		:	05 Oct 2005
** Version			:	V1.2	
**					
**********************************************************************************************************************
**				
** Description		:	Schedules an Adhoc Activation job which runs outside the normal activation job schedule
**					
**********************************************************************************************************************
**									
** Change Control	:	V1.1 - Changed to use h3giAudit table (ncarroll - 13 Oct 2005)
**						V1.2 - Using new scheduling (ncarroll - 20 Apr 2006)
*********************************************************************************************************************/
CREATE PROC dbo.h3giOverrideActivationSchedule

@Type 		varchar(10),
@UserID		int = -1,
@UserName	varchar(20) = ''

AS
Declare @TransactionCountOnEntry int

DECLARE @ReturnCode 		int	-- -1: Failure, 0: Success, 1: Activation Already Queued
DECLARE @ErrorCode			int

SET @TransactionCountOnEntry = @@TranCount
SET @ErrorCode = 0

IF @UserName > ''
	SELECT @UserID = userId FROM smApplicationUsers WHERE applicationID = 1 and userName = @UserName

IF EXISTS (SELECT idValue FROM config WHERE idName = 'OverrideActivationSchedule' AND idValue = 'none')
BEGIN 
	BEGIN TRAN
	IF @Type = 'Direct'
	BEGIN
		UPDATE config SET idValue = 'Y' WHERE idName = 'ACTIVATION_RUN_NOW'
	END
	
	UPDATE config SET idValue = @Type WHERE idName = 'OverrideActivationSchedule'
	IF (@@ERROR <> 0 OR @@ROWCOUNT < 1)
		SET @ErrorCode = -1
		
	INSERT INTO h3giAudit (auditEvent, OrderRef, auditTime, userID, auditInfo) 
	VALUES (105, -1, GetDate(), @UserID, 'Ad-hoc activation requested of type: ' + @Type)
	IF (@@ERROR <> 0 OR @@ROWCOUNT < 1)
		SET @ErrorCode = -1
		
	IF @@TranCount > @TransactionCountOnEntry
	BEGIN
		IF @ErrorCode = 0
		BEGIN
	    	COMMIT TRANSACTION
	    	SET @ReturnCode = 0
		END
		ELSE
		BEGIN
	    	ROLLBACK TRANSACTION
	    	SET @ReturnCode = -1 
		END
	END
	ELSE
	BEGIN
		SET @ReturnCode = -1
	END
END
ELSE
BEGIN 
	SET @ReturnCode = 1
END

SELECT @ReturnCode as ReturnCode


GRANT EXECUTE ON h3giOverrideActivationSchedule TO b4nuser
GO
GRANT EXECUTE ON h3giOverrideActivationSchedule TO ofsuser
GO
GRANT EXECUTE ON h3giOverrideActivationSchedule TO reportuser
GO
