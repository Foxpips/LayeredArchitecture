


CREATE PROC [dbo].[h3giCheckICCIDInUse]
@Iccid VARCHAR(20),
@orderRef INT = 0,
@IccidUsed INT OUTPUT

AS
BEGIN
	SET @IccidUsed = 1
	IF NOT EXISTS (SELECT 1 FROM h3giOrderheader
		WHERE ICCID = @Iccid
		AND @orderRef != orderref)
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM threeOrderItem
			WHERE ICCID = @Iccid
			AND @orderRef != orderref)
		BEGIN
			SET @IccidUsed = 0
		End
	END
END


GRANT EXECUTE ON h3giCheckICCIDInUse TO b4nuser
GO
