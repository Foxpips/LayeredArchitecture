
-- =============================================
-- Author:		Stephen Quin
-- Create date: 15/05/08
-- Description:	Retrieves the data for the
--				prepay upgrade csv file that
--				will be sent to ESL
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetESLFileData]
	@dateRetrieved DATETIME 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @dateRetrievedMorning DATETIME
	SET @dateRetrievedMorning = DATEADD(dd, DATEDIFF(dd, 0, @dateRetrieved), 0)

	DECLARE @dateRetrievedMidnight DATETIME
	SET @dateRetrievedMidnight = DATEADD(ss,86399,@dateRetrievedMorning)

	SELECT	'353' + CAST(CAST(upgrade.mobileNumberAreaCode AS INT) AS varchar(2)) + upgrade.mobileNumberMain AS msisdn,
			upgrade.billingAccountNumber,
			history.statusDate,
			case 
				when upgrade.voucherTypeCode is null 
				then '' 
				else dbo.h3giPadLeadingZeros(upgrade.voucherTypeCode, 6)
			end as voucherTypeCode,
			upgrade.num,
			upgrade.topupValue,
			'COM05' AS orgId
	FROM	h3giOrderHeader header
			INNER JOIN h3giUpgrade upgrade WITH(NOLOCK) ON header.upgradeId = upgrade.upgradeId
			INNER JOIN b4nOrderHistory history ON header.orderRef = history.orderRef
	WHERE	history.orderStatus IN (309,312)
	AND		upgrade.customerPrepay = 3
	AND		history.statusDate BETWEEN @dateRetrievedMorning AND @dateRetrievedMidnight
END



GRANT EXECUTE ON h3giGetESLFileData TO b4nuser
GO
