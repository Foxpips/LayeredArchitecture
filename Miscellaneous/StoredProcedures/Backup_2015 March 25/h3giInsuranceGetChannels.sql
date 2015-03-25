

-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 12-July-2013
-- Description:	Gets all the records from h3giInsurancePolicyChannel table.
-- =============================================
CREATE PROCEDURE [dbo].[h3giInsuranceGetChannels]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT i.ChannelCode, ch.channelName, i.Available
	FROM h3giInsurancePolicyChannel i
	INNER JOIN h3giChannel ch
	ON ch.channelCode = i.ChannelCode
END


GRANT EXECUTE ON h3giInsuranceGetChannels TO b4nuser
GO
