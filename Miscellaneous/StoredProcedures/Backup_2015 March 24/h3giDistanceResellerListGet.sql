
CREATE PROCEDURE dbo.h3giDistanceResellerListGet 
AS
	SELECT * FROM h3giRetailer
	WHERE channelCode = 'UK000000294'

GRANT EXECUTE ON h3giDistanceResellerListGet TO b4nuser
GO
GRANT EXECUTE ON h3giDistanceResellerListGet TO reportuser
GO
