
-- ================================================================
-- Author:		Stephen Quin
-- Create date: 28/05/13
-- Description:	Returns the data that will be used in the business 
--				upgrade registration file
-- ================================================================
CREATE PROCEDURE [dbo].[threeUpgradeRegistration] 
	@runWebTele BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @currentDate DATETIME
	SET @currentDate = GETDATE()
		
	--we want to stop activation from running on certain days (e.g. holidays)
	IF NOT EXISTS ( SELECT [ID] FROM h3giHoliday WHERE hDay = DatePart(dd, @currentDate) AND hMonth = DatePart(mm, @currentDate) AND hYear = DatePart(yyyy, @currentDate))
	BEGIN
		
		DECLARE @runNow CHAR(1),
		@ErrorNumber    INT,
		@ErrorMessage   NVARCHAR(4000),
		@ErrorProcedure NVARCHAR(4000),
		@ErrorLine      INT
				
		SELECT @runNow = idValue FROM config where idName = 'ACTIVATION_RUN_NOW'  	
		
		--Hack for "No Handset"!
		DECLARE @noHandsetId INT
		SELECT @noHandsetId = catalogueProductId FROM h3giProductCatalogue WHERE peoplesoftID = '10000'   	
		
		IF(@runWebTele = 1 OR @runNow = 'Y')
		BEGIN	
			PRINT 'Web/Tele'
			BEGIN TRANSACTION insert_delete
		
			BEGIN TRY
				INSERT INTO gmOrdersDispatched_Temp
				SELECT DISTINCT od.orderRef,
								od.prepay
				FROM gmOrdersDispatched od WITH(TABLOCK)
				INNER JOIN threeOrderUpgradeHeader head WITH(NOLOCK)
					ON od.orderref = head.orderRef
				WHERE (head.IMEI <> '' OR head.deviceId = @noHandsetId)
				
				DELETE FROM gmOrdersDispatched
				WHERE orderref IN 
				(
					SELECT gmt.orderref 
					FROM gmOrdersDispatched_Temp gmt WITH(TABLOCK)
					INNER JOIN threeOrderUpgradeHeader head WITH(NOLOCK)
					ON gmt.orderref = head.orderRef
				)
				
				COMMIT TRANSACTION insert_delete
			END TRY
			BEGIN CATCH
				SET @ErrorNumber = ERROR_NUMBER()
				SET @ErrorMessage = ERROR_MESSAGE()
				SET @ErrorProcedure = ERROR_PROCEDURE()
				SET @ErrorLine = ERROR_LINE()

				RAISERROR ('An error occurred within a user transaction. 
						  Error Number        : %d
						  Error Message       : %s  
						  Affected Procedure  : %s
						  Affected Line Number: %d'
						  , 16, 1
						  , @ErrorNumber, @ErrorMessage, @ErrorProcedure,@ErrorLine)

				IF @@TRANCOUNT > 0
				 ROLLBACK TRANSACTION insert_delete	
			END CATCH		
		END
		ELSE
		BEGIN
			BEGIN TRY
				INSERT INTO gmOrdersDispatched_Temp
				SELECT	head.orderRef, 2
				FROM	threeOrderUpgradeHeader head WITH(TABLOCK)
				WHERE	head.orderRef NOT IN (SELECT orderRef FROM h3giSalesCapture_Audit WITH(NOLOCK))
				AND		head.status = 312
				AND		(head.IMEI <> '' OR head.deviceId = @noHandsetId)
			END TRY
			BEGIN CATCH
				SET @ErrorNumber = ERROR_NUMBER()
				SET @ErrorMessage = ERROR_MESSAGE()
				SET @ErrorProcedure = ERROR_PROCEDURE()
				SET @ErrorLine = ERROR_LINE()

				RAISERROR ('An error occurred within a user transaction. 
						  Error Number        : %d
						  Error Message       : %s  
						  Affected Procedure  : %s
						  Affected Line Number: %d'
						  , 16, 1
						  , @ErrorNumber, @ErrorMessage, @ErrorProcedure,@ErrorLine)				
			END CATCH		
		END		
		
		CREATE TABLE #registrationData
		(
			orderDate DATETIME,
			fulfillmentDate DATETIME,
			orderRef INT,
			linkedOrderRef INT,
			parentBan VARCHAR(10),
			childBan VARCHAR(10),
			msisdn VARCHAR(13),
			imei VARCHAR(20),
			channelCode VARCHAR(20),
			retailerCode VARCHAR(10),
			phoneProductCode VARCHAR(10),
			billingTariffId VARCHAR(20),
			tariffProductCode VARCHAR(10),
			contractDuration INT,
			catalogueVersionId INT,
			parentId INT,			
			orgId VARCHAR(5),
			numberPayments INT,
			paymentReceiptRef VARCHAR(1),
			paymentDate VARCHAR(1),
			paymentAmount VARCHAR(1),
			paymentSource VARCHAR(1),
			paymentType VARCHAR(1)			
		)
		
		CREATE INDEX IDX_parentId ON #registrationData(parentId)
		CREATE INDEX IDX_childBan ON #registrationData(childBan)			
		
		CREATE TABLE #addOnData
		(
			orderRef INT,
			ban VARCHAR(10),			
			addOnBillingId VARCHAR(20)
		)
		
		CREATE TABLE #chargeCodes
		(
			orderRef INT,
			ban VARCHAR(10),
			chargeCode VARCHAR(10),
			chargeAmount MONEY
		)
		
		
		--Parent Records
		INSERT INTO #registrationData
		SELECT	parent.orderDate,
				'',
				head.orderRef,
				ISNULL(link.linkedId,0),
				parent.parentBAN,
				'',
				'',
				'',
				head.channelCode,
				head.retailerCode,
				'',
				ISNULL(cat.productBillingID,''),
				CASE WHEN PATINDEX('%XX%',pack.PeopleSoftID) > 0
					THEN SUBSTRING(pack.PeopleSoftID,0,PATINDEX('%XX%',pack.PeopleSoftID))
					ELSE ISNULL(pack.PeopleSoftID,'')
				END,
				0,
				parent.catalogueVersionId,
				parent.parentId,				
				'COM05',
				0,
				'',
				'',
				'',
				'',
				''				
		FROM	gmOrdersDispatched_Temp gmt WITH(TABLOCK)
		INNER JOIN threeOrderUpgradeHeader head WITH(NOLOCK)
			ON gmt.orderref = head.orderRef
		INNER JOIN threeOrderUpgradeParentHeader parent WITH(NOLOCK)
			ON head.parentId = parent.parentId
		INNER JOIN threeUpgrade upg WITH(NOLOCK)
			ON upg.upgradeId = head.upgradeId
		LEFT OUTER JOIN h3giPricePlanPackage pack WITH(NOLOCK)
			ON pack.pricePlanPackageID = parent.parentTariffId
			AND pack.catalogueVersionID = parent.catalogueVersionId
		LEFT OUTER JOIN h3giProductCatalogue cat WITH(NOLOCK)
			ON cat.peoplesoftID = pack.PeopleSoftID
			AND cat.catalogueVersionID = pack.catalogueVersionID
		LEFT OUTER JOIN h3giLinkedOrders link WITH(NOLOCK)
			ON link.orderRef = gmt.orderref 
				
		--Parent Add Ons
		INSERT INTO #addOnData
		SELECT	reg.orderRef,
				reg.parentBan,
				cat.productBillingID
		FROM	#registrationData reg
		INNER JOIN threeOrderUpgradeParentAddOn addOn WITH(NOLOCK)
			ON reg.parentId = addOn.parentId
		INNER JOIN h3giProductCatalogue cat WITH(NOLOCK)
			ON addOn.addOnId = cat.catalogueProductID
			AND reg.catalogueVersionId = cat.catalogueVersionID
		


		--Child Records
		INSERT INTO #registrationData
		SELECT	head.orderDate,
				hist.statusDate,
				head.orderRef,
				ISNULL(link.linkedId,0),
				upg.parentBAN,
				upg.childBAN,
				upg.msisdn,
				head.IMEI,
				head.channelCode,
				head.retailerCode,
				ISNULL(device.peoplesoftID,''),
				tariff.productBillingID,
				CASE WHEN PATINDEX('%XX%',pack.PeopleSoftID) > 0
					THEN SUBSTRING(pack.PeopleSoftID,0,PATINDEX('%XX%',pack.PeopleSoftID))
					ELSE ISNULL(pack.PeopleSoftID,'')
				END,
				head.contractDuration,
				head.catalogueVersionId,
				0,				
				'COM05',
				0,
				'',
				'',
				'',
				'',
				''				
		FROM	gmOrdersDispatched_Temp gmt WITH(TABLOCK)
		INNER JOIN threeOrderUpgradeHeader head WITH(NOLOCK)
			ON gmt.orderref = head.orderRef
		INNER JOIN threeUpgrade upg WITH(NOLOCK)
			ON head.upgradeId = upg.upgradeId
		INNER JOIN threeOrderUpgradeHistory hist WITH(NOLOCK)
			ON head.orderRef = hist.orderRef
			AND head.status = hist.status		
		INNER JOIN h3giPricePlanPackage pack WITH(NOLOCK)
			ON head.childTariffId = pack.pricePlanPackageID
			AND head.catalogueVersionId = pack.catalogueVersionID
		INNER JOIN h3giProductCatalogue tariff WITH(NOLOCK)
			ON pack.PeopleSoftID = tariff.peoplesoftID
			AND pack.catalogueVersionID = tariff.catalogueVersionID
		LEFT OUTER JOIN h3giProductCatalogue device WITH(NOLOCK)
			ON head.deviceId = device.catalogueProductID
			AND head.catalogueVersionId = device.catalogueVersionID
			AND head.deviceId <> @noHandsetId
		LEFT OUTER JOIN h3giLinkedOrders link WITH(NOLOCK)
			ON head.orderRef = link.orderRef
		
		--Child Add Ons
		INSERT INTO #addOnData
		SELECT	reg.orderRef,
				reg.childBan,
				cat.productBillingID
		FROM	#registrationData reg
		INNER JOIN threeOrderUpgradeAddOn addOn WITH(NOLOCK)
			ON reg.orderRef = addOn.orderRef
		INNER JOIN h3giProductCatalogue cat WITH(NOLOCK)
			ON addOn.addOnId = cat.catalogueProductID
			AND reg.catalogueVersionId = cat.catalogueVersionID
		WHERE reg.parentId = 0
			
		--Charges
		IF(@runWebTele = 1)
		BEGIN
			INSERT INTO #chargeCodes
			SELECT	head.orderRef,
					upg.childBAN,
					codes.chargeCode,
					prices.price
			FROM	gmOrdersDispatched_Temp gmt WITH(TABLOCK)
			INNER JOIN threeOrderUpgradeHeader head WITH(NOLOCK)
				ON gmt.orderref = head.orderRef
			INNER JOIN threeUpgrade upg WITH(NOLOCK)
				ON head.upgradeId = upg.upgradeId
			INNER JOIN h3giProductCatalogue device WITH(NOLOCK)
				ON head.deviceId = device.catalogueProductID
				AND head.catalogueVersionId = device.catalogueVersionID
			INNER JOIN h3giPricePlanPackage pack WITH(NOLOCK)
				ON head.childTariffId = pack.pricePlanPackageID
				AND head.catalogueVersionId = pack.catalogueVersionID
			INNER JOIN threeUpgradeChargeCodes codes WITH(NOLOCK)
				ON head.deviceId = codes.catalogueProductId
			INNER JOIN threeUpgradeBandPrices prices WITH(NOLOCK)
				ON head.deviceId = prices.catalogueProductId
				AND head.catalogueVersionId = prices.catalogueVersionId
				AND pack.pricePlanID = prices.pricePlanId
				AND head.outgoingBand = prices.bandCode
		END
		
		
		
		SELECT * FROM #registrationData ORDER BY orderRef, parentId DESC
		SELECT * FROM #addOnData
		SELECT * FROM #chargeCodes
		
		
	END					
    
END




GRANT EXECUTE ON threeUpgradeRegistration TO b4nuser
GO
