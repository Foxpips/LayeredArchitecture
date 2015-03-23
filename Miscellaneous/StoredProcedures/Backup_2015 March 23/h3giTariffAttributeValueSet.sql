

CREATE PROC [dbo].[h3giTariffAttributeValueSet]
@peopleSoftId AS VARCHAR(50),
@attributeVal  AS NVARCHAR(MAX)

AS
BEGIN

DECLARE @catalogueId VARCHAR(50)

SELECT @catalogueId = catalogueVersionID 
  FROM h3giCatalogueVersion 
  WHERE activeCatalog = 'Y'

UPDATE h3giPricePlanPackage
  SET pricePlanPackageDescription = @attributeVal
  WHERE peoplesoftID = @peopleSoftId and catalogueVersionID = @catalogueId

END

GRANT EXECUTE ON h3giTariffAttributeValueSet TO b4nuser
GO
