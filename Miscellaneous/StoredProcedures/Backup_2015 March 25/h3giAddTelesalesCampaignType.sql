
-- ===============================================
-- Author:		Stephen Quin
-- Create date: 05/10/2012
-- Description:	Adds a new telesales campaign type
-- ===============================================
CREATE PROCEDURE [dbo].[h3giAddTelesalesCampaignType] 
	@campaignType VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF NOT EXISTS (SELECT * FROM h3giTelesalesCampaignType WHERE campaignType = @campaignType)
    BEGIN
		INSERT INTO h3giTelesalesCampaignType
		VALUES (@campaignType)
    END
    
END


GRANT EXECUTE ON h3giAddTelesalesCampaignType TO b4nuser
GO
