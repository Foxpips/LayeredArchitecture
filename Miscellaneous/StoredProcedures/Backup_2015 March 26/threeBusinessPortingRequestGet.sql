

-- ====================================================================================================================
-- Author:		Attila Pall
-- Create date: 26/11/2007
-- Description:	
-- Changes:	19/12/2012	-	Stephen Quin	-	new fields returned: businessAccManager, salesAssociateName, storeName
-- Changes: 15/01/2013	-	Stephen King	-	Added inner join with threeBusinessAccManager
-- ====================================================================================================================
CREATE PROCEDURE [dbo].[threeBusinessPortingRequestGet] 
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT	
		toh.orderRef,
		o.registeredName,
		ISNULL(admin.firstName, '') + ' ' + LTRIM(ISNULL(admin.middleInitial, '') + ' ' + ISNULL(admin.lastName, '')) administratorName,
		ppn.fullNumber adminPhoneNumber,
		oi.endUserName,
		iccid.msisdn,
		LTRIM(ISNULL(oi.currentMobileNumberArea, '') + ' ' + ISNULL(oi.currentMobileNumberMain, '')) currentNumber,
		oi.mobileProvider currentProvider,
		oi.currentPackageType,
		oi.currentAccountNumber,
		ISNULL( CONVERT(varchar(20), oi.alternativeDateForPorting, 103) + ' ' + CONVERT(varchar(20), oi.alternativeDateForPorting, 108), '')   alternativePortingDate,
		BAM.AccManagerName AS businessAccManager,
		CASE toh.channelCode
 			WHEN 'UK000000292' THEN ISNULL(salesAssociateNames.employeeFirstName + ' ' + salesASsociateNames.employeeSurname,'')
			ELSE toh.salesAssociateName
		END AS salesAssociateName,
		ISNULL(store.storeName,'') AS dealer
	FROM threeOrderheader toh WITH(NOLOCK)
	INNER JOIN threeOrderItem oi WITH(NOLOCK)
		ON oi.orderRef = toh.orderRef
	INNER JOIN threeOrganization o WITH(NOLOCK)
		ON o.organizationId = toh.organizationId
	INNER JOIN h3giIccid iccid WITH(NOLOCK)
		ON iccid.iccid = oi.iccid
	INNER JOIN threeBusinessAccManager BAM WITH(NOLOCK)
		ON BAM.AccManagerID = businessAccManagerId
	LEFT OUTER JOIN threePerson admin WITH(NOLOCK)
		ON admin.organizationId = o.organizationId	
	LEFT OUTER JOIN threePersonPhoneNumber ppn WITH(NOLOCK)
		ON ppn.personId = admin.personId
	LEFT OUTER JOIN h3giRetailerStore store WITH(NOLOCK)
		ON toh.retailerCode = store.retailerCode
		AND toh.storeCode = store.storeCode
	LEFT OUTER JOIN h3giMobileSalesAssociatedNames salesAssociateNames WITH(NOLOCK)
		ON toh.salesAssociateId = salesAssociateNames.mobileSalesAssociatesNameId
	WHERE toh.orderStatus = 312
	AND oi.parentItemId IS NOT NULL
	AND oi.intentionToPort = 1
	AND admin.personType = 'Administrator1'
	AND ppn.phoneNumberType = 'DaytimeContact'
	AND toh.orderRef NOT IN (SELECT orderRef from threeBusinessPortingAudit)
END




GRANT EXECUTE ON threeBusinessPortingRequestGet TO b4nuser
GO
GRANT EXECUTE ON threeBusinessPortingRequestGet TO reportuser
GO
