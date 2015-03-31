


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCreditCheckQueueLog
** Author			:	Neil Murtagh 
** Date Created		:	11/08/2011
**					
**********************************************************************************************************************
**				
** Description		:	Adds an entry to the log
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCreditCheckQueueLog]
(
	@orderRef INT,
	@eventType NVARCHAR(510),
	@eventDescription NVARCHAR(MAX)
)

AS
BEGIN
	SET NOCOUNT ON

 INSERT INTO h3giAutomatedCreditCheckQueueLog
(orderref,eventType,eventDate,eventDescription)
 VALUES
 (@orderRef,@eventType,GETDATE(),@eventDescription)
	
END






GRANT EXECUTE ON h3giCreditCheckQueueLog TO b4nuser
GO
