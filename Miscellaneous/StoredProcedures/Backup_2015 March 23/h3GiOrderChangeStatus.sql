
/****** Object:  Stored Procedure dbo.h3GiOrderChangeStatus    Script Date: 23/06/2005 13:35:02 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3GiOrderChangeStatus
** Author		:	Padraig Gorry
** Date Created		:	
** Version		:	
**					
**********************************************************************************************************************
**				
** Description		:	Changes the status of an order
**					
**********************************************************************************************************************
**									
** Change Control	:	18/04/2005 Padraig Gorry - Created
**				28/03/2007 Attila Pall - Modified to call h3giOrderStatusSet with the statusCode
**							 looked up with fn_getStatusCode
**********************************************************************************************************************/
CREATE  PROCEDURE h3GiOrderChangeStatus
	@OrderRef as int,
	@Status as varchar(20),
	@userID as int
AS
BEGIN
	DECLARE @statusCode INT;

	SET @statusCode = dbo.fn_GetStatusCode(@Status);
	
	EXEC h3giOrderStatusSet @orderRef, @statusCode;
END



GRANT EXECUTE ON h3GiOrderChangeStatus TO b4nuser
GO
GRANT EXECUTE ON h3GiOrderChangeStatus TO ofsuser
GO
GRANT EXECUTE ON h3GiOrderChangeStatus TO reportuser
GO
GRANT EXECUTE ON h3GiOrderChangeStatus TO b4nexcel
GO
