

-- ================================================================================
-- Author:		Stephen Quin
-- Create date: 08/05/09
-- Description:	Returns the product name and peopleSoftIds off all products for 
--				the current catalogue version
-- Changes:		20/07/2011	-	Stephen Quin	 -	Accessories now also returned
--				07/06/2012  -   Simon Markey	 -	Includes Tariffs (not business)
--				12/06/2013	-	Stephen Quin	 -	Product Type of SIM returned
--				17/07/2013  -   Sorin Oboroceanu -  ValidEndDate now also returned
--				29/08/2013	-	Simon Markey	 -  Adding new flag for sims
-- ================================================================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetProductList] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE
	@versionID int

	SELECT @versionId = dbo.fn_GetActiveCatalogueVersion();

    SELECT	DISTINCT 
		catalogue.productName, 
		catalogue.peopleSoftId,
		COALESCE(attribute.attributeValue, catalogue.productType) AS productType,
		catalogue.ValidEndDate,
		CASE WHEN isSim.attributeValue IS NULL 
		THEN cast(0 as bit)  
        ELSE cast(1 as bit)
		END AS isSim	
	FROM	h3giProductCatalogue catalogue
		LEFT OUTER JOIN h3giPricePlanPackageDetail detail
			ON  catalogue.catalogueProductId = detail.catalogueProductId
			AND catalogue.catalogueVersionId = detail.catalogueVersionId
		LEFT OUTER JOIN h3giProductAttributeValue attribute
			ON catalogue.catalogueProductID = attribute.catalogueProductId
			AND	attribute.attributeId = 2	
		LEFT OUTER JOIN h3giProductAttributeValue isSim
			ON catalogue.catalogueProductID = isSim.catalogueProductId
			AND isSim.attributeId = 8
	WHERE	catalogue.productType IN ('HANDSET','ACCESSORY','TARIFF')
	AND		catalogue.catalogueVersionId = @versionId
	AND		catalogue.PrePay <> 2
	AND		catalogue.peoplesoftID <> '00000'	
	AND		catalogue.peoplesoftID NOT LIKE '%TB%'
	ORDER BY productType, productName
END

GRANT EXECUTE ON h3giCatalogueGetProductList TO b4nuser
GO
