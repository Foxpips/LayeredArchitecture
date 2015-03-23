

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCurrentCreditLimitsBusinessGet
** Author			:	Simon Markey
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec h3giCurrentCreditLimitsBusinessGet
**********************************************************************************************************************
**				
** Description		:	Gets all the business credit limits and shadow limits
**					
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCurrentCreditLimitsBusinessGet]
AS
BEGIN
	SELECT 
	limitId AS LimitID,
	creditLimit AS Limit,
	shadowLimit AS Shadow 
	FROM h3giCurrentCreditLimits
	WHERE isbusiness = 1
	ORDER BY creditLimit ASC
END

GRANT EXECUTE ON h3giCurrentCreditLimitsBusinessGet TO b4nuser
GO
