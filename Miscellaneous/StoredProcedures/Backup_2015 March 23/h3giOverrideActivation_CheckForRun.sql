/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giOverrideActivation_CheckForRun
** Author			:	Niall Carroll
** Date Created		:	05 Oct 2005
** Version			:	V1.0	
**					
**********************************************************************************************************************
**				
** Description		:	If an override has been scheduled, run the activation job
**						If its a direct sales job, reset the values of the config table to 12.30am this morning
**						Needs to be run under account which has both access to the master..xp_cmdshell proc
**							and which has the wsFTP Public Key setup.
**					
**********************************************************************************************************************
**									
** Change Control	:	
*********************************************************************************************************************/
CREATE PROC dbo.h3giOverrideActivation_CheckForRun

AS

IF EXISTS (SELECT idValue FROM config WHERE idName = 'OverrideActivationSchedule' AND idValue IN ('Direct', 'Retailer'))
BEGIN 
	-- Production
	--EXEC master..xp_cmdshell 'W:\activation\activation.bat'
	-- BRT
	EXEC master..xp_cmdshell 'v:\activation_prepay\activation.bat'
	-- TEST
	--EXEC master..xp_cmdshell 'W:\ftproot\three\V1.3\activation.bat'

	
	UPDATE config SET idValue = 'N' WHERE idName = 'ACTIVATION_RUN_NOW'
	UPDATE config SET idValue = 'none' WHERE idName = 'OverrideActivationSchedule'
END

GRANT EXECUTE ON h3giOverrideActivation_CheckForRun TO b4nuser
GO
GRANT EXECUTE ON h3giOverrideActivation_CheckForRun TO ofsuser
GO
GRANT EXECUTE ON h3giOverrideActivation_CheckForRun TO reportuser
GO
