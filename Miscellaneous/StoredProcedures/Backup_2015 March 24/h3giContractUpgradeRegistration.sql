
-- ==================================================================================
-- Author:		Stephen Quin
-- Create date: 28/06/12
-- Description:	Returns the data to be used in the contract upgrade registration file
-- Changes:
-- 10.12.2013: Stephen Quin, Sorin Oboroceanu - replace the use of gmOrderDispatch_Temp with a temporary table
-- to prevent deadlocks.
-- ==================================================================================
CREATE PROCEDURE [dbo].[h3giContractUpgradeRegistration]
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
		
		CREATE TABLE #ordersDispatched
		(
			orderRef INT
		)

		DECLARE @runNow CHAR(1)
		SELECT @runNow = idValue FROM config where idName = 'ACTIVATION_RUN_NOW'
		
		
		IF(@runWebTele = 1 OR @runNow = 'Y')
		BEGIN			
			BEGIN TRANSACTION insert_delete
			BEGIN TRY			
				INSERT INTO #ordersDispatched    
				SELECT DISTINCT od.orderref								
				FROM gmOrdersDispatched od WITH (TABLOCK) 
				INNER JOIN h3giOrderheader h3gi WITH(NOLOCK)
					ON od.orderref = h3gi.orderref  
				WHERE od.prepay = 2
				AND h3gi.IMEI <> ''
			
				DELETE FROM gmOrdersDispatched
				WHERE orderref IN
				(
					SELECT orderref FROM #ordersDispatched
				)

				INSERT INTO gmOrdersDispatched_Temp
				SELECT orderRef, 2
				FROM #ordersDispatched

				COMMIT TRANSACTION insert_delete
			END TRY
			BEGIN CATCH
				print 'rolling back'
				ROLLBACK TRANSACTION insert_delete
			END CATCH	
		END	
		ELSE
		BEGIN
			INSERT INTO #ordersDispatched
			SELECT	h3gi.orderRef
			FROM	h3giOrderheader h3gi WITH(NOLOCK)
			INNER JOIN b4nOrderHeader b4n WITH(NOLOCK)
				ON h3gi.orderref = b4n.OrderRef
			WHERE	h3gi.orderref NOT IN (SELECT orderref FROM h3giSalesCapture_Audit)
			AND		h3gi.orderType = 2
			AND		b4n.Status = 312
			AND		h3gi.IMEI <> ''

			INSERT INTO gmOrdersDispatched_Temp
			SELECT orderRef, 2
			FROM #ordersDispatched
		END
		
		SELECT	b4n.orderDate AS ORDER_DATE,
				hist.statusDate AS FULFILLMENT_DATE,
				upg.mobileNumberAreaCode + upg.mobileNumberMain AS MSISDN,
				h3gi.IMEI,
				h3gi.channelCode AS CHANNELCODE,
				h3gi.retailerCode AS RETAILERCODE,
				device.peoplesoftID AS PHONEPRODUCTCODE,
				CASE WHEN PATINDEX('%XX%',pack.PeopleSoftID) > 0
					THEN SUBSTRING(pack.PeopleSoftID,0,PATINDEX('%XX%',pack.PeopleSoftID))
					ELSE ISNULL(pack.PeopleSoftID,'')
				END AS TARIFFPRODUCTCODE,   
				pack.PeopleSoftID AS TARIFFPRODUCTCODE,
				h3gi.contractTerm AS CONTRACT_DURATION,
				'COM05' AS ORG_ID,
				h3gi.orderref AS RECORD_ID,
				upg.BillingAccountNumber AS BILLING_ACCOUNT_ID,		
				'' AS NUMBER_PAYMENTS,
				'' AS PAYMENT_RECEIPT_REF,
				'' AS PAYMENT_DATE,
				'' AS PAYMENT_AMOUNT,
				'' AS PAYMENT_SOURCE,
				'' AS PAYMENT_TYPE
		FROM	b4nOrderHeader b4n WITH(NOLOCK)
		INNER JOIN h3giOrderheader h3gi WITH(NOLOCK)
			ON b4n.OrderRef = h3gi.orderref
		INNER JOIN b4nOrderHistory hist WITH(NOLOCK)
			ON b4n.OrderRef = hist.orderRef
			AND b4n.Status = hist.orderStatus
		INNER JOIN #ordersDispatched temp
			ON h3gi.orderref = temp.orderref
		INNER JOIN h3giProductCatalogue device WITH(NOLOCK)
			ON h3gi.phoneProductCode = device.productFamilyId
			AND h3gi.catalogueVersionID = device.catalogueVersionID
		INNER JOIN h3giPricePlanPackage pack WITH(NOLOCK)
			ON h3gi.pricePlanPackageID = pack.pricePlanPackageID
			AND h3gi.catalogueVersionID = pack.catalogueVersionID
		INNER JOIN h3giUpgrade upg WITH(NOLOCK)
			ON h3gi.UpgradeID = upg.UpgradeId
		
		/********** ADDONS ***********/
		SELECT  line.OrderRef AS ORDER_REF,
				COUNT(line.itemName) AS NUM_COMP_PRODUCTS,        
				ISNULL(SUBSTRING((  SELECT '|' + cat.productBillingID
									FROM b4nOrderLine line2 WITH(NOLOCK)							
									INNER JOIN h3giProductCatalogue cat WITH(NOLOCK)
										ON line2.ProductID = cat.productFamilyId
									WHERE line2.OrderRef = line.orderRef
									AND cat.productType = 'ADDON'
									AND cat.catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
				FOR XML PATH ( '' )) ,2, 1000),'') AS COMP_PRODUCT_IDS
		FROM b4nOrderLine line WITH(NOLOCK)
		INNER JOIN #ordersDispatched temp
			ON line.OrderRef = temp.orderref
		INNER JOIN h3giProductCatalogue cat2 WITH(NOLOCK)
			ON line.ProductID = cat2.productFamilyId		
		WHERE cat2.productType = 'ADDON'
			  AND cat2.catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
		GROUP BY line.orderRef
		
		/********** CHARGES **********/		
		CREATE TABLE #chargeCodes
		(
			ORDER_REF INT,
			CHARGE_CODE VARCHAR(10),
			CHARGE_AMOUNT MONEY
		)
		
		IF @runWebTele = 1
		BEGIN
			INSERT INTO #chargeCodes
			SELECT	h3gi.orderRef,		
					chargeCodes.chargeCode,
					(-price.Discount)
			FROM	h3giOrderheader h3gi WITH(NOLOCK)
			INNER JOIN b4nOrderLine line WITH(NOLOCK)
				ON h3gi.orderref = line.OrderRef
			INNER JOIN h3giProductCatalogue hpc WITH(NOLOCK) 
				ON line.ProductID = hpc.catalogueProductID
				AND hpc.productType = 'HANDSET'
				AND hpc.catalogueVersionID = h3gi.catalogueVersionID
			INNER JOIN #ordersDispatched gm
				ON h3gi.orderref = gm.orderref
			INNER JOIN h3giPricePlanPackage pack WITH(NOLOCK)
				ON h3gi.pricePlanPackageID = pack.pricePlanPackageID
				AND h3gi.catalogueVersionID = pack.catalogueVersionID
			INNER JOIN h3giUpgradeChargeCodes chargeCodes WITH(NOLOCK)
				ON chargeCodes.catalogueProductId = h3gi.phoneProductCode
			INNER JOIN h3giProductPricePlanBandDiscount price WITH(NOLOCK)
				ON price.BandCode = h3gi.OutgoingBand
				AND price.productID = hpc.catalogueProductID
				AND price.pricePlanID = pack.pricePlanID
				AND price.catalogueVersionID = h3gi.catalogueVersionID
		END
		
		SELECT * FROM #chargeCodes WHERE CHARGE_CODE <> '' AND CHARGE_AMOUNT <> -1
		DROP TABLE #chargeCodes

		DROP TABLE #ordersDispatched
	END
END

GRANT EXECUTE ON h3giContractUpgradeRegistration TO b4nuser
GO
