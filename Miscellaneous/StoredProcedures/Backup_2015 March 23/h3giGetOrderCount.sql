

-- =============================================
-- Author:		Stephen Quin
-- Create date: 09/12/2009
-- Description:	Gets a count of orders from the
--				start of the day up to the time
--				passed in as a parameter for the
--				specified orderType
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetOrderCount] 
	@orderTime DATETIME,
	@orderType INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --Get the dates
	DECLARE @startDate DATETIME
	DECLARE @endDate DATETIME
	
	SET @startDate = DATEADD(dd, DATEDIFF(dd, 0, @orderTime), 0)
	SET @endDate = CONVERT(SMALLDATETIME, @orderTime)

	--Get the order count
	SELECT	COUNT(*) AS orderCount
	FROM	b4nOrderHeader b4n
		INNER JOIN h3giOrderHeader h3gi
		ON b4n.orderRef = h3gi.orderRef
	WHERE b4n.orderDate BETWEEN @startDate AND @endDate
		AND h3gi.orderType = @orderType
	
END




GRANT EXECUTE ON h3giGetOrderCount TO b4nuser
GO
