
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueGetAccessory 
** Author			:	Adam Jasinski
** Date Created		:	27/02/2007
**					
**********************************************************************************************************************
**				
** Description		:	Retrieves catalogue data for a specified accessory
**					
** Parameters		:
**			@catalogueProductId - accessory catalogueProductId
**			@catalogueVersionId - accessory catalogueVersionId; if omitted, active catalogue version is used
**********************************************************************************************************************
**									
** Change Control	:	27/02/2007 - Adam Jasinski	- Created
**
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giCatalogueGetAccessory] 
	@catalogueProductId int,
	@catalogueVersionId int = NULL
AS
BEGIN

	if (@catalogueVersionId is null) OR (@catalogueVersionId <= 0)
	begin
		select @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	end

	select
	catalogueProductID
	,dbo.fnGetS4NProductIdFromCatalogueProductId(catalogueProductID) productFamilyId
	,productType
	,dbo.fn_GetS4NAttributeValue('Product Name',catalogueProductId) productDisplayName
	,dbo.fn_GetS4NAttributeValue('Description',catalogueProductId) productDescription
	,dbo.fn_GetS4NAttributeValue('Base Image Name - Small (.jpg OR .gif)',catalogueProductId) productImage
	,dbo.fn_GetS4NAttributeValue('Corporate Link - Handset',catalogueProductId) productMoreInfoLink
	,dbo.fn_GetS4NAttributeValue('Base Price',catalogueProductId) shop4nowBasePrice
	,productBasePrice
	,peoplesoftId productPeoplesoftId
	,productChargeCode
	from h3giProductCatalogue 
	where catalogueVersionId = @catalogueVersionId
	and catalogueProductId = @catalogueProductId
END

SET QUOTED_IDENTIFIER OFF 

GRANT EXECUTE ON h3giCatalogueGetAccessory TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueGetAccessory TO reportuser
GO
