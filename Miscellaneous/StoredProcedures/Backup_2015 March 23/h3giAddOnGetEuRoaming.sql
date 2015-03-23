

-- =======================================================================================
-- Author:		Stephen Quin
-- Create date: 22/06/2010
-- Description:	Gets the add on details for the EU roaming add on
-- Changes:		16/12/2010	-	Stephen Quin	-	the Add On Discount Type and 
--													Add On Discount Duration attributes
--													are now returned	
--              05/07/2011 -	S Mooney		-	Get PeoplesoftId and productBillingId
--			    30/03/2012 -	Stephen Quin	-	Added ValidEndDate and ValidStartDate 
--													to the result set
-- =======================================================================================
CREATE PROCEDURE [dbo].[h3giAddOnGetEuRoaming] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT a.addOnId,
		a.catalogueProductId,
		--dbo.fn_GetProductFailyIdByCatalogueProductId(a.catalogueProductId) productFamilyId,
		pc.productFamilyId,
		dbo.fn_GetS4NAttributeValue('PRODUCT NAME',a.catalogueProductId) title,
		dbo.fn_GetS4NAttributeValue('DESCRIPTION',a.catalogueProductId) description,
		dbo.fn_GetS4NAttributeValue('Corporate Link - Handset',a.catalogueProductId) moreInfoLink,
		pc.productRecurringPrice,
		pc.productRecurringPriceDiscountType,
		pc.productRecurringPriceDiscountPercentage,
		CONVERT(BIT,ISNULL(dbo.fn_GetS4NAttributeValue('Add On Mandatory',a.catalogueProductId),0)) mandatory,
		dbo.fn_GetS4NAttributeValue('Additional Information',a.catalogueProductId) additionalInformation,
		pc.peoplesoftId,
		pc.productBillingId,		
		dbo.fn_GetS4NAttributeValue('Add On Discount Type',a.catalogueProductId) as discountType,
		dbo.fn_GetS4NAttributeValue('Add On Discount Duration',a.catalogueProductId) as discountDuration,
		pc.peoplesoftID,
		pc.productBillingID,
		pc.ValidStartDate,
		pc.ValidEndDate
	FROM h3giAddOn a
	INNER JOIN h3giProductCatalogue pc
		ON a.catalogueProductId = pc.catalogueProductId
		AND a.catalogueVersionId = pc.catalogueVersionId
	WHERE pc.catalogueProductID = 936
	AND pc.catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
	
END




GRANT EXECUTE ON h3giAddOnGetEuRoaming TO b4nuser
GO
