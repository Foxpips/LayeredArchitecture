
-- ==============================================================
-- Author:		Sorin Oboroceanu
-- Create date: 18/07/2014
-- Description:	Checks whether an order is a SIM only order.
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giIsSimOnlyOrder]
(
  @OrderRef INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;    
    
	IF EXISTS(
		SELECT TOP 1 *
		FROM h3giOrderHeader oh
		INNER JOIN h3giProductCatalogue pc ON pc.productFamilyId = oh.phoneProductCode AND pc.catalogueVersionID = oh.catalogueVersionID
		INNER JOIN h3giProductAttributeValue pav ON pav.catalogueProductId = pc.catalogueProductID
		INNER JOIN h3giProductAttribute pa ON pa.attributeId = pav.attributeId
		WHERE oh.orderref = @OrderRef AND pa.attributeName = 'SIM'
	)
		SELECT CAST(1 AS BIT)
	ELSE
		SELECT CAST(0 AS BIT)
END
GRANT EXECUTE ON h3giIsSimOnlyOrder TO b4nuser
GO
