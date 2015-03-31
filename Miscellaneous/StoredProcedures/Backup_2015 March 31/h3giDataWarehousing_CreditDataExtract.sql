

-- ===================================================================================
-- Author:		Stephen Quin
-- Create date: 17/02/2010
-- Description:	The credit data extract report in data warehousing form
-- Changes:		11/07/2011	-	Stephen Quin	-	accessory orders are now excluded
--				23/01/2012 - Simon Markey - Promotions and Linked order Id included
--
--				28/08/2012 - Simon Markey - Fixed linked order id display
--				28/08/2012 - Simon Markey - Fixed Delivery Address 1 display
--				29/08/2012 - Simon Markey - Changed all b4nclasscodes joins to left outer
--											as this was causing orders to be left out
--				05/09/2012 - Simon Markey - Added Or statements to include accessory items
--											and removed where statement excluding them
--				exec h3giDataWarehousing_CreditDataExtract '28/03/2013'
-- ===================================================================================
CREATE PROCEDURE [dbo].[h3giDataWarehousing_CreditDataExtract]
	@endDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @endDateMorning DATETIME
	SET @endDateMorning = DATEADD(dd, DATEDIFF(dd, 0, @endDate), 0)
	
	DECLARE @startDate DATETIME
	SET @startDate = DATEADD(dd,-7,@endDateMorning)
	
	CREATE TABLE #promTable
	(
		temp_orderRef INT PRIMARY KEY,
		promDesc NVARCHAR(260)
	)

	INSERT INTO #promTable

		SELECT Main.orderRef, LEFT(Main.Promos, LEN(Main.Promos)-1) AS "Promotions"
		FROM(SELECT DISTINCT po2.orderRef, 
		(SELECT CAST(prom.shortDescription AS NVARCHAR(255))+ ',' AS [text()]
		FROM h3gi..h3giPromotionOrder po
		INNER JOIN h3gi..h3giPromotion prom ON po.promotionId = prom.promotionID
		WHERE po.orderRef = po2.orderRef
		ORDER BY po.orderRef
		FOR XML PATH ('')) [Promos]
		FROM h3gi..h3giPromotionOrder po2) [Main]

	--temporary table to h3gild proof data
    CREATE TABLE #proofTable
	(
		temp_orderRef INT PRIMARY KEY,
		proofOfId VARCHAR(50) NULL,
		idNumber VARCHAR(50) NULL,
		countryName VARCHAR(50) NULL,
		proofOfAddress VARCHAR(50) NULL
	)
	
	INSERT INTO #proofTable
	SELECT DISTINCT b4n.orderRef,
	 		 NULL,
		     NULL,
	 	     NULL,
	 	     NULL
	FROM h3gi..b4nOrderHeader b4n
	WHERE b4n.orderdate BETWEEN @startDate AND @endDateMorning
	
	UPDATE #proofTable
	SET proofOfAddress = proofType.proof
	FROM h3giCustomerProof customer WITH(NOLOCK)
		INNER JOIN h3giProofType proofType WITH(NOLOCK)
			ON customer.proofTypeId = proofType.proofTypeId
			AND proofType.type = customer.type
		INNER JOIN #proofTable proof WITH(NOLOCK)
			ON customer.orderRef = proof.temp_orderRef
	WHERE customer.type = 'Address'

	UPDATE #proofTable
	SET proofOfId = proofType.proof,
		idNumber = customer.idNumber,
		countryName = customer.countryName
	FROM h3giCustomerProof customer WITH(NOLOCK)
		INNER JOIN h3giProofType proofType WITH(NOLOCK)
			ON customer.proofTypeId = proofType.proofTypeId
			AND proofType.type = customer.type
		INNER JOIN #proofTable proof WITH(NOLOCK)
			ON customer.orderRef = proof.temp_orderRef
	WHERE customer.type = 'Identity'
	
	SELECT	h3gi.orderRef AS 'Order Ref',
			h3gi.retailerCode AS 'Retailer Code',
			ISNULL(retailer.distributorCode,'') AS 'Distributor Code',
			dbo.fn_getClassDescriptionByCode('StatusCode',b4n.status) AS 'Order Status',
			CASE h3gi.channelCode
	 			when 'UK000000292' then ISNULL(salesAssociateNames.employeeFirstName + ' ' + salesASsociateNames.employeeSurname,'')
	 			when 'UK000000293' then h3gi.currentMobileSalesASsociatedName
				else ''
			end AS 'Employee Name',
			ISNULL(users.userName,'') AS 'Agent ID',
			ISNULL(creditAnalyst.userName,'') AS 'Credit Analyst ID',
			CASE 
				WHEN h3gi.affinityGroupID = 1 THEN 'Consumer' 
				ELSE 'Affinity' 
			END AS 'Customer Type',
			CASE 
				WHEN h3gi.affinityGroupID = 1 THEN '' 
				ELSE aff.groupName END AS 'Affinity Group',
			h3gi.customerInAffinityGroupID AS 'Affinity Group ID',
			h3gi.mediaTracker AS 'Media Tracker',
			CASE WHEN h3gi.channelCode IN ('UK000000290','UK000000291','UK000000294') 
				THEN ISNULL(ccMedium.b4nClassDesc,'') 
				ELSE ISNULL(ccMediumRetailer.b4nClassDesc, '') 
			END AS 'Marketing Source',
			h3gi.referAFriendCode AS 'Refer A Friend Code',  
			h3gi.referAFriendMSISDN AS 'Refer A Friend MSISDN',
			h3gi.ICCID AS 'ICCID',
			CONVERT(VARCHAR(10),b4n.orderDate,103) AS 'Order Date',  
			CONVERT(VARCHAR(8),b4n.orderDate,8) AS 'Order Time',
			CASE WHEN deposit.depositId IS NULL 
				THEN 'No' 
				ELSE 'Yes' 
			END AS 'Deposit Requested',  
			ISNULL(STR(deposit.depositAmount),'') AS 'Deposit Amount',
			ISNULL(deposit.paymentMethod,'') AS 'Deposit Payment Method',  
			ISNULL(dbo.getDepositReference(deposit.depositId),'') AS 'Deposit Reference',
			(	SELECT TOP 1 cc2.b4nClassDesc
				FROM b4nOrderHistory b4nh2 WITH(NOLOCK)
					INNER JOIN b4nClassCodes cc2 WITH(NOLOCK) 
					ON cc2.b4nClassSysId = 'StatusCode' 
					AND CONVERT(VARCHAR(50), b4nh2.orderStatus) = cc2.b4nClassCode
				WHERE b4nh2.orderRef = b4n.orderRef
				AND b4nh2.orderStatus IN (306,302,304, 305,402,311)
				ORDER BY b4nh2.statusDate ASC
			) AS 'First Decision',
		    (	SELECT TOP 1 CONVERT(CHAR(8), b4nh2.statusDate, 8)
				FROM b4nOrderHistory b4nh2 WITH(NOLOCK)
					INNER JOIN b4nClassCodes cc2 WITH(NOLOCK) 
					ON cc2.b4nClassSysId = 'StatusCode' 
					AND CONVERT(VARCHAR(50), b4nh2.orderStatus) = cc2.b4nClassCode
				WHERE b4nh2.orderRef = b4n.orderRef
				AND b4nh2.orderStatus IN (306,302,304, 305,402,311)
				ORDER BY b4nh2.statusDate ASC
			) AS 'First Decision Time',
			(	SELECT TOP 1 CONVERT(CHAR(8), b4nh2.statusDate, 3)
				FROM b4nOrderHistory b4nh2 WITH(NOLOCK)
					INNER JOIN b4nClassCodes cc2 WITH(NOLOCK) 
					ON cc2.b4nClassSysId = 'StatusCode' 
					AND CONVERT(VARCHAR(50), b4nh2.orderStatus) = cc2.b4nClassCode
				WHERE b4nh2.orderRef = b4n.orderRef
				AND b4nh2.orderStatus IN (306,302,304, 305,402,311)
				ORDER BY b4nh2.statusDate ASC
			) AS 'First Decision Date',
			(	SELECT TOP 1 CONVERT(CHAR(8), b4nh2.statusDate, 3)
				FROM b4nOrderHistory b4nh2 WITH(NOLOCK)
					INNER JOIN b4nClassCodes cc2 WITH(NOLOCK) 
					ON cc2.b4nClassSysId = 'StatusCode' 
					AND CONVERT(VARCHAR(50), b4nh2.orderStatus) = cc2.b4nClassCode
				WHERE b4nh2.orderRef = b4n.orderRef
				AND b4nh2.orderStatus IN (311,306,304,304, 305,303)
				ORDER BY b4nh2.statusDate DESC
			) AS 'Final Decision Date',
			(	SELECT TOP 1 
				CASE cc2.b4nClassDesc 
					WHEN 'Retailer Approved' THEN 'Credit Approved' 
					ELSE cc2.b4nClassDesc 
				END
				FROM b4nOrderHistory b4nh2 WITH(NOLOCK)
					INNER JOIN b4nClassCodes cc2 WITH(NOLOCK) 
					ON cc2.b4nClassSysId = 'StatusCode' 
					AND CONVERT(VARCHAR(50), b4nh2.orderStatus) = cc2.b4nClassCode
				WHERE b4nh2.orderRef = b4n.orderRef
				AND b4nh2.orderStatus IN (311,306,304,305,303)
				ORDER BY b4nh2.statusDate DESC
			) AS 'Final Decision',
			ccTitle.b4nClassDesc AS 'Title',
			b4n.billingForename AS 'Forename',
			h3gi.initials AS 'Initials',
			b4n.billingSurname AS 'Surname',
			RIGHT('00' + CAST(h3gi.dobDD AS VARCHAR(2)), 2) + '/' + RIGHT('00' + CAST(h3gi.dobMM AS VARCHAR(2)), 2) + '/' + CAST(h3gi.dobYYYY AS VARCHAR(4)) AS 'Date of Birth',
			ccGender.b4nClassDesc AS 'Gender', 
			ccMarriage.b4nClassDesc AS 'Marital Status', 
			ccProperty.b4nClassDesc AS 'Residential Status',
			h3gi.billingHouseNumber AS 'Apt/House Num', 
			h3gi.billingHouseName AS 'Apt/House Name', 
			b4n.billingAddr2 AS 'Street Name', 
			b4n.billingAddr3 AS 'Locality', 
			b4n.billingCity AS 'Town/City', 
			b4n.billingCounty 'County',
			RIGHT('00' + CAST(h3gi.timeAtCurrentAddressYY AS VARCHAR(2)), 2) AS 'Billing Address Years',
			RIGHT('00' + CAST(h3gi.timeAtCurrentAddressMM AS VARCHAR(2)), 2) AS 'Billing Address Months',
			h3gi.prev1HouseName AS 'Prev Address 1 Apt/House Num', 
			h3gi.prev1HouseNumber AS 'Prev Address 1 Apt/House Name', 
			h3gi.prev1Street AS 'Prev Address 1 Street Name', 
			h3gi.prev1Locality AS 'Prev Address 1 Locality', 
			h3gi.prev1Town AS 'Prev Address 1 Town/City', 
			h3gi.prev1County AS 'Prev Address 1 County',
			RIGHT('00' + CAST(h3gi.timeAtPrev1AddressYY AS VARCHAR(2)), 2) AS 'Prev Address 1 Years',
			RIGHT('00' + CAST(h3gi.timeAtPrev1AddressMM AS VARCHAR(2)), 2) AS 'Prev Address 1 Months',
			h3gi.prev2HouseName AS 'Prev Address 2 Apt/House Num', 
			h3gi.prev2HouseNumber AS 'Prev Address 2 Apt/House Name', 
			h3gi.prev2Street AS 'Prev Address 2 Street Name', 
			h3gi.prev2Locality AS 'Prev Address 2 Locality', 
			h3gi.prev2Town AS 'Prev Address 2 Town/City', 
			h3gi.prev2County AS 'Prev Address 2 County',
			RIGHT('00' + CAST(h3gi.timeAtPrev2AddressYY AS VARCHAR(2)), 2) AS 'Prev Address 2 Years',
			RIGHT('00' + CAST(h3gi.timeAtPrev2AddressMM AS VARCHAR(2)), 2) AS 'Prev Address 2 Months',
			SUBSTRING(b4n.deliveryaddr1, 0, CHARINDEX('<!!-!!>', b4n.deliveryaddr1)) AS 'Delivery Address Apt/House Num',
			LTRIM(REPLACE(b4n.deliveryaddr1,'<!!-!!>',' ')) AS 'Delivery Address Apt/House Name',
			b4n.deliveryaddr2 AS 'Delivery Address Street Name', 
			b4n.deliveryaddr3 AS 'Delivery Address Locality', 
			b4n.deliverycity AS 'Delivery Address Town/City', 
			b4n.deliverycounty AS 'Delivery Address County',
			h3gi.homePhoneAreaCode + h3gi.homePhoneNumber AS 'Home Phone Num',
			h3gi.daytimeContactAreaCode + h3gi.daytimeContactNumber AS 'Daytime Phone Num',
			b4n.email AS 'Email',
			ISNULL(proofs.proofOfId,'') AS 'Proof of ID',
			ISNULL(proofs.idNumber,'') AS 'ID Number',
			ISNULL(proofs.countryName,'') AS 'ID Country of Issue',
			ISNULL(proofs.proofOfAddress,'') AS 'Proof of Address',
			h3gi.channelcode AS 'Sales Channel', 
			h3gi.retailerCode AS 'Dealer Code', 
			ccPay.b4nClassDesc AS 'Payment Method',
			ISNULL(tariff.productName,'') AS 'Price Plan',
			handset.productName AS 'Model',
			dbo.fn_getOrderAddonNameList(h3gi.orderRef) AS 'Add Ons',
			h3gi.bic AS 'BIC',
			h3gi.iban AS 'IBAN',
			h3gi.sortCode AS 'Sort Code', 
			h3gi.accountNumber AS 'Account Num',
			RIGHT('00' + CAST(h3gi.timeWithBankYY AS VARCHAR(2)), 2) AS 'Years at Bank',
			RIGHT('00' + CAST(h3gi.timeWithBankMM AS VARCHAR(2)), 2) AS 'Months at Bank',
			ccCard.b4nClassDesc AS 'Card Type',
			CASE b4n.ccTypeId 
				WHEN '-1' THEN NULL 
				ELSE RIGHT('00' + CAST(DATEPART(mm, ccExpiryDate) AS VARCHAR(2)), 2) + '/' + CAST(DATEPART(yy, ccexpirydate) AS VARCHAR(4)) 
			END AS 'Expiry Date',
			ccEmpStatus.b4nClassDesc AS 'Employment Status', 
			h3gi.occupationTitle as 'EmploymentTitle',
			ISNULL(ccEmpType.b4nClassDesc, '') AS 'Employment Type',
			RIGHT('00' + CAST(h3gi.timeWithEmployerYY AS VARCHAR(2)), 2) AS 'Years in Employment',
			RIGHT('00' + CAST(h3gi.timeWithEmployerMM AS VARCHAR(2)), 2) AS 'Months in Employment',
			h3gi.workPhoneAreaCode + h3gi.workPhoneNumber AS 'Work Phone Num',
			ISNULL(emd.intentionToPort, 'N') AS 'Intention to Port', 
			CASE 
				WHEN emd.intentionToPort = 'Y' THEN ISNULL(ccMobile.b4nClassDesc, '') 
				ELSE '' 
			END AS 'Existing Provider',
			CASE 
				WHEN emd.intentionToPort = 'Y' THEN (CAST(h3gi.currentmobilearea AS VARCHAR(3)) + '-' + CAST(h3gi.currentmobilenumber AS VARCHAR(7))) 
				ELSE '' 
			END AS 'Existing Num',
			h3gi.score AS 'Credit Score', 
			h3gi.experianRef AS 'Experian Ref', 
			h3gi.shadowCreditLimit AS 'Shadow Limit', 
			h3gi.creditLimit AS 'Credit Limit',
			dbo.getOrderNotes(h3gi.orderRef) AS 'Notes',
			CASE h3gi.decisionCode WHEN 'A' THEN ISNULL(appDec.b4nClassDesc,'') WHEN 'D' THEN ISNULL(declineDec.b4nClassDesc,'') WHEN 'DT' THEN ISNULL(depositDec.b4nClassDesc,'') WHEN 'P' THEN '' ELSE '' END AS 'Decision Reason',
			CASE lo.linkedOrderRef WHEN NULL THEN '' ELSE STUFF('L000000',(8-Len(lo.linkedOrderRef)), Len(lo.linkedOrderRef),lo.linkedOrderRef) END AS 'LinkedId',
			ISNULL(proms.promDesc,'') AS 'Promotion Name',
			CASE 
				WHEN cust.existingCustomer = 1 THEN 'Y'
				ELSE 'N' 
			END AS 'Existing Customer',
			cust.existingAccountNumber AS 'Existing Three Num',
			ISNULL(ccCallType.b4nClassDesc,'') AS 'Telesales Call Type',
			h3gi.telesalesCampaignType AS 'Telesales Campaign Type',
			CASE WHEN h3gi.IsClickAndCollect = 1 THEN 'Yes' ELSE 'No' END AS 'Click And Collect',
			CASE WHEN h3gi.IsClickAndCollect = 1 THEN h3gi.ClickAndCollectDealerCode ELSE '' END AS 'Click And Collect Channel'
	FROM	h3giOrderHeader h3gi WITH(NOLOCK)
		INNER JOIN b4nOrderHeader b4n WITH(NOLOCK)
			ON h3gi.orderRef = b4n.orderRef
		INNER JOIN h3giProductCatalogue handset WITH(NOLOCK)
			ON h3gi.phoneProductCode = handset.productFamilyId
			AND h3gi.catalogueVersionId = handset.catalogueVersionId
			AND handset.productType IN ('HANDSET','ACCESSORY')		
		INNER JOIN h3giRetailer retailer
			ON h3gi.retailerCode = retailer.retailerCode
		INNER JOIN h3gi..h3giOrderCustomer cust WITH(NOLOCK)
			ON h3gi.orderref = cust.orderRef
		LEFT JOIN h3giProductCatalogue tariff WITH(NOLOCK)
			ON h3gi.tariffProductCode =  tariff.peopleSoftId
			AND h3gi.catalogueVersionId = tariff.catalogueVersionId
			AND tariff.productType = 'TARIFF'			
		LEFT OUTER JOIN b4nClassCodes ccTitle WITH(NOLOCK) 
			ON h3gi.title = ccTitle.b4nClassCode
			AND ccTitle.b4nClassSysId = 'CustomerTitle' 
		LEFT OUTER JOIN b4nClassCodes ccGender WITH(NOLOCK) 
			ON h3gi.gender = ccGender.b4nClassCode
			AND ccGender.b4nClassSysId = 'CustomerGender' 
		LEFT OUTER JOIN b4nClassCodes ccMarriage WITH(NOLOCK) 
			ON h3gi.maritalstatus = ccMarriage.b4nClassCode
			AND ccMarriage.b4nClassSysId = 'CustomerMaritalStatus' 
		LEFT OUTER JOIN b4nClassCodes ccProperty WITH(NOLOCK) 
			ON ccProperty.b4nClassSysId = 'CustomerPropertyStatus' 
			AND ccProperty.b4nClassCode = h3gi.propertystatus
		LEFT OUTER JOIN b4nClassCodes ccPay WITH(NOLOCK) 
			ON ccPay.b4nClassSysId = 'METHODOFPAYMENTTYPECODE' 
			AND ccPay.b4nClassCode = h3gi.paymentmethod
		LEFT OUTER JOIN b4nClassCodes ccEmpStatus WITH(NOLOCK) 
			ON ccEmpStatus.b4nClassSysId = 'CustomerOccupationStatus'
			AND ccEmpStatus.b4nClassCode = h3gi.occupationstatus
		LEFT OUTER JOIN #proofTable proofs
			ON h3gi.orderRef = proofs.temp_orderRef
		LEFT OUTER JOIN b4nClassCodes ccCard WITH(NOLOCK) 
			ON ccCard.b4nClassSysId = 'CreditCard' 
			AND ccCard.b4nClassCode = b4n.ccTypeId
		LEFT OUTER JOIN b4nClassCodes ccEmpType WITH(NOLOCK) 
			ON ccEmpType.b4nClassSysId = 'CustomerOccupationType' 
			AND ccEmpType.b4nClassCode = h3gi.occupationtype
		LEFT OUTER JOIN b4nClassCodes ccMobile WITH(NOLOCK) 
			ON ccMobile.b4nClassSysId = 'ExistingMobileSupplier' 
			AND ccMobile.b4nClassCode = h3gi.currentmobilenetwork
		LEFT OUTER JOIN b4nClassCodes ccMedium WITH(NOLOCK)
			ON ccMedium.b4nClassSysId = 'COMMS_MEDIUM' 
			AND ccMedium.b4nClassCode =  h3gi.sourceTrackingCode 
		LEFT OUTER JOIN b4nClassCodes ccMediumRetailer WITH(NOLOCK) 
			ON ccMediumRetailer.b4nClassSysId = 'COMMS_MEDIUM_RETAILER' 
			AND ccMediumRetailer.b4nClassCode = h3gi.sourceTrackingCode
		LEFT OUTER JOIN h3giOrderExistingMobileDetails emd WITH(NOLOCK)
			ON h3gi.orderRef = emd.orderRef
		LEFT OUTER JOIN smApplicationUsers users WITH(NOLOCK) 
			ON h3gi.telesalesID = users.userid
		LEFT OUTER JOIN smApplicationUsers creditAnalyst WITH(NOLOCK) 
			ON h3gi.creditAnalystID = creditAnalyst.userid
		LEFT OUTER JOIN h3giAffinityGroup aff WITH(NOLOCK)
			ON h3gi.affinityGroupID = aff.groupID
		LEFT OUTER JOIN h3giMobileSalesAssociatedNames salesAssociateNames WITH(NOLOCK)
			ON h3gi.mobileSalesAssociatesNameId = salesAssociateNames.mobileSalesAssociatesNameId
		LEFT OUTER JOIN h3giOrderDeposit deposit WITH(NOLOCK) 
			ON h3gi.orderRef = deposit.orderRef
		LEFT OUTER JOIN h3gi..b4nClassCodes appDec 
			ON h3gi.decisionTextCode = appDec.b4nClassCode 
			AND appDec.b4nClassSysID = 'ApprovalDecisionTextCode'
		LEFT OUTER JOIN h3gi..b4nClassCodes declineDec 
			ON h3gi.decisionTextCode = declineDec.b4nClassCode 
			AND declineDec.b4nClassSysID = 'DeclinedDecisionTextCode'
		LEFT OUTER JOIN h3gi..b4nClassCodes depositDec 
			ON h3gi.decisionTextCode = depositDec.b4nClassCode 
			AND depositDec.b4nClassSysID = 'DepositDecisionTextCode'
		LEFT OUTER JOIN h3gi..b4nClassCodes ccCallType 
			ON ccCallType.b4nClassSysID = 'TelesalesCallType' 
			AND ccCallType.b4nClassCode = h3gi.telesalesCallType
		LEFT OUTER JOIN h3gi.dbo.h3giLinkedOrders lo WITH(NOLOCK) 
			ON h3gi.orderref = lo.orderRef	
		LEFT OUTER JOIN #promTable proms 
			ON h3gi.orderref = proms.temp_orderRef
	 WHERE b4n.orderDate BETWEEN @startDate AND @endDateMorning
	 AND ISNULL(h3gi.creditAnalystid, '') <> ''
	 AND h3gi.upgradeId = 0
	 AND h3gi.isTestOrder = 0
	 ORDER BY h3gi.orderRef
	 
	 DROP TABLE #proofTable
END



GRANT EXECUTE ON h3giDataWarehousing_CreditDataExtract TO b4nuser
GO
