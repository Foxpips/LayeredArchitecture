  
/*********************************************************************************************************************  
**                       
** Procedure Name : h3giCatalogueCreateSingleTariffForHandset  
** Author   : Adam Jasinski   
** Date Created  : 28/11/2006  
**       
**********************************************************************************************************************  
**      
** Description  : Sets up a SINGLE handset tariff    
**       
**********************************************************************************************************************  
**           
** Change Control : 28/11/2006 - Adam Jasinski - Created  
    23/01/2007 - Adam Jasinski - changed @chargeCode parameter to int  
    13/02/2007 - Adam Jasinski - added @deliveryCharge parameter  
    08/05/2007 - Adam Jasinski - added @affinityGroupID parameter; reordered parameters  
    22/06/2007 - Adam Jasinski - added @priceGroupID parameter;   
           modified logic to use PriceGroupDetailPrice;  
           removed @affinityGrop parameter;  
           removed @productFamilyID parameter;  
           removed @affectedBasePrice parameter;  
**********************************************************************************************************************/  
  
CREATE PROCEDURE [dbo].[h3giCatalogueCreateSingleTariffForHandset]  
@catalogueVersionID int,  
@catalogueProductID int,  
@pricePlanPackageID int,  
@priceGroupId int,  
@chargeCode varchar(50),  
@priceDiscount money,  
@deliveryCharge money = 0.00  
AS  
BEGIN  
DECLARE   
@NewTranCreated int,  
@RC int  
SET @NewTranCreated = 0  
SET @RC=0  
   
IF @@TRANCOUNT = 0  --if not in a transaction context yet  
BEGIN  
 SET @NewTranCreated = 1  
 BEGIN TRANSACTION  --then create a new transaction  
END  
  
  PRINT ''  
PRINT 'CatalogueVersionId: ' + CONVERT(varchar(2),@catalogueVersionID)  
PRINT 'PriceGroupId: ' + CONVERT(varchar(2),@priceGroupId)  
PRINT 'PricePlanPackageId: ' + CONVERT(varchar(10),@pricePlanPackageID)  
PRINT 'CatalogueProductId: ' + CONVERT(varchar(10),@catalogueProductId)  
  
  
DECLARE @pricePlanPackageDetailId int  
  
SELECT @pricePlanPackageDetailId=pricePlanPackageDetailId   
FROM h3giPricePlanPackageDetail  
WHERE catalogueVersionId=@catalogueVersionID AND catalogueProductId=@catalogueProductId AND pricePlanPackageId=@pricePlanPackageId;  
  
INSERT INTO h3giPriceGroupPackagePrice  
(  
  [pricePlanPackageDetailId],  
  [catalogueVersionId],  
  [priceGroupId],  
  [chargeCode],  
  [priceDiscount],  
  [deliveryCharge]  
)  
VALUES  
(  
   @pricePlanPackageDetailId,  
   @catalogueVersionID,  
   @priceGroupId,    
   @chargeCode,   
   @priceDiscount,  
   @deliveryCharge  
)  
IF @@ERROR<>0  GOTO ERR_HANDLER  
  
DECLARE @productFamilyId int, @productBasePrice money  
  
SELECT @productFamilyId = productFamilyId, @productBasePrice = productBasePrice FROM h3giProductCatalogue  
WHERE catalogueVersionId = @catalogueVersionId AND catalogueProductId = @catalogueProductId;  
  
--We use simple SQL insert statement here because sp h3giSetProductAttribute updates the attribute if (productFamilyId, storeId, attributeId) combination  
--is found  
INSERT INTO b4nattributeproductfamily  
(productFamilyId, storeId, attributeId, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM,   
                      attributeImageName, attributeImageNameSmall, modifyDate, createDate, priceGroupId)  
VALUES  
  (@productfamilyID, 1, 300, CONVERT(varchar(20), @pricePlanPackageID), 0, ROUND((@productBasePrice+@priceDiscount), 2), 0, 0, '', '', getdate(), getdate(), @priceGroupId);  
IF @@ERROR<>0  GOTO ERR_HANDLER  
  
IF @NewTranCreated=1 AND @@TRANCOUNT > 0  
  COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure  
RETURN 0  
  
ERR_HANDLER:  
 PRINT 'h3giCatalogueCreateSingleTariffForHandset: Rolling back...'  
 IF @NewTranCreated=1 AND @@TRANCOUNT > 0   
  ROLLBACK TRANSACTION  --rollback all changes  
 RETURN -1  --return error code  
END  
  
  
  
GRANT EXECUTE ON h3giCatalogueCreateSingleTariffForHandset TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueCreateSingleTariffForHandset TO reportuser
GO
