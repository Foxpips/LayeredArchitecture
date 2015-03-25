
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreateHandsetAttributes
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Inserts attribute for a handset identified by catalogueVersionId AND:
**					:	1) @catalogueProductId (takes precedence)
**						OR
**						2) @peopleSoftID
**						Attribute is identified by:
**						1) @attributeID (takes precedence)
**						OR
**						2) @attributeName
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giCatalogueCreateHandsetAttributes
	@catalogueVersionId int,
	@catalogueProductId int = NULL,
	@peopleSoftID varchar(50) = NULL, 
	@attributeID int = NULL,
	@attributeName varchar(20) = NULL,
	@attributeValue varchar(20)
AS
BEGIN

	IF @attributeID IS NULL AND @attributeName IS NOT NULL
	BEGIN
		SELECT @attributeID = attributeID FROM h3giProductAttribute
		WHERE attributeName = @attributeName;
	END

	IF (@attributeID IS NOT NULL)
	BEGIN
		IF (@catalogueProductId IS NOT NULL OR @peopleSoftID IS NOT NULL)
		BEGIN
			INSERT INTO h3giProductAttributeValue (catalogueProductId, attributeId, attributeValue)
			SELECT pc.catalogueProductId, @attributeID, @attributeValue
			FROM h3giProductCatalogue pc
			WHERE catalogueVersionID = @catalogueVersionId
			AND ((@catalogueProductId IS NULL AND pc.PeopleSoftId = @peopleSoftID)
					OR (@catalogueProductId IS NOT NULL AND pc.catalogueProductId = @catalogueProductId));
		END 
		ELSE
		BEGIN
			RAISERROR ('None of following parameters were specified: @catalogueProductId, @peopleSoftID', -- Message text.
               16, -- Severity.
               1 -- State.
               );
		END
	END
	ELSE
	BEGIN
		RAISERROR ('None of following parameters were specified: @attributeID, @attributeName', -- Message text.
               16, -- Severity.
               1 -- State.
               );
	END

END


GRANT EXECUTE ON h3giCatalogueCreateHandsetAttributes TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueCreateHandsetAttributes TO reportuser
GO
