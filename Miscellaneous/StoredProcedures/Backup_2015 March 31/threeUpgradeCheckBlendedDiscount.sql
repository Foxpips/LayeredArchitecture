

-- =========================================================
-- Author:		Stephen Quin
-- Create date: 07/05/2013
-- Description:	Checks if an awaiting/open blended discount
--				requests exists against the account
-- =========================================================
CREATE PROCEDURE [dbo].[threeUpgradeCheckBlendedDiscount] 
	@ban NVARCHAR(10),
	@msisdn NVARCHAR(13)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @parentBan NVARCHAR(10)

	SELECT @parentBan = parentBAN
	FROM threeUpgrade
	WHERE ((@ban IS NULL OR (parentBAN = @ban OR childBAN = @ban)))
	AND ((@msisdn IS NULL OR msisdn = @msisdn))
	AND eligibilityStatus NOT IN (0)
		
	IF EXISTS (	
		SELECT * FROM threeUpgradeBlendedDiscountCase
		WHERE parentBAN = @parentBan
		AND status = 1		
	)	
		RETURN 1	
	ELSE	
		RETURN 0	
    
END



GRANT EXECUTE ON threeUpgradeCheckBlendedDiscount TO b4nuser
GO
