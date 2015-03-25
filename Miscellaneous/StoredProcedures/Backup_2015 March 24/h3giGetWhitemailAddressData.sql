

-- =============================================
-- Author:		Stephen Quin
-- Create date: 17/07/09
-- Description:	Gets the address data for the
--				whitemails
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetWhitemailAddressData]
	@dateAdded DATETIME  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @dateAddedMorning DATETIME
	SET @dateAddedMorning = DATEADD(dd, DATEDIFF(dd, 0, @dateAdded), 0)

	DECLARE @dateRetrievedMidnight DATETIME
	SET @dateRetrievedMidnight = DATEADD(ss,86399,@dateAddedMorning)

    SELECT	billingAccountNumber,
			nameFirst,
			nameMiddleInitial,
			nameLast,
			addrHouseNumber,
			addrHouseName,
			addrStreetName,
			addrLocality,
			addrTown,
			addrCountyId
	FROM	h3giUpgradeNotifications
	WHERE	importDate BETWEEN @dateAddedMorning AND @dateRetrievedMidnight
END



GRANT EXECUTE ON h3giGetWhitemailAddressData TO b4nuser
GO
