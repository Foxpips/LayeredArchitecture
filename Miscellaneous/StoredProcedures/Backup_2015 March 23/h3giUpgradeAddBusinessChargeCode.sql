
-- ===============================================================
-- Author:		Stephen Quin
-- Create date: 08/04/13
-- Description:	Adds or updates a new business upgrade charge code
-- ===============================================================
CREATE PROCEDURE [dbo].[h3giUpgradeAddBusinessChargeCode]
	@chargeCode VARCHAR(10),
	@catalogueProductId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM threeUpgradeChargeCodes WHERE catalogueProductId = @catalogueProductId)
    BEGIN
		UPDATE threeUpgradeChargeCodes
		SET chargeCode = @chargeCode
		WHERE catalogueProductId = @catalogueProductId
    END
    ELSE    
    BEGIN
		INSERT INTO threeUpgradeChargeCodes
		VALUES (@catalogueProductId, @chargeCode)
    END
    
END


GRANT EXECUTE ON h3giUpgradeAddBusinessChargeCode TO b4nuser
GO
