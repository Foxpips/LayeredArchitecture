/*********************************************************************************************************************																				
* Procedure Name	: [h3giGetDocketWelcomeMessage]
* Author			: Niall Carroll
* Date Created		: 23/06/2005
* Version			: 1.1.0
*					
**********************************************************************************************************************
* Description		: Returns a list of orders for amalg of order dockets (Confirm Screen)
**********************************************************************************************************************
* Change Control	: 1.1.0 - NC - Added MessageType Parameter and using dedicated table
**********************************************************************************************************************/

create proc dbo.h3giGetDocketWelcomeMessage
@MessageType varchar(50) = 'Contract'
AS
SELECT MessageText FROM h3giWelcomeMessage WHERE MessageType = @MessageType


GRANT EXECUTE ON h3giGetDocketWelcomeMessage TO b4nuser
GO
GRANT EXECUTE ON h3giGetDocketWelcomeMessage TO ofsuser
GO
GRANT EXECUTE ON h3giGetDocketWelcomeMessage TO reportuser
GO
