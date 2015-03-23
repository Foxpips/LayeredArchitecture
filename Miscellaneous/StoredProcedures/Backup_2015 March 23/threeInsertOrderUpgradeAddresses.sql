
-- ==========================================================
-- Author:		Stephen Quin
-- Create date: 11/04/13
-- Description:	Inserts all the addresses for a business
--				upgrade order
-- ==========================================================
CREATE PROCEDURE [dbo].[threeInsertOrderUpgradeAddresses]
	@parentId INT,
	@orderAddresses h3giOrderAddress READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO threeOrderUpgradeAddress (parentId, addressType, aptNumber, houseNumber, houseName, street, locality, town, countyId, country, deliveryNote)
    SELECT	@parentId,
			addressType,
			aptNumber,
			houseNumber,
			houseName,
			street,
			locality,
			town,
			countyId,
			country,
			deliveryNote
	FROM	@orderAddresses
    
END


GRANT EXECUTE ON threeInsertOrderUpgradeAddresses TO b4nuser
GO
