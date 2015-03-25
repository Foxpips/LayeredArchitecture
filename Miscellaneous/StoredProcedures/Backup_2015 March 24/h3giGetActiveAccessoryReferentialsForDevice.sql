
CREATE PROCEDURE [dbo].[h3giGetActiveAccessoryReferentialsForDevice]
(
	@deviceId INT
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT accessoryId FROM h3giDeviceAccessoryReferentials WHERE deviceId = @deviceId
END

GRANT EXECUTE ON h3giGetActiveAccessoryReferentialsForDevice TO b4nuser
GO
