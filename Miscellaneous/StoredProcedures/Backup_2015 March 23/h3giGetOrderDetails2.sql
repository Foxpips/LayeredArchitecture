
/*********************************************************************************************************************																				
* Procedure Name	: h3giGetOrderDetails
* Author		: Niall Carroll
* Date Created		: 13/04/2005
* Version		: 1.0.10
*					
**********************************************************************************************************************
* Description		: Get the details of an Order
**********************************************************************************************************************
* Returns			: 4 seperate recordsets (a dataset containing 4 tables)
*						-- Personal Details
*						-- Order Information
*						-- Credit Information
*						-- Order Notes
**********************************************************************************************************************
* Change Control	: 19/04/2005 - Gearóid Healy - Modified to include all fields
*			  25/04/2005 - Padraig Gorry - Added notes dataset
*			  04/05/2005 - Gearóid Healy - Added fields for media tracking, discountPriceChargeType and goodsPriceChargeType
*			  08/05/2004 - Pádraig Gorry - Returned callback details
*			  10/05/2005 - Pádraig Gorry - Added joing to views to get tariff and phone names
*			  11/05/2005 - Pádraig Gorry - Added getting of charge attempts
*			  12/05/2005 - Gearóid Healy - sourceTrackingCode
*			  12/05/2005 - Gearóid Healy - modified to return current county and delivery county as codes, not strings|
*			  28/06/2005 - Gearóid Healy - modified to include current mobile package type and store code
*			  02/07/2005 - Gearóid Healy - modified to include imei, iccid and proxy
*			  14/07/2005 - Gearóid Healy - modified to bring back phones / tariffs from legacy catalogues
*			  07/11/2005 - Niall Carroll - modified to include MSISDN (pulled from h3giICCID table)
*			  08/03/2006 - John Hannon   - modified to include currentMobileAccountNumber,currentMobileAltDatePort,currentMobileCAFCompleted,currentMobileSalesAssociatedName
*			  10/07/2006 - Attila Pall - modified to include ReturnPhone, ExtraSIM
*			  11/07/2006 - Niall Carroll - modified to include BAN (Billing Account Number - for upgrades)
*			  21/08/2006 - Attila Pall - Returns MSISDN of upgrade customers based on their mobile phonenumber in h3giUpgrades table
*			24/08/2006 - Alex Coll removed references to the returnphone bit
**********************************************************************************************************************/

CREATE               PROCEDURE [dbo].[h3giGetOrderDetails2] 
-- Filter
	@OrderRef 	varchar(20),
	@ShowSensitiveNotes as bit

AS
	
DECLARE @ShowPerInfo bit
	DECLARE @ShowOrdInfo bit
	DECLARE @ShowCreInfo bit
	DECLARE @ShowNotes bit
	DECLARE @MSISDN varchar(50)
	DECLARE @UpgradePhoneNumber varchar(20)
	
	SET @ShowPerInfo = 1
	SET @ShowOrdInfo = 1
	SET @ShowCreInfo = 1
	SET @ShowNotes = 1
	
	SELECT @MSISDN = MSISDN FROM h3giICCID WITH(NOLOCK) WHERE ICCID in (SELECT ICCID FROM h3giOrderHeader WITH(NOLOCK) WHERE OrderRef = @OrderRef)

	SELECT
		-- Personal Details
		h3g.title,
		B4N.BillingForeName as forename,
		h3g.initials,
		B4N.BillingSurName as surname,
		H3G.gender,
		H3G.dobDD,
		H3G.dobMM,
		H3G.dobYYYY,
		H3G.maritalStatus,
		B4N.Email,
		h3g.homePhoneAreaCode,
		h3g.homePhoneNumber,
		h3g.daytimeContactAreaCode,
		h3g.daytimeContactNumber,
		h3g.mediaTracker,
		h3g.sourceTrackingCode,
	
		-- Address Details
		h3g.billingHouseNumber	as currentHouseNumber,
		h3g.billingHouseName	as currentHouseName,
		B4N.billingAddr2 		as currentStreet,
		B4N.billingAddr3 		as currrentLocality,
		B4N.billingCity 		as currentCity,
		B4N.billingSubCountryID	as currentCounty,
		B4n.billingCountry 		as currentCountry,
		H3G.propertyStatus,
		timeAtCurrentAddressMM,
		timeAtCurrentAddressYY,
	
		prev1HouseNumber,
		prev1HouseName,
		prev1Street,
		prev1Locality,
		prev1Town,
		prev1County,
		prev1Country,
		timeAtPrev1AddressMM,
		timeAtPrev1AddressYY,
	
		prev2HouseNumber,
		prev2HouseName,
		prev2Street,
		prev2Locality,
		prev2Town,
		prev2County,
		prev2Country,
		timeAtPrev2AddressMM,
		timeAtPrev2AddressYY,

		deliveryAddr1		 as deliveryLine1,
		deliveryAddr2		 as deliveryStreet,		deliveryAddr3		 as deliveryLocality,
		deliveryCity,
		deliverySubCountryID as deliveryCounty,
		deliveryCountry,
		deliveryNote		 as deliveryInstructions,
	
		-- Occupation Details
		H3G.occupationType,
		H3G.occupationStatus,
		H3G.timeWithEmployerMM,
		H3G.timeWithEmployerYY,
		H3G.workPhoneAreaCode,
		H3G.workPhoneNumber,
	
		-- Mobile Details
		H3G.intentionToPort,
		H3G.currentMobileNetwork,
		H3G.currentMobileArea,
		H3G.currentMobileNumber,
		H3G.currentMobilePackage,
		H3G.currentMobileAccountNumber,
		H3G.currentMobileAltDatePort,
		H3G.currentMobileCAFCompleted,
		H3G.currentMobileSalesAssociatedName,
	
		-- Payment Details
		H3G.accountName,
		H3G.sortCode,
		H3G.accountNumber,
		H3G.timewithBankMM,
		H3G.timewithBankYY,
		b4n.ccTypeID as cardType,
		b4n.ccNumber as cardNumber,
		b4n.ccExpiryDate as expiryDate,
		h3g.ChargeAttempts,
	
		-- Order Information
		B4N.orderRef,
		B4N.orderDate,
		B4N.Status as OrderStatus,
		H3G.channelCode,
		H3G.retailerCode,
		H3G.storeCode,
		H3G.proxy,
		H3G.billingTariffID,
		H3G.paymentMethod,
		H3G.internationalRoaming,
		decisionCode,
		decisionTextCode,
		score,
		creditLimit,
		shadowCreditLimit,
		phoneProductCode,
		vp.productName as phoneName,
		tariffProductCode,
		vt.pricePlanPackageName as tariffName,
		tariffRecurringPrice,
		h3g.pricePlanPackageID, 
		h3g.catalogueVersionID, 
		termsAccepted,
		creditAnalystID,
		telesalesID,
		h3g.discountPriceChargeCode,
		h3g.basePriceChargeCode,
		h3g.CallbackDate,
		h3g.CallbackAttempts,
		h3g.ExperianRef,
		B4N.GoodsPrice,
		h3g.IMEI,
		h3g.ICCID,
		cc.passRef,
		cc.transactionDate,
		CASE WHEN (@MSISDN IS NULL OR @MSISDN = '') THEN dbo.fn_getUpgradeMSISDN(h3g.upgradeID) ELSE @MSISDN END as MSISDN,
		h3g.ExtraSIM,
		(Select BillingAccountNumber from dbo.h3giUpgrade where upgradeID = h3g.upgradeID) BAN
	
	INTO
		#OrderDetails				
	FROM
		b4nOrderHeader B4N 
		inner join h3giOrderHeader H3G on B4N.OrderRef = H3G.OrderRef
		join viewOrderPhone vp on vp.phoneProductID = phoneProductCode and vp.orderref = @OrderRef
		join viewOrderTariff vt on vt.productbillingid = H3G.billingTariffID and vt.orderref = @OrderRef
		left outer join b4nccTransactionLog cc on cc.b4nOrderRef = b4n.OrderRef and cc.ResultCode = 0 and TransactionType in ('FULL', 'SETTLE')
	WHERE
		B4N.OrderRef = Cast(@OrderRef as int)

	
	update #OrderDetails
	set intentionToPort = 'N'
where intentionToPort != 'Y'

	-- Personal Details
	IF @ShowPerInfo = 1
	BEGIN
		SELECT 
			title,
			forename,
			initials,
			surname,
			gender,
			dobDD,
			dobMM,
			dobYYYY,
			maritalStatus,
			Email,
			homePhoneAreaCode,
			homePhoneNumber,
			daytimeContactAreaCode,
			daytimeContactNumber,
			mediaTracker,
			sourceTrackingCode,
			currentHouseNumber,
			currentHouseName,
			currentStreet,
			currrentLocality,
			currentCity,
			currentCounty,
			currentCountry,
			propertyStatus,
			timeAtCurrentAddressMM,
			timeAtCurrentAddressYY,
			prev1HouseNumber,
			prev1HouseName,
			prev1Street,
			prev1Locality,
			prev1Town,
			prev1County,
			prev1Country,
			timeAtPrev1AddressMM,
			timeAtPrev1AddressYY,
			prev2HouseNumber,
			prev2HouseName,
			prev2Street,
			prev2Locality,
			prev2Town,
			prev2County,
			prev2Country,
			timeAtPrev2AddressMM,
			timeAtPrev2AddressYY,
			deliveryLine1,
			deliveryStreet,
			deliveryLocality,
			deliveryCity,
			deliveryCounty,
			deliveryCountry,
			deliveryInstructions
		FROM
			#OrderDetails
	END
	
	-- Order information
	IF @ShowOrdInfo = 1
	BEGIN
		SELECT
			orderRef,
			orderDate,
			OrderStatus,
			channelCode,
			retailerCode,
			storeCode,
			proxy,
			billingTariffID,
			paymentMethod,
			internationalRoaming,
			decisionCode,
			decisionTextCode,
			score,
			creditLimit,
			shadowCreditLimit,
			phoneProductCode,
			phoneName,
			tariffProductCode,
			tariffName,
			tariffRecurringPrice,
			pricePlanPackageID, 
			catalogueVersionID, 
			termsAccepted,
			creditAnalystID,
			telesalesID,
			discountPriceChargeCode,
			basePriceChargeCode,
			CallbackDate,
			CallbackAttempts,
			ExperianRef,
			GoodsPrice,
			IMEI,
			ICCID,
			passRef,
			transactionDate,
			MSISDN,
			ExtraSIM,
			BAN

		FROM
			#OrderDetails
	END
	
	-- Credit Information
	IF @ShowCreInfo = 1
	BEGIN 
		SELECT
			accountName,
			sortCode,
			accountNumber,
			timewithBankMM,
			timewithBankYY,
			cardType,
			cardNumber,
			expiryDate,
			ChargeAttempts,
			intentionToPort,
			currentMobileNetwork,
			currentMobileArea,
			currentMobileNumber,
			currentMobilePackage,
			currentMobileAccountNumber,
			currentMobileAltDatePort,
			currentMobileCAFCompleted,
			currentMobileSalesAssociatedName,
			occupationType,
			occupationStatus,
			timeWithEmployerMM,
			timeWithEmployerYY,
			workPhoneAreaCode,
			workPhoneNumber
		FROM
			#OrderDetails
	END

	-- Credit Information
	IF @ShowNotes = 1
	BEGIN 
		SELECT
			n.noteTime,
			u.userName,
			n.noteText
		FROM
			h3giNotes n
		JOIN
			smApplicationUsers u on u.userID = n.userID
		WHERE 
			orderref = @OrdeRref
			and n.sensitive <= @ShowSensitiveNotes
		ORDER BY 
			n.noteTime ASC
	END

	DROP TABLE #OrderDetails



GRANT EXECUTE ON h3giGetOrderDetails2 TO b4nuser
GO
GRANT EXECUTE ON h3giGetOrderDetails2 TO ofsuser
GO
GRANT EXECUTE ON h3giGetOrderDetails2 TO reportuser
GO
