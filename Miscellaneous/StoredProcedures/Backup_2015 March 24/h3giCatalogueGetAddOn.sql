



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueGetAddOn 
** Author			:	Adam Jasinski
** Date Created		:	27/02/2007
**					
**********************************************************************************************************************
**				
** Description		:	Retrieves catalogue data for a specified addOn
						and for addOnCategories it belongs to
**					
** Parameters		:
**			@addOnProductId - addOn catalogueProductId
**			@catalogueVersionId - addOn catalogueVersionId; if omitted, active catalogue version is used
**********************************************************************************************************************
**									
** Change Control	:	27/02/2007 - Adam Jasinski	- Created
**
**********************************************************************************************************************/

CREATE  PROCEDURE [dbo].[h3giCatalogueGetAddOn] 
	@addOnProductId int,
	@catalogueVersionId int = NULL
AS
BEGIN

	if (@catalogueVersionId is null) OR (@catalogueVersionId <= 0)
	begin
		select @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	end

	SELECT a.addOnId,
		a.catalogueProductId,
		dbo.fn_GetProductFailyIdByCatalogueProductId(a.catalogueProductId) productFamilyId,
		dbo.fn_GetS4NAttributeValue('PRODUCT NAME',a.catalogueProductId) title,
		dbo.fn_GetS4NAttributeValue('DESCRIPTION',a.catalogueProductId) description,
		dbo.fn_GetS4NAttributeValue('Corporate Link - Handset',a.catalogueProductId) moreInfoLink,
		pc.productRecurringPrice,
		pc.productRecurringPriceDiscountType,
		pc.productRecurringPriceDiscountPercentage,
		CONVERT(BIT,ISNULL(dbo.fn_GetS4NAttributeValue('Add On Mandatory',a.catalogueProductId),0)) mandatory,
		dbo.fn_GetS4NAttributeValue('Additional Information',a.catalogueProductId) additionalInformation
	INTO #addOn
	FROM h3giAddOn a
	INNER JOIN h3giProductCatalogue pc
		ON a.catalogueProductId = pc.catalogueProductId
		AND a.catalogueVersionId = pc.catalogueVersionId
	WHERE a.catalogueVersionId = @catalogueversionid 
	AND a.catalogueProductId = @addOnProductId

	SELECT * FROM #addOn

	SELECT * FROM h3giAddOnAddOnCategory
		WHERE addOnId in (SELECT addOnId from #addOn)

	SELECT
	pav.catalogueProductId
	,pa.attributeId
	,pa.attributeName
	,pav.attributeValue
	FROM h3giProductAttributeValue pav
	INNER JOIN h3giProductAttribute pa
		ON pav.attributeId = pa.attributeId
	AND pav.catalogueProductId in ( SELECT catalogueProductId FROM #addOn )

	DROP TABLE #addOn
	
END






GRANT EXECUTE ON h3giCatalogueGetAddOn TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueGetAddOn TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueGetAddOn TO reportuser
GO
