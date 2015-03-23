

-- ======================================================================================= 
-- Author:  Stephen Quin  
-- Create date: 31/01/08  
-- Description: Creates a new handset in the catalogue - looks up the values in the newly   
--				created [h3giCatalogueCreateHandsetFromStaging] table and passes these 
--				values along with values passed as parameters to the h3giCatalogueCreateHandset   
--				stored procedure
-- Changes:	04/07/2011 - Stephen Quin - h3giCatalogueCreateHandset now accepts 2 new parameters
--			05/06/2012 - Stephen Quin - h3giCatalogueCreateHandset now accepts a new parameter (@simType)
--			08/10/2012 - Stephen Quin - featuresDescription removed from h3giHandsetStaging
-- ======================================================================================== 
CREATE PROCEDURE [dbo].[h3giCatalogueCreateHandsetFromStaging]  
 @catalogueVersionID SMALLINT,  
 @peopleSoftID VARCHAR(50),  
 @catalogueProductID INT,  
 @productFamilyID INT,  
 @prepay SMALLINT,  
 @createTariffs BIT=0,  
 @createBusinessTariffs BIT=0,  
 @handsetTypeAttribute VARCHAR(50) = 'HANDSET',
 @nbs BIT = 0
AS  
BEGIN  
 --declare local variables--  
 DECLARE @productName VARCHAR(50),
 @validStartDate DATETIME,
 @validEndDate DATETIME,
 @chargeCode VARCHAR(25),  
 @basePrice MONEY,
 @kitted BIT,
 @riskLevel VARCHAR(5),
 @modelName VARCHAR(200),
 @imagePath VARCHAR(1000),
 @infoURL VARCHAR(1000),
 @manufacturer VARCHAR(100),
 @model VARCHAR(100),
 @simType INT
  
 --get the values for the local variables from the [h3giProductHandsetStaging] table  
 SELECT @productName = productName,  
   @validStartDate = validStartDate,  
   @validEndDate = validEndDate,  
   @chargeCode = chargeCode,  
   @basePrice = basePrice,  
   @kitted = kitted,  
   @riskLevel = riskLevel,      
   @modelName = modelName,  
   @imagePath = imagePath,  
   @infoURL = infoURL,
   @manufacturer = manufacturer,
   @model = model,
   @simType = simType
 FROM [dbo].[h3giProductHandsetStaging]  
 WHERE peopleSoftID = @peopleSoftID  
 
 --create the new handset (error handling done in h3giCatalogueCreateHandset)--  
 EXEC h3giCatalogueCreateHandset   
		@catalogueVersionID = @catalogueVersionID,  
        @catalogueProductID = @catalogueProductID,  
        @productName = @productName,  
        @ValidStartDate = @validStartDate,  
        @ValidEndDate = @validEndDate,  
        @productChargeCode = @chargeCode,  
        @catalogueProductBasePrice = @basePrice,  
        @peoplesoftID = @peopleSoftID,  
        @prepay = @prepay,  
        @productfamilyID = @productFamilyID,  
        @AttS4NBasePrice = 0,          
        @AttModelName = @modelName,  
        @AttImagePath = @imagePath,  
        @AttInfoURL = @infoURL,  
        @kitted = @kitted,  
        @productType = 'HANDSET',  --for both Handsets and Datacards;  
        @riskLevel = @riskLevel,  
        @handsetTypeAttribute = @handsetTypeAttribute,
        @manufacturer = @manufacturer,
        @model = @model,
        @simType = @simType
  
 --check if Tariffs have to be created--  
 IF @createTariffs = 1  
 BEGIN  
  PRINT @productName + ': Creating handset-tariff combinations...'  
  EXEC h3giCatalogueCreateHandsetTariffCombinationsForPricePlanSet @catalogueVersionID, @catalogueProductID, @createBusinessTariffs, @nbs
 END  

            
END  


GRANT EXECUTE ON h3giCatalogueCreateHandsetFromStaging TO b4nuser
GO
