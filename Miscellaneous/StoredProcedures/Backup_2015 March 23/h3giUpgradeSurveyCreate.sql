
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giUpgradeSurveyCreate
** Author			:	Adam Jasinski
** Date Created		:	29/03/2007
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Inserts upgrade order survey
**					
**********************************************************************************************************************/
CREATE PROCEDURE h3giUpgradeSurveyCreate
	@orderRef int, 
	@creditOffered bit,
	@creditAccepted bit,
	@creditAmount money,
	@discountOffered bit,
	@discountAccepted bit

AS
BEGIN

 INSERT INTO h3giOrderUpgradeSurvey(orderRef, creditOffered, creditAccepted, creditAmount, discountOffered, discountAccepted)
 VALUES (@orderRef, @creditOffered, @creditAccepted, @creditAmount, @discountOffered, @discountAccepted)

END


GRANT EXECUTE ON h3giUpgradeSurveyCreate TO b4nuser
GO
GRANT EXECUTE ON h3giUpgradeSurveyCreate TO reportuser
GO
