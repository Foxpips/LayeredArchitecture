

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giEligibilityOverrideUpdate
** Author			:	Simon Markey
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Updates the EligibilityOverridden table when an upgrade users upgrade status is changed
**					
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giEligibilityOverrideUpdate]
	@UserId INT, 
	@BAN VARCHAR(50),
	@Status BIT
AS
BEGIN
	INSERT INTO h3giEligibilityOverridden VALUES(GETDATE(),@UserId,@BAN,@Status)
END

GRANT EXECUTE ON h3giEligibilityOverrideUpdate TO b4nuser
GO
