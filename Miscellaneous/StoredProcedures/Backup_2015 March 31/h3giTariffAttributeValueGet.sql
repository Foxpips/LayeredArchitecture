

CREATE PROC [dbo].[h3giTariffAttributeValueGet]
@peopleSoftId AS VARCHAR(50)

AS
BEGIN

DECLARE @catalogueId VARCHAR(MAX)
DECLARE @attributeVal  AS NVARCHAR(MAX)

SELECT @catalogueId = catalogueVersionID 
  FROM h3giCatalogueVersion 
  WHERE activeCatalog = 'Y'

SELECT @attributeVal = pricePlanPackageDescription
  FROM h3giPricePlanPackage 
  WHERE peoplesoftID = @peopleSoftId AND catalogueVersionID = @catalogueId

SELECT @attributeVal AS attributeValue

END

GRANT EXECUTE ON h3giTariffAttributeValueGet TO b4nuser
GO
