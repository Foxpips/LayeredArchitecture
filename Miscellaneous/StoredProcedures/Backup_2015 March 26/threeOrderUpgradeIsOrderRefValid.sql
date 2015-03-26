
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 24/05/2013
-- Description:	Verifies whether a certain order ref exists in the threeOrderUpgradeHeader
-- =============================================
CREATE PROCEDURE [dbo].[threeOrderUpgradeIsOrderRefValid]
(
	@OrderRef INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT orderRef FROM threeOrderUpgradeHeader WHERE ordeRref = @OrderRef)
	BEGIN
		SELECT 1;
	END
	ELSE
	BEGIN
		SELECT 0;
	END
END


GRANT EXECUTE ON threeOrderUpgradeIsOrderRefValid TO b4nuser
GO
