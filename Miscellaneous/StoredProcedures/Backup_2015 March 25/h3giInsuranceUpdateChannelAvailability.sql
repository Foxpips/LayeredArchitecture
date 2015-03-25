

-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 12-July-2013
-- Description:	Updates the availability status of a certain channel.
-- =============================================
CREATE PROCEDURE [dbo].[h3giInsuranceUpdateChannelAvailability]
(
	@ChannelCode	VARCHAR(20),
	@Available		BIT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE h3giInsurancePolicyChannel
	SET Available = @Available
	WHERE ChannelCode = @ChannelCode
END


GRANT EXECUTE ON h3giInsuranceUpdateChannelAvailability TO b4nuser
GO
