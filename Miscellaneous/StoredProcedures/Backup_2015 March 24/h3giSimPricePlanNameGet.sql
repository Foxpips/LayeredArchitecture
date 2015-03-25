

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giSimPricePlanNameGet
** Author			:	Simon Markey
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	h3giSimPricePlanNameGet 118
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giSimPricePlanNameGet]
	@pricePlanPackageId VARCHAR(50)

AS
BEGIN

SELECT pricePlanPackageName 
FROM h3giPricePlanPackage 
WHERE pricePlanPackageID = @pricePlanPackageId
AND catalogueVersionID IN(SELECT catalogueVersionID FROM h3giCatalogueVersion WHERE activeCatalog ='Y')
END


GRANT EXECUTE ON h3giSimPricePlanNameGet TO b4nuser
GO
