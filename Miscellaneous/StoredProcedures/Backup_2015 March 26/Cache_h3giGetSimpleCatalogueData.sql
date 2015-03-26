

-- ========================================================================
-- Author:		Stephen Quin
-- Create date: 09/03/2010
-- Description:	Procedure that returns a simple	catalogue data set that 
--				will be used for cache dependency stuff
-- Changes:		??  -  Stephen Quin  -  added a section for Product Badges
--				17/05/2012 - Simon Markey - New dependency on attributeValue
--				21/03/2013 - Stephen King - Added Click and Collect select
-- ========================================================================
CREATE PROCEDURE [dbo].[Cache_h3giGetSimpleCatalogueData]
AS
BEGIN
	SELECT	[catalogue].[productName], 
			[catalogue].[validStartDate], 
			[catalogue].[validEndDate], 
			[catalogue].[peopleSoftId], 
			[catalogue].[prepay]
	FROM	[dbo].[h3giProductCatalogue] AS [catalogue]
		INNER JOIN [dbo].[h3giCatalogueVersion] AS [version]
			ON [catalogue].[catalogueVersionId] = [version].[catalogueVersionId]
			AND [version].[activeCatalog] = 'Y'
			
	SELECT	[catalogue].[productName], 
			[catalogue].[productFamilyId],
			[catalogue].[prepay],
			[family].[attributeValue]
	FROM	[dbo].[h3giProductCatalogue] AS [catalogue]
		INNER JOIN [dbo].[h3giCatalogueVersion] AS [version]
			ON [catalogue].[catalogueVersionId] = [version].[catalogueVersionId]
			AND [version].[activeCatalog] = 'Y'
		INNER JOIN [dbo].[b4nAttributeProductFamily] AS [family]
			ON [catalogue].[productFamilyId] = [family].[productFamilyId]
		INNER JOIN [dbo].[b4nAttribute] AS [attribute]
			ON [family].[attributeId] = [attribute].[attributeId]
			AND [attribute].[attributeName] = 'ProductBadge'
	
	SELECT	[retailer].[channelCode],
			[retailer].[retailerCode],
			[retailer].[catalogueProductId]
	FROM	[dbo].[h3giRetailerHandset] AS [retailer]
		INNER JOIN [dbo].[h3giCatalogueVersion] AS [version]
			ON [retailer].[catalogueVersionId] = [version].[catalogueVersionId]
			AND [version].[activeCatalog] = 'Y'
	WHERE	[retailer].[channelCode] = 'UK000000290'
	

    SELECT	[price].[pricePlanPackageDetailId],
			[price].[priceGroupId],
			[price].[chargeCode],
			[price].[priceDiscount],
			[price].[deliveryCharge]
	FROM	[dbo].[h3giPriceGroupPackagePrice] AS [price]
		INNER JOIN [dbo].[h3giCatalogueVersion] AS [version]
			ON [price].[catalogueVersionId] = [version].[catalogueVersionId]
			AND [version].[activeCatalog] = 'Y'
			
	SELECT	[upgrade].[productID],
			[upgrade].[pricePlanID],
			[upgrade].[BandCode],
			[upgrade].[Discount]
	FROM	[dbo].[h3giProductPricePlanBandDiscount] AS [upgrade]
		INNER JOIN [dbo].[h3giCatalogueVersion] AS [version]
			ON [upgrade].[catalogueVersionId] = [version].[catalogueVersionId]
			AND [version].[activeCatalog] = 'Y'
			
	SELECT	[family].[attributeValue]
	FROM	[dbo].[b4nAttributeProductFamily] AS [family]
		INNER JOIN [dbo].[h3giProductCatalogue] AS [catalogue]
			ON [catalogue].catalogueProductID = [family].[productFamilyId]
		INNER JOIN [dbo].[h3giCatalogueVersion] AS [VERSION]
			ON [catalogue].[catalogueVersionId] = [VERSION].[catalogueVersionId]
			AND [VERSION].[activeCatalog] = 'Y'
	WHERE	[family].[attributeId] = 1
			AND [catalogue].[productType] = 'HANDSET'
	
	SELECT  [pack].[pricePlanPackageName], 
			[pack].[pricePlanPackageDescription]
	FROM    [dbo].[h3giPricePlanPackage] AS [pack]
		INNER JOIN [dbo].[h3giCatalogueVersion] AS [version]
			ON [pack].[catalogueVersionID] = [version].[catalogueVersionID]
			AND [version].[activeCatalog] = 'Y'
			
	SELECT [Click].[PeopleSoftId] 
	FROM [dbo].[h3giClickAndCollect] AS [Click]
	
END




GRANT EXECUTE ON Cache_h3giGetSimpleCatalogueData TO b4nuser
GO
