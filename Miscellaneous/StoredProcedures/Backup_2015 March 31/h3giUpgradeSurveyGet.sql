
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giUpgradeSurveyGet
** Author			:	Adam Jasinski
** Date Created		:	29/03/2007
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Returns upgrade order survey
**					
**********************************************************************************************************************/
CREATE PROCEDURE h3giUpgradeSurveyGet
	@orderRef int
AS
BEGIN
	SELECT orderRef, creditOffered, creditAccepted, creditAmount, discountOffered, discountAccepted 
	FROM h3giOrderUpgradeSurvey
	WHERE orderref = @orderRef
END


GRANT EXECUTE ON h3giUpgradeSurveyGet TO b4nuser
GO
GRANT EXECUTE ON h3giUpgradeSurveyGet TO reportuser
GO
