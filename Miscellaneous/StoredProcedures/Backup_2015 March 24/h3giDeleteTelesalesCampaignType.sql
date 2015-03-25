
-- ===============================================
-- Author:		Stephen Quin
-- Create date: 05/10/2012
-- Description:	Deletes a telesales campaign type
-- ===============================================
CREATE PROCEDURE [dbo].[h3giDeleteTelesalesCampaignType] 
	@campaignTypeId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM h3giTelesalesCampaignType
    WHERE campaignTypeId = @campaignTypeId
END


GRANT EXECUTE ON h3giDeleteTelesalesCampaignType TO b4nuser
GO
