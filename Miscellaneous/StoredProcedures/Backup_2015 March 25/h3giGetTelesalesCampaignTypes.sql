
-- =============================================
-- Author:		Stephen Quin
-- Create date: 04/10/2012
-- Description:	Returns the campaign types
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetTelesalesCampaignTypes] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT campaignTypeId, campaignType
    FROM h3giTelesalesCampaignType
END


GRANT EXECUTE ON h3giGetTelesalesCampaignTypes TO b4nuser
GO
