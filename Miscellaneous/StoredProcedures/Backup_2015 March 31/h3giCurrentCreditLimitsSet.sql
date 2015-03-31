

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCurrentCreditLimitsSet
** Author			:	Simon Markey
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec h3giCurrentCreditLimitsSet
**********************************************************************************************************************
**				
** Description		:	Inserts a new credit limit and associated shadow limit along with business type
**					
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCurrentCreditLimitsSet]
	@isBusiness INT, 
	@creditLimit INT,
	@shadowLimit INT
AS
BEGIN
	INSERT INTO h3giCurrentCreditLimits values(@isBusiness ,@creditLimit,@shadowLimit)
END

GRANT EXECUTE ON h3giCurrentCreditLimitsSet TO b4nuser
GO
