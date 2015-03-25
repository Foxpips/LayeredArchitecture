
CREATE PROCEDURE [dbo].[h3giGetAddOns]
(
	@isCurrentAddOn BIT
)

AS
BEGIN
    DECLARE @versionId INT = dbo.fn_GetActiveCatalogueVersion()
	DECLARE @date DATETIME = GETDATE()

	SELECT productName, ao.catalogueProductId as productId, ValidStartDate,ValidEndDate
	INTO #addons
	FROM h3giAddOn AS ao
	INNER JOIN h3giProductCatalogue AS pc
		ON ao.catalogueProductId = pc.catalogueProductID
	WHERE pc.catalogueVersionID = @versionId
		AND ao.catalogueVersionId = pc.catalogueVersionID
	AND ao.catalogueProductId NOT IN 
	(
		SELECT productFamilyId
		FROM b4nAttributeProductFamily
		WHERE
			attributeId IN 
			(
				SELECT attributeId 
				FROM b4nAttribute 
				WHERE attributeName = 'Add On Mandatory'
			)
			AND attributeValue = '1'
		UNION
		SELECT ao.catalogueProductId
		FROM h3giAddOnAddOnCategory aoaoc
		INNER JOIN h3giaddon ao
			ON aoaoc.addOnId = ao.addOnId
		WHERE aoaoc.addOnCategoryId = 25 -- Sharer Discount
			AND ao.catalogueVersionId = @versionId
	)
	ORDER BY productName ASC
			
	IF @isCurrentAddOn = 1
	BEGIN
		SELECT productName, productId
		FROM #addons
		WHERE ValidStartDate <= @date
		AND ValidEndDate > @date
	END
	ELSE
	BEGIN
		SELECT productName, productId
		FROM #addons
	END
	
	DROP TABLE #addons
END


GRANT EXECUTE ON h3giGetAddOns TO b4nuser
GO
