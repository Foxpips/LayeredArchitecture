
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreatePriceGroup
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Creates a new price group, or updates its name if it exists
**					
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCatalogueCreatePriceGroup]
	@catalogueVersionId int,
	@priceGroupId int,
	@priceGroupName varchar(50),
	@priceGroupDescription varchar(255) = ''
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM h3giPriceGroup WHERE priceGroupID = @priceGroupId AND catalogueVersionId=@catalogueVersionId)
		INSERT INTO h3giPriceGroup (catalogueVersionId, priceGroupId, name, description)
		VALUES  (@catalogueVersionId, @priceGroupId, @priceGroupName, @priceGroupDescription);
	ELSE
		UPDATE h3giPriceGroup
		SET name = @priceGroupName, description = @priceGroupDescription
		WHERE catalogueVersionId = @catalogueVersionId AND priceGroupID = @priceGroupId;
	END



GRANT EXECUTE ON h3giCatalogueCreatePriceGroup TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueCreatePriceGroup TO reportuser
GO
