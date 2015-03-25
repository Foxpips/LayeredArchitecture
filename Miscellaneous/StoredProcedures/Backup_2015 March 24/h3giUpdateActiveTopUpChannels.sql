

CREATE PROC [dbo].[h3giUpdateActiveTopUpChannels]
AS
BEGIN
DECLARE @catalogueVersionId INT
SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()

INSERT INTO h3giChannelTopUp (channelCode,catalogueProductId)
SELECT ch.channelCode, cat.catalogueProductID
FROM h3giProductCatalogue cat
INNER JOIN h3giChannel ch
	ON 1 = 1
WHERE cat.catalogueVersionID = @catalogueVersionId
AND cat.productType IN ('TOPUPVOUCHER','SURFKIT')
AND cat.catalogueProductID NOT IN
(
	SELECT catalogueProductID FROM h3giChannelTopUp
)

END

GRANT EXECUTE ON h3giUpdateActiveTopUpChannels TO b4nuser
GO
