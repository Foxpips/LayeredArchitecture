
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAttributeValueGet
** Author			:	Simon Markey
** Date Created		:	15/05/2012
**					
**********************************************************************************************************************
**				
** Description		:	Returns the bullet point product attribute description
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/


CREATE PROC [dbo].[h3giAttributeValueGet]
@peopleSoftId AS VARCHAR(50)


AS
BEGIN

DECLARE @catalogueId VARCHAR(50)
DECLARE @attributeVal  AS NVARCHAR(MAX)

SELECT @catalogueId = catalogueVersionID FROM h3giCatalogueVersion WHERE activeCatalog = 'Y'


SELECT @attributeVal = attributeValue 
  FROM b4nAttributeProductFamily
  WHERE b4nAttributeProductFamily.attributeId = 1
  AND productFamilyId in (SELECT productfamilyid 
						    FROM h3giProductCatalogue 
						    WHERE peoplesoftID = @peopleSoftId 
						    AND catalogueVersionID = @catalogueId)

SELECT @attributeVal AS attributeValue

END

GRANT EXECUTE ON h3giAttributeValueGet TO b4nuser
GO
