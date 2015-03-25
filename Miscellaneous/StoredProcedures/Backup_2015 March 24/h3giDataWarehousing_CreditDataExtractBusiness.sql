
-- ====================================================================================
-- Author:		Stephen Quin
-- Create date: 17/02/2010
-- Description:	The credit data extract business report in data warehousing form
-- Changes:		07/02/13	-	Stephen Quin	-	New field declineDecision returned
-- ====================================================================================
CREATE PROCEDURE [dbo].[h3giDataWarehousing_CreditDataExtractBusiness] 
	@endDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @endDateMorning DATETIME
	SET @endDateMorning = DATEADD(dd, DATEDIFF(dd, 0, @endDate), 0)
	
	DECLARE @startDate DATETIME
	SET @startDate = DATEADD(dd,-7,@endDateMorning)

	SELECT  oh.orderref AS 'Order Ref',				
			oh.retailercode AS 'Retailer Code',	
			CASE classCodes.b4nClassDesc 
			WHEN 'Retailer Approved' 
				THEN 'Credit Approved' 
				ELSE classCodes.b4nClassDesc 
			END AS 'Order Status',
			CASE oh.channelCode
	 			WHEN 'UK000000292' THEN ISNULL(salesAssociateNames.employeeFirstName + ' ' + salesASsociateNames.employeeSurname,'')
	 			WHEN 'UK000000293' THEN oh.salesAssociateName
				ELSE ''
			END AS 'Employee Name',
			CASE oh.creditanalystId
				WHEN '' THEN 'n/a'
				ELSE smcreditusers.username
			END AS [Credit Analyst ID],
			o.promotionCode AS 'Media Tracker',							
			ISNULL(retailerClassCodes.b4nClassDesc,'') AS 'Marketing Source',			
			CONVERT(CHAR(10),oh.orderdate,103) AS 'Order Date',	
			CONVERT(CHAR(5),oh.orderdate,24)   AS 'Order Time',	  
		
			ISNULL((SELECT   TOP 1 CASE cc2.b4nclassdesc
					WHEN 'Retailer Approved' THEN 'Credit Approved'
					ELSE cc2.b4nclassdesc END
					FROM b4norderhistory boh2 WITH (NOLOCK)
						JOIN b4nclasscodes cc2 WITH (NOLOCK)
						ON CAST(boh2.orderstatus AS VARCHAR(8)) = cc2.b4nclasscode
					WHERE boh2.orderref = oh.orderref
						AND boh2.orderstatus IN (311,402,305,301,302)
					ORDER BY boh2.statusdate ASC),'') AS 'First Decision',

			ISNULL((SELECT   TOP 1 CONVERT(CHAR(8),boh2.statusdate,8)
					FROM b4norderhistory boh2 WITH (NOLOCK)
						JOIN b4nclasscodes cc2 WITH (NOLOCK)
						ON CAST(boh2.orderstatus AS VARCHAR(8)) = cc2.b4nclasscode
					WHERE boh2.orderref = oh.orderref
						AND boh2.orderstatus IN (311,402,305,301,302)
					ORDER BY boh2.statusdate ASC),'') AS 'First Decision Time',			
					
			ISNULL((SELECT   TOP 1 CONVERT(CHAR(8),boh2.statusdate,3)
					FROM b4norderhistory boh2 WITH (NOLOCK)
						JOIN b4nclasscodes cc2 WITH (NOLOCK)
						ON CAST(boh2.orderstatus AS VARCHAR(8)) = cc2.b4nclasscode
					WHERE boh2.orderref = oh.orderref
						AND boh2.orderstatus IN (311,402,305,301,302)
					ORDER BY boh2.statusdate ASC),'') AS 'First Decision Date',	
		
			ISNULL((SELECT TOP 1 CASE cc2.b4nclassdesc
					WHEN 'Retailer Approved' THEN 'Credit Approved'
					ELSE cc2.b4nclassdesc END
					FROM b4norderhistory boh2 WITH (NOLOCK)
						JOIN b4nclasscodes cc2 WITH (NOLOCK)
						ON CAST(boh2.orderstatus AS VARCHAR(8)) = cc2.b4nclasscode
					WHERE boh2.orderref = oh.orderref
						AND boh2.orderstatus IN (311,402,305,301,302)
					ORDER BY boh2.statusdate DESC),'') AS 'Final Decision',		
			
			ISNULL((SELECT TOP 1 CONVERT(CHAR(8),boh2.statusdate,3)
					FROM b4norderhistory boh2 WITH (NOLOCK)
						JOIN b4nclasscodes cc2 WITH (NOLOCK)
						ON CAST(boh2.orderstatus AS VARCHAR(8)) = cc2.b4nclasscode
					WHERE    boh2.orderref = oh.orderref
						AND boh2.orderstatus IN (311,402,305,301,302)
					ORDER BY boh2.statusdate DESC),'') AS 'Final Decision Date',	

			oh.creditCheckReference AS 'Credit Bureau Ref',				
			oh.reasonCode AS 'Reason Code',												
			CASE
			WHEN EXISTS(SELECT * FROM h3giOrderDeposit deposit WHERE deposit.orderRef = oh.orderRef )
				THEN 'Yes'
				ELSE 'No' 
			END AS 'Deposit Requested',						
			ISNULL(deposit.depositAmount,'') AS 'Deposit Amount',		
			oh.creditLimit AS 'Credit Limit',											
			oh.shadowCreditLimit AS 'Shadow Credit Limit',										
			oh.maximumEndUserCount AS 'Max Num Devices',				                                                                                                             
			o.registeredName AS 'Registered Name',											
			o.tradingName 'Trading Name',												
			o.organizationType AS 'Business Type',						
			o.industryType AS 'Industry Type',							
			o.currentMonthlyMobileSpend AS 'Estimated Monthly Spend',			
			o.numberOfDevicesRequired 'Num Devices Required',									
			ISNULL(catalogue.productName,'') AS 'Price Plan Requested',	
			CASE WHEN oh.timeWithBankYears <> 0 OR oh.timeWithBankMonths <> 0 THEN CAST(oh.timeWithBankYears AS VARCHAR(5)) + ' Years, ' + CAST(oh.timeWithBankMonths AS VARCHAR(2)) + ' Months' ELSE '' END AS 'Time With Bank',	
			oh.paymentMethod AS 'Payment Method',											
			oh.bic AS 'BIC',
			oh.iban AS 'IBAN',
			oh.bankSortCode AS 'Sort Code',											
			oh.accountNumber AS 'Account Num',											
			ISNULL(contactPerson.firstName,'') + ' ' + ISNULL(contactPerson.middleInitial,' ') + ' ' + ISNULL(contactPerson.lastName,'') AS 'Contact Name',	
			contactPerson.position AS 'Contact Position',					
			CASE WHEN contactPerson.timeInBusinessYY <> 0 OR contactPerson.timeInBusinessMM <> 0 THEN CAST(contactPerson.timeInBusinessYY AS VARCHAR(5)) + ' Years, ' + CAST(contactPerson.timeInBusinessMM AS VARCHAR(2)) + ' Months' ELSE '' END AS 'Time in Business',	
			contactPersonPhone.fullNumber AS 'Contact Num',
			contactPerson.email AS 'Contact Email',												
			billingAddress.fullAddress AS 'Billing Address',				
			tradingAddress.fullAddress AS 'Trading Address',				
			o.registeredNumber AS 'Registered Num',										
			o.numberOfEmployees AS 'Num Employees',										
			orgAddress.fullAddress AS 'Full Address',									
			CASE WHEN o.currentOwnershipTimeYY <> 0 OR o.currentOwnershipTimeMM <> 0 THEN CAST(o.currentOwnershipTimeYY AS VARCHAR(5)) + ' Years, ' + CAST(o.currentOwnershipTimeMM AS VARCHAR(2)) + ' Months' ELSE '' END AS 'Time Under Ownership',	
			ISNULL(proprietor1.firstName,'') + ' ' + ISNULL(proprietor1.middleInitial,' ') + ' ' + ISNULL(proprietor1.lastName,'') AS 'Prop 1 Name',
			CONVERT(CHAR(10), proprietor1.dateOfBirth, 103) AS 'Prop 1 DOB',												
			ISNULL(proprietor1.gender,'') AS 'Prop 1 Gender',								
			ISNULL(proprietor1Address.fullAddress,'') AS 'Prop 1 Address',				
			ISNULL(proprietor1PrevAddress.fullAddress,'') AS 'Prop 1 Prev Address',		
			ISNULL(proprietor1SecondPrevAddress.fullAddress,'') AS 'Prop 1 2nd Prev Addr',	
			ISNULL(proprietor1.maritalStatus,'') AS 'Prop 1 Marital Status',				
			ISNULL(proprietor1Address.propertyStatus,'') AS 'Prop 1 Property Status',		
			ISNULL(proprietor1Phone.fullNumber,'') AS 'Prop 1 Phone Num',				
			ISNULL(proprietor1.email,'') AS 'Prop 1 Email',							
			ISNULL(proprietor1.occupationStatus,'') AS 'Prop 1 Occupation Status',		
			ISNULL(proprietor1.occupationType,'') AS 'Prop 1 Occupation Type',			
			ISNULL(proprietor1WorkPhone.fullNumber,'') AS 'Prop 1 Work Num',		
			CASE 
				WHEN proprietor1.timeInBusinessYY IS NULL AND proprietor1.timeInBusinessMM IS NULL THEN '' 
				WHEN proprietor1.timeInBusinessYY = 0 AND proprietor1.timeInBusinessMM = 0 THEN ''
				ELSE CAST(proprietor1.timeInBusinessYY AS VARCHAR(5)) + ' Years, ' + CAST(proprietor1.timeInBusinessMM AS VARCHAR(2)) + ' Months' END AS 'Time With Employer', 
			ISNULL(proprietor2.firstName,'') + ' ' + ISNULL(proprietor2.middleInitial,' ') + ' ' + ISNULL(proprietor2.lastName,'') AS 'Prop 2 Name',	
			CONVERT(CHAR(10), proprietor2.dateOfBirth, 103) AS 'Prop 2 DOB',											
			ISNULL(proprietor2.gender,'') AS 'Prop 2 Gender',								
			ISNULL(proprietor2Phone.fullNumber,'') AS 'Prop 2 Phone Num',					
			ISNULL(proprietor2.email,'') AS 'Prop 2 Email',									
			ISNULL(proprietor2Address.fullAddress,'') AS 'Prop 2 Address',					
			ISNULL(proprietor2PrevAddress.fullAddress,'') AS 'Prop 2 Prev Address',			
			ISNULL(proprietor2SecondPrevAddress.fullAddress,'') AS 'Prop 2 2nd Prev Address',
			CASE oh.creditScore WHEN 0 THEN '' ELSE oh.creditScore END AS 'Credit Score',
			ISNULL(declineDecision.b4nClassDesc,'') AS 'Decision Reason'
	FROM	threeOrderHeader oh WITH (NOLOCK)
		INNER JOIN threeOrganization o WITH (NOLOCK)
			ON oh.organizationId = o.organizationId
		INNER JOIN threePerson contactPerson WITH (NOLOCK)
			ON contactPerson.organizationId = oh.organizationId
			AND contactPerson.personType = 'Contact'
		INNER JOIN threePersonPhoneNumber contactPersonPhone WITH (NOLOCK)
			ON contactPerson.personId = contactPersonPhone.personId
		INNER JOIN threeOrganizationAddress billingAddress WITH (NOLOCK)
			ON o.organizationId = billingAddress.organizationId
			AND billingAddress.addressType = 'BillingBusiness'
		INNER JOIN threeOrganizationAddress tradingAddress WITH (NOLOCK)
			ON o.organizationId = tradingAddress.organizationId
			AND tradingAddress.addressType = 'Trading'
		INNER JOIN threeOrganizationAddress orgAddress WITH (NOLOCK)
			ON o.organizationId = orgAddress.organizationId
			AND orgAddress.addressType IN ('Registered', 'Business')
		INNER JOIN b4nClassCodes classCodes WITH (NOLOCK)
			ON oh.orderStatus = classCodes.b4nClassCode
			AND classCodes.b4nClassSysID = 'StatusCode'
		LEFT OUTER JOIN threePerson proprietor1 WITH (NOLOCK)
			ON proprietor1.organizationId = oh.organizationId
			AND proprietor1.personType = 'Proprietor1'
		LEFT OUTER JOIN threePerson proprietor2 WITH (NOLOCK)
			ON proprietor2.organizationId = oh.organizationId
			AND proprietor2.personType = 'Proprietor2'
		LEFT OUTER JOIN threePersonAddress proprietor1Address WITH (NOLOCK)
			ON proprietor1.personId = proprietor1Address.personId
			AND proprietor1Address.addressType = 'Current'
		LEFT OUTER JOIN threePersonAddress proprietor2Address WITH (NOLOCK)
			ON proprietor2.personId = proprietor2Address.personId
			AND proprietor2Address.addressType = 'Current'
		LEFT OUTER JOIN threePersonAddress proprietor1PrevAddress WITH (NOLOCK)
			ON proprietor1.personId = proprietor1PrevAddress.personId
			AND proprietor1PrevAddress.addressType = 'Previous1'
		LEFT OUTER JOIN threePersonAddress proprietor2PrevAddress WITH (NOLOCK)
			ON proprietor2.personId = proprietor2PrevAddress.personId
			AND proprietor2PrevAddress.addressType = 'Previous1'
		LEFT OUTER JOIN threePersonAddress proprietor1SecondPrevAddress WITH (NOLOCK)
			ON proprietor1.personId = proprietor1SecondPrevAddress.personId
			AND proprietor1SecondPrevAddress.addressType = 'Previous2'
		LEFT OUTER JOIN threePersonAddress proprietor2SecondPrevAddress WITH (NOLOCK)
			ON proprietor2.personId = proprietor2SecondPrevAddress.personId
			AND proprietor2SecondPrevAddress.addressType = 'Previous2'
		LEFT OUTER JOIN threePersonPhoneNumber proprietor1Phone WITH (NOLOCK)
			ON proprietor1.personId = proprietor1Phone.personId
			AND proprietor1Phone.phoneNumberType = 'DaytimeContact'
		LEFT OUTER JOIN threePersonPhoneNumber proprietor2Phone WITH (NOLOCK)
			ON proprietor2.personId = proprietor2Phone.personId
			AND proprietor2Phone.phoneNumberType = 'DaytimeContact'
		LEFT OUTER JOIN threePersonPhoneNumber proprietor1WorkPhone WITH (NOLOCK)
			ON proprietor1.personId = proprietor1WorkPhone.personId
			AND proprietor1WorkPhone.phoneNumberType = 'WorkContact'
		LEFT OUTER JOIN smApplicationUsers smCreditUsers WITH (NOLOCK)
			ON oh.creditAnalystId = smCreditUsers.userid
		LEFT OUTER JOIN h3giOrderdeposit deposit WITH (NOLOCK)
			ON oh.orderRef = deposit.orderRef
		LEFT OUTER JOIN h3giproductcatalogue catalogue WITH (NOLOCK)
			ON o.priceplanrequiredpeoplesoftid = catalogue.peoplesoftid
			AND catalogue.productType = 'TARIFF'
			AND catalogue.catalogueversionid = [dbo].[fn_getActiveCatalogueVersion]()
		LEFT OUTER JOIN b4nClassCodes retailerClassCodes WITH (NOLOCK)
			ON o.mediaTrackingCode = retailerClassCodes.b4nClassCode
			AND retailerClassCodes.b4nClassSysId = 'COMMS_MEDIUM_RETAILER'
		LEFT OUTER JOIN h3giMobileSalesAssociatedNames salesAssociateNames WITH(NOLOCK)
			ON oh.salesAssociateId = salesAssociateNames.mobileSalesAssociatesNameId
		LEFT OUTER JOIN b4nClassCodes declineDecision WITH(NOLOCK)
			ON oh.reasonDescription = declineDecision.b4nClassCode
			AND declineDecision.b4nClassSysID = 'DeclinedDecisionTextBusiness'
	WHERE	oh.orderDate between @startDate and @endDateMorning 
			AND ISNULL(creditAnalystId, '') <> ''
	ORDER BY oh.orderRef
END


GRANT EXECUTE ON h3giDataWarehousing_CreditDataExtractBusiness TO b4nuser
GO
