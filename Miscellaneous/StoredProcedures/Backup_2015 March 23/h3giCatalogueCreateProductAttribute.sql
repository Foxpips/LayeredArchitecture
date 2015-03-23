
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreateProductAttribute
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Creates a new product attribute entry, or updates its name if it exists
**					
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giCatalogueCreateProductAttribute
	@attributeID int, 
	@attributeName varchar(20),
	@attributeDescription nvarchar(100) = ''
AS
BEGIN
	BEGIN
		IF NOT EXISTS (SELECT * FROM h3giProductAttribute WHERE attributeID = @attributeID)
		INSERT INTO h3giProductAttribute (attributeID, attributeName, attributeDescription)
		VALUES  (@attributeID, @attributeName, @attributeDescription);
	ELSE
		UPDATE h3giProductAttribute
		SET attributeName = @attributeName,
			attributeDescription = @attributeDescription
		WHERE attributeID = @attributeID;
END

END


GRANT EXECUTE ON h3giCatalogueCreateProductAttribute TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueCreateProductAttribute TO reportuser
GO
