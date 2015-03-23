




/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giDataWarehousing_BusinessUpgrades
** Author			:	Simon Markey
** Date Created		:	31/05/2005
** Version			:	1
**					
**********************************************************************************************************************
**				
** Description		:	returns customer details for completed Accessory Sales
**					
**********************************************************************************************************************
**									
** Change Control	:	
**									
**											
**********************************************************************************************************************/

--exec h3giDataWarehousing_BusinessUpgrades '10/06/2013'

CREATE PROC [dbo].[h3giDataWarehousing_BusinessUpgrades]
	@endDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @endDateMorning DATETIME
	SET @endDateMorning = DATEADD(dd, DATEDIFF(dd, 0, @endDate), 0)
	
	DECLARE @startDate DATETIME
	SET @startDate = DATEADD(dd,-7,@endDateMorning)


CREATE TABLE #addonTable
	(
		temp_orderRef INT PRIMARY KEY,
		addonDesc NVARCHAR(500)
	)
	
	INSERT INTO #addonTable
	SELECT Main.orderRef, LEFT(Main.Addons, LEN(Main.Addons)-1) AS Addons
	FROM(SELECT DISTINCT addon2.orderRef, 
	(SELECT CAST(cat.productName AS NVARCHAR(255))+ ',' AS [text()]
	FROM h3gi..threeOrderUpgradeAddOn addon
	INNER JOIN h3gi..h3giProductCatalogue cat ON addon.addOnId = cat.catalogueProductID
	WHERE addon.orderRef = addon2.orderRef
	AND cat.catalogueVersionID = h3gi.dbo.fn_GetActiveCatalogueVersion()
	ORDER BY addon.orderRef
	FOR XML PATH ('')) [Addons]
	FROM h3gi..threeOrderUpgradeAddOn addon2) [Main]

	SELECT header.orderRef AS [Order Ref],
		   header.retailerCode AS [Dealer Code],
		   ISNULL(saleAssoc.employeeFirstName + ' ' 
		   + saleAssoc.employeeSurname,header.salesAssociateName) AS [Employee Name],
		   ISNULL(saleAssoc.payrollNumber,'') AS [Payroll Number],
		   ISNULL(saleAssoc.b4nRefNumber,'') [B4N Employee Reference],
		   CASE 
			 WHEN header.status = 309
			  THEN 'Dispatched'
			 WHEN header.status = 312
			  THEN 'Retailer Confirmed'
			 END AS [Order Status],
		   convert(varchar(10),CAST(header.orderDate AS DATE),103) AS [Order Date],
		   CAST(header.orderDate AS TIME(0)) AS [Order Time],
		   CASE WHEN history.status in(309,312)
			THEN history.statusDate END AS [Date Completed],
		   header.contractDuration AS [Contract Length],
		   upgrade.parentBAN AS [Parent Ban],
		   upgrade.childBAN AS [Ban],
		   upgrade.msisdn AS [MSISDN],
		   upgrade.companyName AS [Company / Organisation],
		   upgrade.userName AS [Username],
		   header.IMEI AS [IMEI],
		   cat.productName AS [Product],
		   ISNULL(parentPricePlan.pricePlanPackageName,'') AS [Parent Tariff],
		   childPricePlan.pricePlanPackageName AS [Tariff],
		   ISNULL(addons.addonDesc,'') AS [Addons],
		   '€'+CAST(header.totalOOC AS varchar) AS [Product Cost],
		   upgrade.band AS [Incoming Band],
		   header.outgoingBand AS [Outgoing Band],
		   header.previousContractLength AS [Upgrade Month]
	FROM h3gi..threeOrderUpgradeHeader header
	INNER JOIN h3gi..threeUpgrade upgrade 
		ON upgrade.upgradeId = header.upgradeId
	INNER JOIN h3gi..h3giProductCatalogue cat 
		ON cat.catalogueProductID = header.deviceId 
		AND cat.catalogueVersionID = header.catalogueVersionId
	INNER JOIN h3gi..threeOrderUpgradeHistory history 
		ON history.orderRef = header.orderRef
		AND history.status in (309,312)
	LEFT OUTER JOIN h3gi..threeOrderUpgradeParentHeader parentTariff 
		ON parentTariff.parentId = header.parentId
	LEFT OUTER JOIN h3gi..h3giPricePlanPackage childPricePlan 
		ON childPricePlan.pricePlanPackageID = header.childTariffId
		AND childPricePlan.catalogueVersionID = header.catalogueVersionId
	LEFT OUTER JOIN h3gi..h3giPricePlanPackage parentPricePlan 
		ON parentPricePlan.pricePlanPackageID = parentTariff.parentTariffId
		AND parentPricePlan.catalogueVersionID = header.catalogueVersionId
	LEFT OUTER JOIN #addonTable addons
		ON addons.temp_orderRef = header.orderRef
	LEFT OUTER JOIN h3gi..h3giMobileSalesAssociatedNames saleAssoc
		ON saleAssoc.mobileSalesAssociatesNameId = header.salesAssociateId
	WHERE header.status IN (309,310,312)
	AND header.orderDate > @StartDate
	AND header.orderDate < @EndDate
	ORDER BY [Order Ref] DESC
	
	DROP TABLE #addonTable
END   


GRANT EXECUTE ON h3giDataWarehousing_BusinessUpgrades TO b4nuser
GO
