
-- ===============================================================
-- Author:		Stephen Quin
-- Create date: 29/05/12
-- Description:	Adds a charge code for a contract upgrade handset
-- ===============================================================
CREATE PROCEDURE [dbo].[h3giUpgradeAddChargeCode] 
	@chargeCode VARCHAR(20),
	@catalogueProductId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;    
    
    IF EXISTS (SELECT * FROM h3giUpgradeChargeCodes WHERE catalogueProductId = @catalogueProductId)
    BEGIN
		UPDATE h3giUpgradeChargeCodes
		SET chargeCode = @chargeCode
		WHERE catalogueProductId = @catalogueProductId
    END
    ELSE    
    BEGIN
		INSERT INTO h3giUpgradeChargeCodes
		VALUES (@catalogueProductId, @chargeCode)
    END
    
END


GRANT EXECUTE ON h3giUpgradeAddChargeCode TO b4nuser
GO
