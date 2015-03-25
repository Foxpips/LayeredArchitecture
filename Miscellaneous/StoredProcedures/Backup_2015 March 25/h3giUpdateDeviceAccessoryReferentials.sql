
CREATE PROCEDURE [dbo].[h3giUpdateDeviceAccessoryReferentials]
(
	@accessoryId VARCHAR(20),
	@deviceId VARCHAR(20),
	@enable BIT
)
AS
BEGIN
	SET NOCOUNT ON
	IF @enable = 1
	BEGIN
		INSERT INTO h3giDeviceAccessoryReferentials(accessoryId, deviceId)
		VALUES (@accessoryId, @deviceId)
	END
	ELSE
		DELETE FROM h3giDeviceAccessoryReferentials
		WHERE accessoryId = @accessoryId
			AND deviceId = @deviceId	
END

GRANT EXECUTE ON h3giUpdateDeviceAccessoryReferentials TO b4nuser
GO
