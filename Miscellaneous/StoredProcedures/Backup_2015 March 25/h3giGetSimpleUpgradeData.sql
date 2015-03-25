
-- =============================================
-- Author:		Stephen Quin
-- Create date: 10/07/2012
-- Description:	Returns simple upgrade data
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetSimpleUpgradeData]
	@BAN VARCHAR(10),
	@mobileNumberArea VARCHAR(3),
	@mobileNumberMain VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT	BillingAccountNumber,
			mobileNumberAreaCode,
			mobileNumberMain,
			nameFirst,
			nameMiddleInitial,
			nameLast,
			eligibilityStatus,
			DateUsed
	FROM	h3giUpgrade	
	WHERE	(BillingAccountNumber = @BAN) 
	OR (mobileNumberAreaCode = @mobileNumberArea AND mobileNumberMain = @mobileNumberMain)
 
END


GRANT EXECUTE ON h3giGetSimpleUpgradeData TO b4nuser
GO
