
-- =============================================
-- Author:		Attila Pall
-- Create date: 05/09/2007
-- Description:	gets the credit limit values for a credit limit id
-- Change Log:	Simon Markey - 05/10/2012 - Changed it to point to new table
-- =============================================
CREATE PROCEDURE [dbo].[h3giCreditLimitsGet] 
	-- Add the parameters for the stored procedure here
	@creditLimitId int
AS
BEGIN
	select creditLimit as limit, shadowLimit as shadow
	FROM h3giCurrentCreditLimits with(nolock)
	WHERE limitID = @creditLimitID
END


GRANT EXECUTE ON h3giCreditLimitsGet TO b4nuser
GO
GRANT EXECUTE ON h3giCreditLimitsGet TO ofsuser
GO
GRANT EXECUTE ON h3giCreditLimitsGet TO reportuser
GO
