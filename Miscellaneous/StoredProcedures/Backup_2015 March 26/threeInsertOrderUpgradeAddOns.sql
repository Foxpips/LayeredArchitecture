
-- =============================================================
-- Author:		Stephen Quin
-- Create date: 11/04/13
-- Description:	Inserts all the addOns for a business
--				upgrade order
-- =============================================================
CREATE PROCEDURE [dbo].[threeInsertOrderUpgradeAddOns] 
	@orderRef INT,
	@addOnIds h3giAddOnIdsType READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO threeOrderUpgradeAddOn (orderRef, addOnId)
	SELECT	@orderRef,
			addOnId
	FROM	@addOnIds	
END


GRANT EXECUTE ON threeInsertOrderUpgradeAddOns TO b4nuser
GO
