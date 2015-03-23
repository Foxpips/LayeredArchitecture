
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCreateStore
** Author		    :	Peter Murphy
** Date Created		:	27/02/06
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure creates a store and attaches it to a retailer
** Change Control	:	1.0.0 - 27/02/2006 - Peter Murphy     - Initial version
**				        1.1.0 - 23/02/2007 - Adam Jasinski    - @channelCode is a variable now;
**			      		        10/01/2011 - Stephen Quin     - Added check for affinity groups
**						        06/03/2013 - Stephen King     - Added click and collect bit
**						        19/07/2013 - Sorin Oboroceanu - Added StoreAddress field
**********************************************************************************************************************/


CREATE    procedure [dbo].[h3giCreateStore]

@StoreCode varchar(20),
@RetailerCode varchar(50),
@StoreName varchar(50),
@StorePhone varchar(50),
@StoreAddr1 varchar(50),
@StoreAddr2 varchar(50),
@StoreCity varchar(50),
@StoreCountyID varchar(50),
@Active bit,
@IsClickandCollect bit,
@ClickAndCollectStoreName nvarchar(50),
@ClickAndCollectStoreAddress nvarchar(200)

AS

DECLARE @ErrorCount int
DECLARE @ErrorCode int
DECLARE @RecFound int
DECLARE @channelCode varchar(20)


SET @ErrorCount = 0
 


--Check if the Store Name is already in use
select @RecFound = count(*) from h3giRetailerStore where h3giRetailerStore.storeName = @StoreName
if @RecFound > 0
BEGIN
	return 2
END


--Check if the Store Code is already in use
select @RecFound = count(*) from h3giRetailerStore where h3giRetailerStore.storeCode = @StoreCode
if @RecFound > 0
BEGIN
	return 3
END

--Get the retailer channel
SELECT @channelCode = channelCode FROM h3giRetailer
WHERE retailerCode = @RetailerCode


--Try to insert records
BEGIN TRAN

INSERT INTO h3giRetailerStore(storeCode,storeName,retailerCode,channelCode,storePhoneNumber,storeAddress1,storeAddress2,storeCity,storeCounty, IsActive, IsClickAndCollect, ClickAndCollectStoreName, ClickAndCollectStoreAddress)
VALUES(@StoreCode,@StoreName,@RetailerCode,@channelCode,@StorePhone,@StoreAddr1,@StoreAddr2,@StoreCity,@StoreCountyID, @Active, @IsClickandCollect, @ClickAndCollectStoreName, @ClickAndCollectStoreAddress)


SET @ErrorCode = @@ERROR
if @ErrorCode > 0
BEGIN
	SET @ErrorCount = @ErrorCount + 1
END

IF EXISTS (SELECT * FROM h3giAffinityRetailers WHERE channelCode = @channelCode AND retailerCode = @RetailerCode AND storeCode = '')
BEGIN
	INSERT INTO h3giAffinityRetailers
	SELECT	affinityGroupId,
			@channelCode,
			@RetailerCode,
			@storeCode
	FROM	h3giAffinityRetailers
	WHERE	channelCode = @channelCode
		AND	retailerCode = @RetailerCode
		AND storeCode = ''
		
	SET @ErrorCode = @@ERROR
	IF @ErrorCode > 0
	BEGIN
		SET @ErrorCount = @ErrorCount + 1
	END
END


--If there were any errors, abort and return 1, otherwise commit and return 0
if @ErrorCount > 0
BEGIN
	ROLLBACK TRAN
	return 1
END
ELSE
BEGIN
	COMMIT TRAN
	return 0
END



GRANT EXECUTE ON h3giCreateStore TO b4nuser
GO
GRANT EXECUTE ON h3giCreateStore TO ofsuser
GO
GRANT EXECUTE ON h3giCreateStore TO reportuser
GO
