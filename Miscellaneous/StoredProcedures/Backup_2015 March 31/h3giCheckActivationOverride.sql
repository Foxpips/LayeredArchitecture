/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCheckActivationOverride
** Author			:	Niall Carroll
** Date Created		:	05 Oct 2005
** Version			:	V1.0	
**					
**********************************************************************************************************************
**				
** Description		:	Checks to see if there is an overriden activation job queued, returns info on last activation
**						job
**					
**********************************************************************************************************************
**									
** Change Control	:	
*********************************************************************************************************************/
CREATE PROC dbo.h3giCheckActivationOverride

AS

DECLARE @MaxActivationNumber 	int
DECLARE @MaxActivationNumberPP 	int
DECLARE @MaxActivationDate		DateTime 
DECLARE @CurrentlyQueuedType	varchar(20)

SELECT @MaxActivationNumber = MAX(sequence_no) FROM h3giSalesCapture_Audit with(nolock) where Prepay = 0
SELECT @MaxActivationNumberPP = MAX(sequence_no) FROM h3giSalesCapture_Audit with(nolock) where Prepay = 1
SELECT @MaxActivationDate = MAX(sentDate) FROM h3giSalesCapture_Audit with(nolock) 
--WHERE sequence_no = @MaxActivationNumber
SELECT @CurrentlyQueuedType = idValue FROM config with(nolock) WHERE idName = 'OverrideActivationSchedule'

SELECT @MaxActivationNumber as seq_no, @MaxActivationNumberPP as seq_noPP, @MaxActivationDate as sentDate, @CurrentlyQueuedType as OverrideType


GRANT EXECUTE ON h3giCheckActivationOverride TO b4nuser
GO
GRANT EXECUTE ON h3giCheckActivationOverride TO ofsuser
GO
GRANT EXECUTE ON h3giCheckActivationOverride TO reportuser
GO
