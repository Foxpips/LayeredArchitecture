

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCurrentCreditLimitsGet
** Author			:	Simon Markey
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec h3giCurrentCreditLimitsGet
**********************************************************************************************************************
**				
** Description		:	Gets all the non-business credit limits and shadow limits
**					
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCurrentCreditLimitsGet]
AS
BEGIN
	SELECT 
	limitId as LimitID,
	creditLimit as Limit,
	shadowLimit as Shadow 
	FROM h3giCurrentCreditLimits
	WHERE isbusiness = 0
	ORDER BY creditLimit ASC
END

GRANT EXECUTE ON h3giCurrentCreditLimitsGet TO b4nuser
GO
