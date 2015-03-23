



-- =================================================================================
-- Author:		Stephen Quin
-- Create date: 28/06/2012
-- Description:	Returns the data to be used in the prepay upgrade registration file
-- =================================================================================
CREATE PROCEDURE [dbo].[h3giPrepayUpgradeRegistration] 
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
		
		DECLARE @runNow CHAR(1)
		SELECT @runNow = idValue FROM config where idName = 'ACTIVATION_RUN_NOW'  	
	
		BEGIN TRANSACTION insert_delete		
		
		IF(@runWebTele = 1 OR @runNow = 'Y')
		BEGIN			
			BEGIN TRY			
				INSERT INTO gmOrdersDispatched_Temp    
				SELECT DISTINCT od.orderref, od.prepay   
				FROM gmOrdersDispatched od WITH (TABLOCKX) 
				INNER JOIN h3giOrderheader h3gi WITH(NOLOCK)
					ON od.orderref = h3gi.orderref  
				WHERE od.prepay = 3
				AND h3gi.IMEI <> ''
			
				DELETE FROM gmOrdersDispatched
				WHERE orderref IN
				(
					SELECT orderref FROM gmOrdersDispatched_Temp WITH(NOLOCK) WHERE prepay = 3
				)
				
				COMMIT TRANSACTION insert_delete
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION insert_delete
			END CATCH			
		END	
		ELSE
		BEGIN
			BEGIN TRY
				INSERT INTO gmOrdersDispatched_Temp
				SELECT	h3gi.orderRef, 3
				FROM	h3giOrderheader h3gi WITH(NOLOCK)
				INNER JOIN b4nOrderHeader b4n WITH(NOLOCK)
					ON h3gi.orderref = b4n.OrderRef
				WHERE	h3gi.orderref NOT IN (SELECT orderref FROM h3giSalesCapture_Audit)
				AND		h3gi.orderType = 3
				AND		b4n.Status = 312
				AND		h3gi.IMEI <> ''
				
				DELETE FROM gmOrdersDispatched
				WHERE orderref IN
				(
					SELECT orderref FROM gmOrdersDispatched_Temp WITH(NOLOCK) WHERE prepay = 3
				)
				
				COMMIT TRANSACTION insert_delete
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION insert_delete
			END CATCH			
		END
		
		SELECT	h3gi.orderRef AS RECORD_ID,
				b4n.OrderDate AS ORDER_DATE,
				hist.statusDate AS FULFILLMENT_DATE,
				upg.mobileNumberAreaCode + upg.mobileNumberMain AS MSISDN,
				upg.BillingAccountNumber AS BILLING_ACCOUNT_ID,
				h3gi.IMEI,		
				h3gi.retailerCode AS RETAILERCODE,
				h3gi.channelCode AS CHANNELCODE,
				device.peoplesoftID AS PHONEPRODUCTCODE,
				pack.PeopleSoftID AS TARIFFPRODUCTCODE,
				'COM05'	AS ORG_ID,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 1 THEN 'R'
				WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN 'N'
				WHEN upg.registeredCustomer = 1 THEN 'U'
				END AS UPDATE_CUSTOMER,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE b4n.billingForename END AS FIRSTNAME,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE b4n.billingSurname END AS LASTNAME,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE h3gi.initials END AS INITIALS,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE h3gi.title END AS TITLE,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE h3gi.gender END AS GENDER,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' 
					 ELSE RIGHT('00' + CAST(h3gi.dobDD AS VARCHAR(2)), 2) +'/' + RIGHT('00' + CAST(h3gi.dobMM AS VARCHAR(2)), 2) +'/' + CAST(h3gi.dobYYYY AS VARCHAR(4)) 
				END AS D_O_B,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE b4n.Email END AS EMAILWORK,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE SUBSTRING(h3gi.billingAptNumber, 1, 10) END AS MAIN_FLATNUMBER,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE h3gi.billingHouseNumber END AS MAIN_HOUSENUMBER,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE h3gi.billingHouseName END AS MAIN_HOUSENAME,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE b4n.billingAddr2 END AS MAIN_STREETNAME,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE b4n.billingAddr3 END AS MAIN_LOCALITY,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE b4n.billingCity END AS MAIN_CITY,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE b4n.billingCounty END AS MAIN_COUNTY,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE ISNULL(b4n.billingPostCode,'') END AS MAIN_POSTCODE,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE 'IE' END AS MAIN_COUNTRYCODE,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' 
				ELSE 
					CASE WHEN h3gi.daytimeContactNumber = '' THEN '' ELSE '353' END 
				END AS WORK_PHONE_COUNTRY,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE h3gi.daytimeContactAreaCode END AS WORK_PHONE_AREA,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE h3gi.daytimeContactNumber END AS WORK_PHONE_MAIN,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' 
				ELSE 
					CASE WHEN h3gi.homePhoneNumber = '' THEN '' ELSE '353' END 
				END AS HOME_PHONE_COUNTRY,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE h3gi.homePhoneAreaCode END AS HOME_PHONE_AREA,
				CASE WHEN upg.registeredCustomer = 0 AND h3gi.registrationRequest = 0 THEN '' ELSE h3gi.homePhoneNumber END AS HOME_PHONE_MAIN				
		FROM	h3giOrderheader h3gi WITH(NOLOCK)
		INNER JOIN b4nOrderHeader b4n WITH(NOLOCK)
			ON h3gi.orderref = b4n.OrderRef
		INNER JOIN gmOrdersDispatched_Temp temp WITH(NOLOCK)
			ON h3gi.orderref = temp.orderref
			AND h3gi.orderType = temp.prepay
		INNER JOIN b4nOrderHistory hist WITH(NOLOCK)
			ON b4n.OrderRef = hist.orderRef
			AND b4n.Status = hist.orderStatus		
		INNER JOIN h3giUpgrade upg WITH(NOLOCK)
			ON h3gi.UpgradeID = upg.UpgradeId
		INNER JOIN h3giProductCatalogue device WITH(NOLOCK)
			ON h3gi.phoneProductCode = device.productFamilyId
			AND h3gi.catalogueVersionID = device.catalogueVersionID
		INNER JOIN h3giPricePlanPackage pack WITH(NOLOCK)
			ON h3gi.pricePlanPackageID = pack.pricePlanPackageID
			AND h3gi.catalogueVersionID = pack.catalogueVersionID
		WHERE temp.prepay = 3
		
		
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
					CASE WHEN hpc.productType = 'HANDSET' THEN ISNULL(chargeCodes.chargeCode,'') ELSE hpc.productChargeCode END,
					CASE WHEN hpc.productType = 'HANDSET' THEN ISNULL((-price.Discount),-1) ELSE hpc.productBasePrice END	
			FROM	h3giOrderheader h3gi WITH(NOLOCK)
			INNER JOIN b4nOrderLine line WITH(NOLOCK)
				ON h3gi.orderref = line.OrderRef
			INNER JOIN h3giProductCatalogue hpc WITH(NOLOCK) 
				ON line.ProductID = hpc.catalogueProductID
				AND hpc.productType IN ('HANDSET','TOPUPVOUCHER','SURFKIT')
				AND hpc.catalogueVersionID = h3gi.catalogueVersionID
			INNER JOIN gmOrdersDispatched_Temp gm WITH(NOLOCK)
				ON h3gi.orderref = gm.orderref
			INNER JOIN h3giPricePlanPackage pack WITH(NOLOCK)
				ON h3gi.pricePlanPackageID = pack.pricePlanPackageID
				AND h3gi.catalogueVersionID = pack.catalogueVersionID
			LEFT JOIN h3giUpgradeChargeCodes chargeCodes WITH(NOLOCK)
				ON chargeCodes.catalogueProductId = h3gi.phoneProductCode
			LEFT JOIN h3giProductPricePlanBandDiscount price WITH(NOLOCK)
				ON price.BandCode = h3gi.OutgoingBand
				AND price.productID = hpc.catalogueProductID
				AND price.pricePlanID = pack.pricePlanID
				AND price.catalogueVersionID = h3gi.catalogueVersionID
			WHERE gm.prepay = 3
		END

		SELECT * FROM #chargeCodes WHERE CHARGE_CODE <> '' AND CHARGE_AMOUNT <> -1
		DROP TABLE #chargeCodes
		
		
		/********** PAYMENTS **********/
		SELECT	gdt.orderref AS ORDER_REF,  
				tl.transactiondate AS PAYMENT_DATE,  
				tl.passref AS PAYMENT_RECEIPT_REF,  
				CAST(tl.chargeAmount AS MONEY) / 100 AS PAYMENT_AMOUNT,  
				'1007' AS PAYMENT_SOURCE,    
				'3200004' AS PAYMENT_TYPE  
		FROM gmOrdersDispatched_Temp gdt WITH(NOLOCK) 
		INNER JOIN b4ncctransactionlog tl WITH(NOLOCK) 
			ON tl.B4NOrderRef = gdt.orderref  
		WHERE (tl.transactiontype in ('FULL','SETTLE'))
		AND tl.resultcode = 0    
		AND tl.transactionitemtype = 0 
		AND gdt.prepay = 3 
		ORDER BY gdt.orderref 	
		
	END
END








GRANT EXECUTE ON h3giPrepayUpgradeRegistration TO b4nuser
GO
