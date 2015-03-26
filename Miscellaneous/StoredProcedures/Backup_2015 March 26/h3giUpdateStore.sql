
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giUpdateStore
** Author		:	Peter Murphy
** Date Created		:	28/02/06
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure updates a store's data
**					
**********************************************************************************************************************
**									
** Change Control	:	06/03/2013 - Stephen King     - Added Click and Collect parameter
**                  :	19/07/2013 - Sorin Oboroceanu - Added ClickAndCollectStoreAddress parameter
**						
**********************************************************************************************************************/
 

CREATE procedure [dbo].[h3giUpdateStore]

@StoreCode varchar(20),
@RetailerCode varchar(20),
@StoreName varchar(50),
@StorePhone varchar(30),
@StoreAddr1 varchar(50),
@StoreAddr2 varchar(50),
@StoreCity varchar(50),
@StoreCountyID varchar(50),
@Active bit,
@IsClickandCollect bit,
@ClickAndCollectStoreName nvarchar(50),
@ClickAndCollectStoreAddress nvarchar(200)

AS

DECLARE @RecFound int
DECLARE @ErrorCode int

SET @RecFound = 0


--Check if any other store is using this name
select @RecFound = count(*) from h3giRetailerStore
where storeName = @StoreName
  and storeCode <> @StoreCode

if @RecFound > 0
BEGIN
	return 2
END


BEGIN TRAN
--If all is okay, then update the database
update h3giRetailerStore
set storeName = @StoreName,
    storePhoneNumber = @StorePhone,
    storeAddress1 = @StoreAddr1,
    storeAddress2 = @StoreAddr2,
    StoreCity = @StoreCity,
    storeCounty = @StoreCountyID,
    IsActive = @Active,
    IsClickAndCollect = @IsClickandCollect,
	ClickAndCollectStoreName = @ClickAndCollectStoreName,
	ClickAndCollectStoreAddress = @ClickAndCollectStoreAddress
where storeCode = @StoreCode


--Check if any errors occurred
SET @ErrorCode = @@ERROR
if @ErrorCode > 0
BEGIN
	ROLLBACK TRAN
	return 1
END
ELSE
BEGIN
	COMMIT TRAN
	return 0
END




GRANT EXECUTE ON h3giUpdateStore TO b4nuser
GO
GRANT EXECUTE ON h3giUpdateStore TO ofsuser
GO
GRANT EXECUTE ON h3giUpdateStore TO reportuser
GO
