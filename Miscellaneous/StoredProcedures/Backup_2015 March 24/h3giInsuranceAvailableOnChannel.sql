

-- ===================================================================
-- Author:		Stephen Quin
-- Create date: 12/07/2013
-- Description:	Checks if insurance is available on a specific channel
-- ===================================================================
CREATE PROCEDURE [dbo].[h3giInsuranceAvailableOnChannel]
	@channelCode VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM h3giChannel WHERE channelCode = @channelCode)
	BEGIN
		SELECT available 
		FROM h3giInsurancePolicyChannel
		WHERE ChannelCode = @channelCode
	END
	ELSE
		SELECT CAST(0 AS BIT)
    
END


GRANT EXECUTE ON h3giInsuranceAvailableOnChannel TO b4nuser
GO
