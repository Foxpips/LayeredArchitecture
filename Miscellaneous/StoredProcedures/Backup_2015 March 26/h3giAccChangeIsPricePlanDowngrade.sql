
CREATE PROCEDURE [dbo].[h3giAccChangeIsPricePlanDowngrade]
	@oldPricePlan INT,
	@newPricePlan INT,
	@isDownGrade INT OUTPUT
AS
BEGIN

    DECLARE @versionId INT
    SET @versionId = dbo.fn_GetActiveCatalogueVersion();
    
	SELECT 1
		FROM h3giProductCatalogue AS oldPricePlanPrice
	WHERE catalogueVersionID = @versionId
		AND catalogueProductID = @oldPricePlan
		AND oldPricePlanPrice.productRecurringPrice >
		(
			SELECT productRecurringPrice
				FROM h3giProductCatalogue AS newPricePlanPrice
			WHERE catalogueVersionID = @versionId
				AND catalogueProductID = @newPricePlan
		)
END

SET @isDownGrade = @@ROWCOUNT

GRANT EXECUTE ON h3giAccChangeIsPricePlanDowngrade TO b4nuser
GO
