
--SET XACT_ABORT ON
--GO
-- =============================================
-- Author:		Stephen Quin
-- Create date: 25/06/09
-- Description:	Creates both a retailer and a
--				new store associated with that
--				retailer
-- =============================================
CREATE PROCEDURE [dbo].[h3giCreateRetailerAndStore] 
	@RetailerCode varchar(20),
	@RetailerName varchar(50),
	@GroupID int,
	@Internal varchar(3),
	@DistCode varchar(20),
	@ChannelCode varchar(20),
	@StoreCode varchar(20),
	@StoreName varchar(50),
	@StorePhone varchar(50),
	@StoreAddr1 varchar(50),
	@StoreAddr2 varchar(50),
	@StoreCity varchar(50),
	@StoreCountyID varchar(50),
	@Active bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @RecFound int
    DECLARE @ErrorCount int
	DECLARE @ErrorCode int
	
	--Check if the Retailer Name is already used
	SELECT @RecFound = COUNT(*) FROM h3giRetailer WHERE h3giRetailer.retailerName = @RetailerName
	IF @RecFound > 0
	BEGIN
		RETURN 2
	END
	
	--Check if the Retailer Code is already used
	SELECT @RecFound = COUNT(*) FROM h3giRetailer WHERE h3giRetailer.retailerCode = @RetailerCode
	IF @RecFound > 0
	BEGIN
		return 3
	END
	
	--Check if the Store Name is already in use
	SELECT @RecFound = COUNT(*) FROM h3giRetailerStore WHERE h3giRetailerStore.storeName = @StoreName
	IF @RecFound > 0
	BEGIN
		RETURN 4
	END

	--Check if the Store Code is already in use
	SELECT @RecFound = COUNT(*) FROM h3giRetailerStore WHERE h3giRetailerStore.storeCode = @StoreCode
	IF @RecFound > 0
	BEGIN
		RETURN 5
	END
	
	BEGIN TRANSACTION
	
		--Create the retailer record
		INSERT INTO h3giRetailer (retailerCode, channelCode, retailerName, DistributorCode)
		VALUES(@RetailerCode ,@ChannelCode, @RetailerName, @DistCode)

		SET @ErrorCode = @@ERROR
		IF @ErrorCode > 0 
		BEGIN 
			set @ErrorCount = @ErrorCount + 1
		END
		
		--Create new handsets for the retailer
		CREATE TABLE #HandsetTable (HandsetCount int, retailerCode varchar(20))
		DECLARE @TempRetailer varchar(20)
		SET @TempRetailer = ''

		INSERT INTO #HandsetTable
		SELECT COUNT(*) AS HandsetCount, retailercode 
		FROM h3giretailerhandset 
		WHERE catalogueversionid = dbo.fn_GetActiveCatalogueVersion()
		AND channelcode = @channelCode
		GROUP BY retailercode

		SELECT @TempRetailer = retailerCode 
		FROM #HandsetTable
		WHERE retailerCode IN 
			(	
				SELECT TOP 1 retailerCode 
				FROM #HandsetTable 
				ORDER BY HandsetCount DESC
			)

		DROP TABLE #HandsetTable

		IF(@TempRetailer != '')
		BEGIN
			INSERT INTO h3giRetailerHandset (channelCode, retailerCode, catalogueVersionID, catalogueProductID)
			SELECT	@channelCode, 
					@RetailerCode, 
					catalogueVersionID, 
					catalogueProductID 
			FROM	dbo.h3giRetailerHandset 
			WHERE	retailerCode = @TempRetailer
			AND		channelCode = @channelCode
		END
		
		SET @ErrorCode = @@ERROR
		IF @ErrorCode > 0 
		BEGIN 
			SET @ErrorCount = @ErrorCount + 1
		END


		IF (@Internal = 'No')
		BEGIN
			--Add an SMSGroupDetail record
			INSERT INTO h3giSMSGroupDetail (groupid, retailerCode, channelCode)
			VALUES(@GroupID, @RetailerCode, @channelCode)

			SET @ErrorCode = @@ERROR
			IF @ErrorCode > 0 
			BEGIN 
				set @ErrorCount = @ErrorCount + 1
			END
		END
		ELSE
		BEGIN
			--Add and InternalRetailerCodes record
			INSERT INTO h3giInternalRetailerCodes (retailerCode)
			VALUES(@RetailerCode)

			SET @ErrorCode = @@ERROR
			IF @ErrorCode > 0
			BEGIN
				SET @ErrorCount = @ErrorCount + 1
			END
		END
		
		--check for affinity groups
		IF EXISTS (SELECT * FROM h3giAffinityRetailers WHERE channelCode = @channelCode AND retailerCode = '' AND storeCode = '')
		BEGIN
			INSERT INTO h3giAffinityRetailers
			SELECT	affinityGroupId,
					@channelCode,
					@RetailerCode,
					''
			FROM	h3giAffinityRetailers
			WHERE	channelCode = @channelCode
				AND retailerCode = ''
				AND storeCode = ''
				
			SET @ErrorCode = @@ERROR
			IF @ErrorCode > 0
			BEGIN
				SET @ErrorCount = @ErrorCount + 1
			END
		END
		
		
		--create the new store
		INSERT INTO h3giRetailerStore(storeCode,storeName,retailerCode,channelCode,storePhoneNumber,storeAddress1,storeAddress2,storeCity,storeCounty, IsActive)
		VALUES(@StoreCode,@StoreName,@RetailerCode,@ChannelCode,@StorePhone,@StoreAddr1,@StoreAddr2,@StoreCity,@StoreCountyID, @Active)


		SET @ErrorCode = @@ERROR
		if @ErrorCode > 0
		BEGIN
			SET @ErrorCount = @ErrorCount + 1
		END
		
		--check for affinity groups
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
	IF @ErrorCount > 0
	BEGIN
		ROLLBACK TRAN
		RETURN 1
	END
	ELSE
	BEGIN
		COMMIT TRAN
		RETURN 0
	END

END



GRANT EXECUTE ON h3giCreateRetailerAndStore TO b4nuser
GO
