

-- =============================================
-- Author:		Stephen Quin
-- Create date: 07/08/09
-- Description:	Gets the customer phone numbers
--				from the h3giUpgradeNotification
--				table for a given date
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetSMSPhoneNumbers] 
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
	
	SELECT mobileNumberAreaCode + mobileNumberMain AS mobileNumber
	FROM h3giUpgradeNotifications
	WHERE importDate BETWEEN @dateAddedMorning AND @dateAddedMidnight
END



GRANT EXECUTE ON h3giGetSMSPhoneNumbers TO b4nuser
GO
