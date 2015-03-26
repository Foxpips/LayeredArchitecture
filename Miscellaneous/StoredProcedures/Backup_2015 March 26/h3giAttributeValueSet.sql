
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAttributeValueSet
** Author			:	Simon Markey
** Date Created		:	15/05/2012
**					
**********************************************************************************************************************
**				
** Description		:	Updates the bullet point product attribute description for a specified peopleSoftId
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/


CREATE PROC [dbo].[h3giAttributeValueSet]
@peopleSoftId AS VARCHAR(50),
@attributeVal  AS NVARCHAR(MAX)

AS
BEGIN

DECLARE @catalogueId VARCHAR(MAX)

SELECT @catalogueId = catalogueVersionID 
  FROM h3giCatalogueVersion 
  WHERE activeCatalog = 'Y'

UPDATE b4nAttributeProductFamily
  SET attributeValue = @attributeVal
  WHERE b4nAttributeProductFamily.attributeId = 1
  AND productFamilyId in (SELECT productfamilyid 
						    FROM h3giProductCatalogue 
						    WHERE peoplesoftID = @peopleSoftId 
						    AND catalogueVersionID = @catalogueId)

END

GRANT EXECUTE ON h3giAttributeValueSet TO b4nuser
GO
