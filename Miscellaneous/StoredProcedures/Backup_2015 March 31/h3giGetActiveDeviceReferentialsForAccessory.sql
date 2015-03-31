
CREATE PROCEDURE [dbo].[h3giGetActiveDeviceReferentialsForAccessory]
(
	@accessoryId VARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT deviceId FROM h3giDeviceAccessoryReferentials WHERE accessoryId = @accessoryId
END

GRANT EXECUTE ON h3giGetActiveDeviceReferentialsForAccessory TO b4nuser
GO
