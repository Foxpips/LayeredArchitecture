
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueGetHandset 
** Author			:	Adam Jasinski
** Date Created		:	27/02/2007
**					
**********************************************************************************************************************
**				
** Description		:	Retrieves catalogue data for a specified handset
**					
** Parameters		:
**			@handsetProductId - handset catalogueProductId
**			@catalogueVersionId - handset catalogueVersionId; if omitted, active catalogue version is used
**********************************************************************************************************************
**									
** Change Control	:	27/02/2007 - Adam Jasinski	- Created
**
**********************************************************************************************************************/

CREATE PROCEDURE h3giCatalogueGetHandset 
	@handsetProductId int,
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
	,riskLevel
	from h3giProductCatalogue 
	where catalogueVersionId = @catalogueVersionId
	and catalogueProductId = @handsetProductId
END


GRANT EXECUTE ON h3giCatalogueGetHandset TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueGetHandset TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueGetHandset TO reportuser
GO
