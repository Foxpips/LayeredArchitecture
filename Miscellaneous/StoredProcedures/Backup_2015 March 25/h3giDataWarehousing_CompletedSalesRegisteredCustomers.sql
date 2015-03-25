




-- ===============================================================================
-- Author:		Stephen Quin
-- Create date: 15/02/2010
--
-- Test:		exec h3giDataWarehousing_CompletedSalesRegisteredCustomers '14/08/2013'
--
-- Description:	Combines the Completed Sales - Registered Customers and the 
--				Completed Sales - Registered Customers (Business) into 1 stored 
--				procedure
-- Changes:		25/03/2011 - Stephen Quin - Changed the way coverage address data 
--											is retrieved to bring it in line with 
--											the changes made for Bizmaps
--				18/04/2011 - Stephen Quin - now returns missing address field "address7"
--				27/05/2011 - Stephen Quin - topup amounts now returned
--				11/07/2011 - Stephen Quin - accessory orders are now excluded
--				26/09/2011 - Simon Markey - returns Call Type/Service Provider/Package
--											Type/Account Number
--				23/01/2012 - Simon Markey - Adding LinkedOrderId and promotion description
--				20/08/2012 - Simon Markey - Changing Name of user to be the sales associate drop down
--				24/08/2012 - Simon Markey - Fixing Linked Order Ref location and display
--				29/08/2012 - Simon Markey - Fixing decimal place issue by changing topup to varchar
--				29/03/2013 - Simon Markey - Adding 2 new click and collect fields
--				14/08/2013 - Simon Markey - 4 new insurance items now returned
-- ===============================================================================
CREATE PROCEDURE [dbo].[h3giDataWarehousing_CompletedSalesRegisteredCustomers]
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
	
	 --create table variable to hold data
	DECLARE @RegisteredCustomers
	TABLE(	
			[Order Ref] INT,
			[Username] VARCHAR(100),
			[Name of User] VARCHAR(100),
			[Payroll Number] VARCHAR(20),
			[B4N Ref Number] VARCHAR(20),
			[Consumer or Affinity] VARCHAR(20),
			[Affinity Group] VARCHAR(50),
			[Affinity Group Id] VARCHAR(50),
			[IMEI] VARCHAR(20),
			[MSISDN] VARCHAR(20),
			[Intention to Port] VARCHAR(1),
			[Port In Number] VARCHAR(20),
			[3Pay Migration] VARCHAR(1),
			[Current Mobile Number] VARCHAR(20),
			[Unassisted Promotion Code] VARCHAR(50),
			[Mobile Provider] VARCHAR(50),
			[Package Type] VARCHAR(50),
			[Account Number] VARCHAR(50),
			[Telesales Call Type] VARCHAR(50),
			[Telesales Campaign Type] VARCHAR(50),
			[Handset Name] VARCHAR(50),
			[Order Date] VARCHAR(10),
			[Sales Date] VARCHAR(10),
			[Price] VARCHAR(10),
			[ICCID] VARCHAR(25),
			[Tariff Name] VARCHAR(50),
			[Add Ons] VARCHAR(1000),
			[Topup] VARCHAR(1000),
			[Topup Amount] VARCHAR(10),
			[Slingbox Serial Number] VARCHAR(50),
			[Forename] VARCHAR(50),
			[Surname] VARCHAR(50),
			[Dealer Code] VARCHAR(20),
			[Distributor Code] VARCHAR(20),
			[Deposit Required] VARCHAR(3),
			[Deposit Amount] VARCHAR(10),
			[Deposit Payment Method] VARCHAR(50),
			[Deposit Reference] VARCHAR(50),
			[My 3] VARCHAR(1),  
			[EBilling] VARCHAR(1),  
			[Media Tracker] VARCHAR(50),  
			[Marketing Source] VARCHAR(500),
			[Refer A Friend Code] VARCHAR(500),  
			[Refer A Friend MSISDN] VARCHAR(200),
			[Business Parent Tariff] VARCHAR(500),
			[Business End User Tariff] VARCHAR(500),
			[Organisation Name] VARCHAR(500),
			[Customer Type] VARCHAR(500),
			[File Date] VARCHAR(100),
			[NBS]VARCHAR(10),
			[Coverage Address 1] VARCHAR(500),
			[Coverage Address 2] VARCHAR(500),
			[Coverage Address 3] VARCHAR(500),
			[Coverage Address 4] VARCHAR(500),
			[Coverage Address 5] VARCHAR(500),
			[Coverage Address 6] VARCHAR(500),
			[Coverage Address 7] VARCHAR(500),
			[Geo Directory Id] VARCHAR(500),
			[Latitude] VARCHAR(200),
			[Longitude] VARCHAR(200),
			[Coverage Level] VARCHAR(500),
			[DED Code] VARCHAR(100),
			[Coverage Type] VARCHAR(500),
			[LinkedId] VARCHAR(50),
			[Promotion Name] VARCHAR(500),
			[Click and Collect] VARCHAR(10),
			[Click and Collect Channel] VARCHAR(20)
			--[Insurance] VARCHAR(40),
			--[Insurance Type] VARCHAR(15),
			--[Insurance Payment Method] VARCHAR(10),
			--[Insurance Amount] VARCHAR(10)
		)
		
		--1st. Consumer Orders
		INSERT INTO @RegisteredCustomers
		SELECT	h3gi.orderRef,
				ISNULL(users.userName,'') AS userName,
				ISNULL(msan.employeeFirstName+' '+msan.employeeSurname,'') AS nameOfUser,
				CASE WHEN h3gi.mobileSalesAssociatesNameId IS NOT NULL 
					THEN msan.payrollNumber 
					ELSE '' 
				END AS payrollNumber,  
				CASE WHEN h3gi.mobileSalesAssociatesNameId IS NOT NULL
					THEN msan.b4nRefNumber 
					ELSE '' 
				END AS b4nRefNumber,
				CASE cust.customerType 
					WHEN 1 THEN 'Consumer' 
					WHEN 2 THEN 'Affinity' 
					WHEN 3 THEN 'Unassisted Consumer' 
					ELSE 'Consumer' 
				END AS customerType, 
				CASE WHEN h3gi.affinityGroupID = 1 
					THEN '' 
					ELSE aff.groupName 
				END AS affinityGroupName,  
				CASE WHEN h3gi.affinityGroupID = 1 
					THEN '' 
					ELSE STR(h3gi.affinityGroupID) 
				END AS affinityGroupId, 
				h3gi.IMEI,
				iccid.MSISDN,
				ISNULL(existing.intentionToPort, 'N') AS intentionToPort,
				CASE WHEN existing.intentionToPort = 'Y'
					THEN existing.currentMobileArea + existing.currentMobileNumber 
					ELSE '' 
				END AS portInNumber,
				CASE WHEN existing.currentPrepayTransfer = 1 
					THEN 'Y' 
					ELSE 'N' 
				END AS intentionToTransferExistingPrepay,
				CASE WHEN existing.currentPrepayTransfer = 1
					THEN existing.currentMobileArea + existing.currentMobileNumber
					ELSE ''
				END AS currentMobileNumber,
				h3gi.unassistedPromotionCode,
				ISNULL(mobileSup.b4nClassDesc, '') AS mobileProvider,
				ISNULL(package.b4nClassDesc, '') AS callPackageType,
				ISNULL(existing.currentMobileAccountNumber,'') AS accountNumber,		
				ISNULL(ccCallType.b4nClassDesc,'') AS telesalesCallType,
				h3gi.telesalesCampaignType AS telesalesCampaignType, 								
				handset.productName AS handset,
				CONVERT(VARCHAR(10),b4n.orderDate,103) AS orderDate,
				CONVERT(VARCHAR(10),history.statusDate,103) AS completedDate,
				CAST(b4n.goodsPrice AS varchar(12)) AS price,
				h3gi.ICCID,
				tariff.productName AS tariff,
				ISNULL(dbo.fn_getOrderAddonNameList(h3gi.orderref),'') AS addOns, 
				ISNULL(line.itemName,'') AS topup,  
				ISNULL(line.Price,'') AS topupAmount,  
				h3gi.slingBoxSerialNumber,
				CASE ISNULL(b4n.billingforename, '') 
					WHEN '' THEN reg.firstname 
					ELSE b4n.billingforename 
				END AS firstName,
				CASE ISNULL(b4n.billingsurname, '') 
					WHEN '' THEN reg.surname 
					ELSE b4n.billingsurname 
				END AS surname,
				h3gi.retailerCode,
				ISNULL(retailer.distributorCode,'') AS distributorCode,
				CASE WHEN deposit.depositId IS NULL 
					THEN 'No' 
					ELSE 'Yes' 
				END AS depositRequested,  
				ISNULL(STR(deposit.depositAmount),'') AS depositAmount,  
				ISNULL(deposit.paymentMethod,'') AS depositPaymentMethod,  
				ISNULL(dbo.getDepositReference(deposit.depositId),'') AS depositReference,
				CASE cust.registerForMy3 
					WHEN 1 THEN 'Y' 
					ELSE 'N' 
				END AS my3,  
				CASE cust.registerForEBilling 
					WHEN 1 THEN 'Y' 
					ELSE 'N' 
				END AS eBilling,
				h3gi.mediaTracker,  
				CASE WHEN h3gi.channelCode IN ('UK000000290','UK000000291','UK000000294') 
					THEN ISNULL(ccMedium.b4nClassDesc,'') 
					ELSE ISNULL(ccMediumRetailer.b4nClassDesc, '') 
				END AS marketingSource,  
				h3gi.referAFriendCode,  
				h3gi.referAFriendMSISDN,
				'' AS parentTariff,
				'' AS endUserTariff,
				'' AS organisationName,
				'Consumer' AS consOrBus,
				CONVERT(CHAR(8), GETDATE(), 3) AS fileDate,
				CASE h3gi.nbsLevel
					WHEN 2 THEN 'Y'
					WHEN 3 THEN 'Y'
					WHEN 4 THEN 'Y'
					ELSE 'N' 
				END AS nbsEligible,	
				COALESCE(nbsData.address1,'') AS coverageAddress1,
				COALESCE(nbsData.address2,'') AS coverageAddress2,
				COALESCE(nbsData.address3,'') AS coverageAddress3,
				COALESCE(nbsData.address4,'') AS coverageAddress4,
				COALESCE(nbsData.address5,'') AS coverageAddress5,
				COALESCE(nbsData.address6,'') AS coverageAddress6,
				COALESCE(nbsData.address7,'') AS coverageAddress7,
				COALESCE(nbsData.geoDirectoryId,bizmaps.geoDirectoryId,'') AS geoDirectoryId,
				COALESCE(nbsData.latitude,bizmaps.latitude,'') AS latitude,
				COALESCE(nbsData.longitude,bizmaps.longitude,'') AS longitude,
				COALESCE(nbsData.coverageLevel,bizmaps.coverageLevel,'') AS coverageLevel,
				COALESCE(nbsData.dedCode,bizmaps.dedCode,'') AS dedCode,
				COALESCE(nbsData.coverageType,bizmaps.coverageType,'') AS coverageType,
				CASE lo.linkedOrderRef WHEN NULL THEN '' ELSE STUFF('L000000',(8-Len(lo.linkedOrderRef)), Len(lo.linkedOrderRef),lo.linkedOrderRef) END AS linkedId,
				ISNULL(proms.promDesc,'') AS shortDescription,
				CASE WHEN h3gi.IsClickAndCollect = 1 THEN 'Yes' ELSE 'No' END AS ClickAndCollect,
				CASE WHEN h3gi.IsClickAndCollect = 1 THEN h3gi.ClickAndCollectDealerCode ELSE '' END AS ClickAndCollectChannel
				--ISNULL(pol.Name,'') AS insurance,
				--ISNULL(insur.paymentMethod,'') AS insuranceType,
				--CASE WHEN (ISNULL(insur.paymentType,'') = 'DirectDebit') THEN 'Pier' WHEN (ISNULL(insur.paymentType,'') = 'InStore') THEN 'Store' ELSE '' END AS insurancePayMethod,
				--CASE WHEN (insur.paymentMethod = 'Annual') THEN pol.AnnualPrice ELSE pol.MonthlyPrice END AS insuranceAmount
		FROM	h3giOrderheader h3gi WITH(NOLOCK)
			INNER JOIN  b4nOrderHeader b4n WITH(NOLOCK)
				ON h3gi.orderRef = b4n.orderRef			
			INNER JOIN b4nOrderHistory history WITH(NOLOCK)
				ON h3gi.orderRef = history.orderRef
				AND history.orderStatus IN (309,312)
			INNER JOIN h3giProductCatalogue handset WITH(NOLOCK)
				ON h3gi.phoneProductCode = handset.productFamilyId
				AND h3gi.catalogueVersionId = handset.catalogueVersionId
				AND handset.productType = 'HANDSET'
			INNER JOIN h3giProductCatalogue tariff WITH(NOLOCK)
				ON h3gi.tariffProductCode = tariff.peopleSoftId
				AND h3gi.catalogueVersionId = tariff.catalogueVersionId
				AND tariff.productType = 'TARIFF'
			INNER JOIN h3giRetailer retailer WITH(NOLOCK)
				ON h3gi.retailerCode = retailer.retailerCode
			INNER JOIN h3giIccid iccid WITH(NOLOCK)
				ON h3gi.ICCID = iccid.ICCID
			LEFT OUTER JOIN smApplicationUsers users WITH(NOLOCK)
				ON h3gi.telesalesId = users.userId
			LEFT OUTER JOIN b4nClassCodes ccMedium WITH(NOLOCK)   
				ON h3gi.sourceTrackingCode = ccMedium.b4nClassCode 
				AND ccMedium.b4nClassSysId = 'COMMS_MEDIUM' 
			LEFT OUTER JOIN b4nClassCodes ccMediumRetailer WITH(NOLOCK)  
				ON h3gi.sourceTrackingCode = ccMediumRetailer.b4nClassCode 
				AND ccMediumRetailer.b4nClassSysId = 'COMMS_MEDIUM_RETAILER'  
			LEFT OUTER JOIN h3giMobileSalesAssociatedNames msan WITH(NOLOCK)   
				ON h3gi.mobileSalesAssociatesNameId = msan.mobileSalesAssociatesNameId
			LEFT OUTER JOIN h3giAffinityGroup aff WITH(NOLOCK)
				ON h3gi.affinityGroupID = aff.groupID  
			LEFT OUTER JOIN h3giOrderCustomer cust WITH(NOLOCK)   
				ON h3gi.orderRef = cust.orderRef
			LEFT OUTER JOIN h3giOrderExistingMobileDetails existing WITH(NOLOCK)   
				ON h3gi.orderRef = existing.orderRef
			LEFT OUTER JOIN b4nClassCodes mobileSup WITH(NOLOCK)
				ON existing.currentMobileNetwork = mobileSup.b4nClassCode
				AND mobileSup.b4nClassSysID = 'ExistingMobileSupplier'
			LEFT OUTER JOIN b4nClassCodes package WITH(NOLOCK)
				ON existing.currentMobilePackage = package.b4nClassCode
				AND package.b4nClassSysID IN ('EXISTING_MOBILE_DEAL','EXISTING_MOBILE_DEAL_PREPAY')
			LEFT OUTER JOIN h3gi..b4nClassCodes ccCallType WITH(NOLOCK)  
				ON ccCallType.b4nClassSysID = 'TelesalesCallType' 
				AND ccCallType.b4nClassCode = h3gi.telesalesCallType
			LEFT OUTER JOIN h3giOrderDeposit deposit WITH(NOLOCK)
				ON h3gi.orderRef = deposit.orderRef
			LEFT OUTER JOIN h3giregistration reg WITH(NOLOCK)   
				on h3gi.orderRef = reg.orderRef
			LEFT OUTER JOIN h3giNbsCoverageAddressData nbsData WITH(NOLOCK)
				ON h3gi.orderref = nbsData.orderref
			LEFT OUTER JOIN h3giBizmapsAddressData bizmaps WITH(NOLOCK)
				ON h3gi.orderref = bizmaps.orderRef
			LEFT OUTER JOIN h3gi..b4nOrderLine line WITH(NOLOCK)
				ON h3gi.orderref = line.OrderRef
				AND (line.itemName LIKE '%Topup%' OR line.itemName LIKE '%Surf Kit%')
			LEFT OUTER JOIN h3giLinkedOrders lo WITH(NOLOCK)
				ON h3gi.orderRef = lo.orderref
			LEFT OUTER JOIN #promTable proms 
				ON h3gi.orderref = proms.temp_orderRef
			LEFT OUTER JOIN h3gi..h3giOrderInsurance insur 
				ON h3gi.orderref = insur.orderRef
			LEFT OUTER JOIN h3gi..h3giInsurancePolicy pol 
				ON insur.insuranceId = pol.Id
		WHERE history.statusDate BETWEEN @startDate AND @endDateMorning
		AND h3gi.isTestOrder = 0
		AND h3gi.orderType <> 4
				
		--2. Business Orders
		INSERT INTO @RegisteredCustomers
		SELECT	header.orderRef,
				users.userName,
				users.nameOfUser,
				CASE WHEN header.salesAssociateId IS NOT NULL 
					THEN msan.payrollNumber 
					ELSE '' 
				END AS payrollNumber,  
				CASE WHEN header.salesAssociateId IS NOT NULL
					THEN msan.b4nRefNumber 
					ELSE '' 
				END AS b4nRefNumber,
				'' AS customerType,
				'' AS affinityGroup,
				'' AS affinityGroupId,
				item.IMEI,
				iccid.MSISDN,
				CASE item.intentionToPort
					WHEN 1 THEN 'Y'
					ELSE 'N'
				END AS intentionToPort,
				CASE item.intentionToPort
					WHEN 1 THEN item.currentMobileNumberArea + item.currentMobileNumberMain
					ELSE ''
				END AS portInNumber,
				'' AS intentionToTransferExistingPrepay,
				'' AS currentMobileNumber,
				'' AS unassistedPromotionCode,
				item.mobileProvider AS mobileProvider,
				item.currentPackageType AS callPackageType,
				item.currentAccountNumber AS accountNumber,
				'' AS teleSalesCallType,
				'' AS telesalesCampaignType,
				handsetProduct.productName AS handset,
				CONVERT(VARCHAR(10),header.orderDate,103) AS orderDate,
				CONVERT(VARCHAR(10),history.statusDate,103) AS completedDate,
				'' AS price,
				item.ICCID,
				parentItemProduct.productName AS tariff,
				ISNULL(dbo.fn_getOrderAddOnNameListBusiness(header.orderRef, item.itemId),'') AS  addOns,
				'' AS topup,
				'' AS topupAmount, 
				'' AS slingBoxSerialNumber,
				item.endUserName AS forename,
				'' AS surname,
				header.retailerCode AS dealerCode,
				ISNULL(retailer.distributorCode,'') AS distributorCode,
				CASE WHEN deposit.depositId IS NULL 
					THEN 'No' 
					ELSE 'Yes' 
				END AS depositRequested,  
				ISNULL(STR(deposit.depositAmount),'') AS depositAmount,  
				ISNULL(deposit.paymentMethod,'') AS depositPaymentMethod,  
				ISNULL(dbo.getDepositReference(deposit.depositId),'') AS depositReference,
				'' AS my3,
				'' AS eBilling,
				org.promotionCode AS mediaTracker,
				ISNULL(retailerClassCodes.b4nClassDesc,'') AS marketingSource,
				'' AS referAFriendCode,
				'' AS referAFriendMSISDN,
				CASE WHEN parentItemProduct.productName = '' 
					THEN 'None' 
					ELSE parentItemProduct.productName 
				END AS parentTariff,
				childItemProduct.productName AS endUserTariff,
				org.tradingName	AS organisationName,
				'Business' AS customerType,
				CONVERT(CHAR(8), GETDATE(), 3) AS fileDate,
				'N' nbsEligible,
				COALESCE(nbsData.address1,'') AS coverageAddress1,
				COALESCE(nbsData.address2,'') AS coverageAddress2,
				COALESCE(nbsData.address3,'') AS coverageAddress3,
				COALESCE(nbsData.address4,'') AS coverageAddress4,
				COALESCE(nbsData.address5,'') AS coverageAddress5,
				COALESCE(nbsData.address6,'') AS coverageAddress6,
				COALESCE(nbsData.address7,'') AS coverageAddress7,
				COALESCE(nbsData.geoDirectoryId,bizmaps.geoDirectoryId,'') AS geoDirectoryId,
				COALESCE(nbsData.latitude,bizmaps.latitude,'') AS latitude,
				COALESCE(nbsData.longitude,bizmaps.longitude,'') AS longitude,
				COALESCE(nbsData.coverageLevel,bizmaps.coverageLevel,'') AS coverageLevel,
				COALESCE(nbsData.dedCode,bizmaps.dedCode,'') AS dedCode,
				COALESCE(nbsData.coverageType,bizmaps.coverageType,'') AS coverageType,
				CASE lo.linkedOrderRef WHEN NULL THEN '' ELSE STUFF('L000000',(8-Len(lo.linkedOrderRef)), Len(lo.linkedOrderRef),lo.linkedOrderRef) END AS linkedId,
				ISNULL(proms.promDesc,''),
				'No',
				'No'
				--'',
				--'',
				--'',
				--''
			FROM threeOrderHeader header WITH(NOLOCK)
			INNER JOIN smApplicationUsers users WITH(NOLOCK)
				ON header.userId = users.userId
			INNER JOIN threeOrderItem item WITH(NOLOCK)
				ON header.orderRef = item.orderRef
				AND item.parentItemId IS NOT NULL
			INNER JOIN threeOrderItemProduct childItemProduct WITH(NOLOCK)
				ON childItemProduct.itemId = item.itemId
				AND childItemProduct.productType = 'Tariff'
			INNER JOIN threeOrderItem parentItem WITH(NOLOCK)
				ON parentItem.itemId = item.parentItemId
			INNER JOIN threeOrderItemProduct parentItemProduct WITH(NOLOCK)
				ON parentItemProduct.itemId = parentItem.itemId
				AND parentItemProduct.productType = 'Tariff'
			INNER JOIN threeOrganization org WITH(NOLOCK)
				ON org.organizationId = header.organizationId
			INNER JOIN threeOrderItemProduct handsetProduct WITH(NOLOCK)
				ON handsetProduct.itemId = item.itemId
				AND handsetProduct.productType = 'Handset'
			INNER JOIN b4norderHistory history WITH(NOLOCK) 
				ON header.orderRef = history.orderRef 
				AND history.orderStatus in (309, 312)
			INNER JOIN h3giIccid iccid WITH(NOLOCK)
				ON iccid.ICCID = item.ICCID
			INNER JOIN h3giRetailer retailer WITH(NOLOCK)
				ON header.retailerCode = retailer.retailerCode
			LEFT OUTER JOIN h3giOrderdeposit deposit WITH(NOLOCK)
				ON header.orderRef = deposit.orderRef
			LEFT OUTER JOIN b4nClassCodes retailerClassCodes WITH(NOLOCK)
				ON org.mediaTrackingCode = retailerClassCodes.b4nClassCode
				AND retailerClassCodes.b4nClassSysId = 'COMMS_MEDIUM_RETAILER'
			LEFT OUTER JOIN h3giMobileSalesAssociatedNames msan WITH(NOLOCK)   
				ON header.salesAssociateId = msan.mobileSalesAssociatesNameId
			LEFT OUTER JOIN h3giNbsCoverageAddressData nbsData WITH(NOLOCK)
				ON header.orderref = nbsData.orderref
			LEFT OUTER JOIN h3giBizmapsAddressData bizmaps WITH(NOLOCK)
				ON header.orderref = bizmaps.orderRef
			LEFT OUTER JOIN h3giLinkedOrders lo WITH(NOLOCK)
				ON header.orderRef = lo.orderref
			LEFT OUTER JOIN #promTable proms 
				ON header.orderref = proms.temp_orderRef
		WHERE history.statusDate BETWEEN @startDate AND @endDateMorning
		
		SELECT * FROM @RegisteredCustomers ORDER by [Order Date]
END











GRANT EXECUTE ON h3giDataWarehousing_CompletedSalesRegisteredCustomers TO b4nuser
GO
