
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 06-March-2013
-- Description:	Gets a retailer's store by the store id.
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetRetailerStoreById]
(
	@Id int
)
AS
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
	SELECT 
		storeCode,
		storeName,
		retailerCode,
		channelCode,
		storePhoneNumber,
		storeAddress1,
		storeAddress2,
		StoreCity,
		'Co. ' + x.b4nClassDesc AS storeCounty,
		IsActive,
		IsClickAndCollect,
		Id,
		ClickAndCollectStoreName,
		ClickAndCollectStoreAddress
	FROM h3giRetailerStore
	INNER JOIN b4nClassCodes x 
	ON x.b4nClassSysID = 'SubCountry' 
	AND x.b4nClassCode = h3giRetailerStore.storeCounty
    WHERE Id = @Id  
END  




GRANT EXECUTE ON h3giGetRetailerStoreById TO b4nuser
GO
