-- =============================================
-- Author:		Simon Markey
-- Create date: 17/01/2014
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[h3giUpgradeCustomerGetTopupInfo]
	-- Add the parameters for the stored procedure here
	@mobileArea varchar(4),
	@mobileMain varchar(7)
AS
BEGIN
	SELECT	CAST(topupValue AS INT),
	num
	FROM h3giUpgrade 
	WHERE mobileNumberAreaCode = @mobileArea 
	AND mobileNumberMain = @mobileMain
END

GRANT EXECUTE ON h3giUpgradeCustomerGetTopupInfo TO b4nuser
GO
