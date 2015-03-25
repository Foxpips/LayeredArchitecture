
-- ==============================================
-- Author:		Stephen Quin
-- Create date: 10/08/09
-- Description:	Gets the customer email addresses
--				from the h3giUpgradeNotification
--				table for a given date 
-- ==============================================
CREATE PROCEDURE [dbo].[h3giGetUpgradeEmailAddresses] 
@dateAdded DATETIME  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @dateAddedMorning DATETIME
	SET @dateAddedMorning = DATEADD(dd, DATEDIFF(dd, 0, @dateAdded), 0)

	DECLARE @dateAddedMidnight DATETIME
	SET @dateAddedMidnight = DATEADD(ss,86399,@dateAddedMorning)
	
	SELECT	email AS emailAddress,
			nameFirst AS foreName
	FROM	h3giUpgradeNotifications
	WHERE	importDate BETWEEN @dateAddedMorning AND @dateAddedMidnight
	AND		LEN(email) > 0
END






GRANT EXECUTE ON h3giGetUpgradeEmailAddresses TO b4nuser
GO
