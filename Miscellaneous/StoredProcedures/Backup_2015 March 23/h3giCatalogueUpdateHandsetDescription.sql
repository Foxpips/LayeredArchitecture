
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.h3giCatalogueUpdateHandsetDescription
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	Updates handset bullet points. For ad-hoc use.				
**					
**********************************************************************************************************************
**									
** Change Control	:	2008/08/08 - Adam Jasinski - Created
**
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giCatalogueUpdateHandsetDescription
	@peopleSoftId varchar(50),
	@description	varchar(2000)
AS
BEGIN
	DECLARE @catalogueVersionId int
	SELECT @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	

	UPDATE dbo.b4nAttributeProductFamily
		SET attributeValue = @description
	FROM b4nAttributeProductFamily apf
	INNER JOIN h3giProductCatalogue pc
	ON pc.productFamilyId = apf.productFamilyId
	WHERE pc.catalogueVersionId = @catalogueVersionId
	AND pc.peopleSoftId = @peopleSoftId
	AND pc.productType = 'HANDSET'
	AND apf.attributeId = 1
END

GRANT EXECUTE ON h3giCatalogueUpdateHandsetDescription TO b4nuser
GO
