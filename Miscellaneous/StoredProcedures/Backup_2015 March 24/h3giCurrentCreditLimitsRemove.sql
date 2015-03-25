

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCurrentCreditLimitsRemove
** Author			:	Simon Markey
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec h3giCurrentCreditLimitsRemove
**********************************************************************************************************************
**				
** Description		:	Removes an existing credit limit and associated shadow limit along with business type
**					
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCurrentCreditLimitsRemove]
	@isBusiness INT, 
	@limitid	INT
AS
BEGIN
	DELETE FROM h3giCurrentCreditLimits 
	WHERE isBusiness = @isBusiness 
	AND limitId = @limitid
END

GRANT EXECUTE ON h3giCurrentCreditLimitsRemove TO b4nuser
GO
