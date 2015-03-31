
-- =============================================================
-- Author:		Stephen Quin
-- Create date: 11/04/13
-- Description:	Inserts all the addOns for a business
--				upgrade order
-- =============================================================
CREATE PROCEDURE [dbo].[threeInsertOrderUpgradeParentAddOns] 
	@parentId INT,
	@addOnIds h3giAddOnIdsType READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO threeOrderUpgradeParentAddOn (parentId, addOnId)
	SELECT	@parentId,
			addOnId
	FROM	@addOnIds	
END


GRANT EXECUTE ON threeInsertOrderUpgradeParentAddOns TO b4nuser
GO
