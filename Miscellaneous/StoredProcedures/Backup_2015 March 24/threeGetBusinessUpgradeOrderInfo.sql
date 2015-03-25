
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 17/05/2013
-- Description:	Gets detailed information about an business upgrade order.
-- =============================================
CREATE PROCEDURE [dbo].[threeGetBusinessUpgradeOrderInfo]
(
	@orderRef	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		u.authorisedContactName as contactName,
		u.companyName,
		ph.parentBAN,
		pppp.pricePlanPackageID as parentTariffId,
		pppp.pricePlanPackageName as parentTariffName,
		u.upgradeId,
		u.userName,		
		u.msisdn,
		u.childBAN,
		u.emailAddress,
		'(' + u.contactNumAreaCode + ')' + contactNumMain AS contactNumber,
			CASE WHEN LEN(currentAddress.aptNumber) > 0 THEN currentAddress.aptNumber+ ', ' ELSE '' END +
			CASE WHEN LEN(currentAddress.houseNumber) > 0 THEN currentAddress.houseNumber + ', ' ELSE '' END +
			CASE WHEN LEN(currentAddress.houseName) > 0 THEN currentAddress.houseName+ ', ' ELSE '' END +
			CASE WHEN LEN(currentAddress.street) > 0 THEN currentAddress.street+ ', ' ELSE '' END +
			CASE WHEN LEN(currentAddress.locality) > 0 THEN currentAddress.locality+ ', ' ELSE '' END +
			CASE WHEN LEN(currentAddress.town) > 0 THEN currentAddress.town+ ', ' ELSE '' END +
			CASE WHEN LEN(currentAddressB4nClassCodes.b4nClassDesc) > 0 THEN currentAddressB4nClassCodes.b4nClassDesc+ ', ' ELSE '' END +
			ISNULL(currentAddress.country, '') 
	    AS currentAddress,
			CASE WHEN LEN(deliveryAddress.aptNumber) > 0 THEN deliveryAddress.aptNumber+ ', ' ELSE '' END +
			CASE WHEN LEN(deliveryAddress.houseNumber) > 0 THEN deliveryAddress.houseNumber + ', ' ELSE '' END +
			CASE WHEN LEN(deliveryAddress.houseName) > 0 THEN deliveryAddress.houseName+ ', ' ELSE '' END +
			CASE WHEN LEN(deliveryAddress.street) > 0 THEN deliveryAddress.street+ ', ' ELSE '' END +
			CASE WHEN LEN(deliveryAddress.locality) > 0 THEN deliveryAddress.locality+ ', ' ELSE '' END +
			CASE WHEN LEN(deliveryAddress.town) > 0 THEN deliveryAddress.town+ ', ' ELSE '' END +
			CASE WHEN LEN(deliveryAddressB4nClassCodes.b4nClassDesc) > 0 THEN deliveryAddressB4nClassCodes.b4nClassDesc+ ', ' ELSE '' END +
			ISNULL(deliveryAddress.country, '') 
	    AS deliveryAddress,
		h.status,
		h3giRetailer.retailerName as retailer,
		cppp.pricePlanPackageID as childTariffId,
		cppp.pricePlanPackageName as childTariffName,
		h.contractDuration,
		bandCC.b4nClassDesc + SUBSTRING(h.outgoingBand, 2, 2) as outgoingBand,
		h.totalMRC,
		h.totalOOC,
		h.orderDate,
		h3giChannel.channelName as channel,
		h3giProductCatalogue.productName as device,
		h.backInStockDate		
    FROM threeOrderUpgradeHeader h

	INNER JOIN h3giRetailer
	ON h3giRetailer.retailerCode = h.retailerCode
	
	INNER JOIN h3giChannel
	ON h3giChannel.channelCode = h.channelCode

	INNER JOIN h3giPricePlanPackage cppp
	ON cppp.pricePlanPackageID = h.childTariffId
	AND cppp.catalogueVersionID = h.catalogueVersionID
    
    INNER JOIN threeOrderUpgradeParentHeader ph
    ON ph.parentId = h.parentId
    
	LEFT JOIN h3giPricePlanPackage pppp
	ON pppp.pricePlanPackageID = ph.parentTariffId
	AND pppp.catalogueVersionID = ph.catalogueVersionID
    
    INNER JOIN threeOrderUpgradeAddress currentAddress
    ON currentAddress.parentId = ph.parentId AND currentAddress.addressType = 'Current'
    
   	LEFT JOIN b4nClassCodes currentAddressB4nClassCodes
    ON currentAddressB4nClassCodes.b4nClassSysID = 'SubCountry' AND currentAddressB4nClassCodes.b4nClassCode = currentAddress.countyId

    INNER JOIN threeOrderUpgradeAddress deliveryAddress
    ON deliveryAddress.parentId = ph.parentId AND deliveryAddress.addressType = 'Delivery'
    
   	LEFT JOIN b4nClassCodes deliveryAddressB4nClassCodes
    ON deliveryAddressB4nClassCodes.b4nClassSysID = 'SubCountry' AND deliveryAddressB4nClassCodes.b4nClassCode = deliveryAddress.countyId
   
    INNER JOIN threeUpgrade u
    ON u.upgradeId = h.upgradeId
    
    LEFT JOIN b4nClassCodes uB4nClassCodes
	ON uB4nClassCodes.b4nClassSysID = 'SubCountry' AND uB4nClassCodes.b4nClassCode = u.countyId
    
    INNER JOIN h3giProductCatalogue
    ON h.catalogueVersionId = h3giProductCatalogue.catalogueVersionID
    AND h.deviceId = h3giProductCatalogue.catalogueProductID
    
	INNER JOIN b4nClassCodes bandCC
	ON SUBSTRING(h.outgoingBand, 1, 1) = bandCC.b4nClassCode
	AND bandCC.b4nClassSysID = 'BusinessUpgradeBand'
    
    WHERE orderRef = @orderRef
    
    ----------------------------------------------------------------------
    -- Parent Addons
    SELECT pc.productName, pc.catalogueProductID
    FROM threeOrderUpgradeParentHeader ph
    
    INNER JOIN threeOrderUpgradeHeader h
    ON h.parentId = ph.parentId
    
    INNER JOIN threeOrderUpgradeParentAddOn pa
    ON pa.parentId = ph.parentId
    
    INNER JOIN h3giProductCatalogue pc
    ON pc.catalogueVersionID = h.catalogueVersionId
    AND pc.catalogueProductID = pa.addOnId
    
    WHERE h.orderRef = @orderRef
    ----------------------------------------------------------------------
    -- Child Addons
    SELECT pc.productName, pc.catalogueProductID
    FROM threeOrderUpgradeHeader h
    
    INNER JOIN threeOrderUpgradeAddOn a
    ON a.orderRef = h.orderRef
    
    INNER JOIN h3giProductCatalogue pc
    ON pc.catalogueVersionID = h.catalogueVersionId
    AND pc.catalogueProductID = a.addOnId
    
    WHERE h.orderRef = @orderRef
    ---------------------------------------------------------------------
    -- Linked Orders
    DECLARE @linkedOrderRef INT
	
    --1. Get the Linked Order id
    SELECT @linkedOrderRef = linkedOrderRef 
    FROM h3giLinkedOrders
    WHERE orderRef = @orderRef
    
    --2. Get the order details for the orders associated with that linked order Ref
    SELECT lnk.orderRef,
		   lnk.linkedOrderRef as linkedOrderId,
		   h3giProductCatalogue.productName as device,
		   h.status,
		   cppp.pricePlanPackageName as tariff
    FROM h3giLinkedOrders lnk
    
    INNER JOIN threeOrderUpgradeHeader h
    ON h.orderRef = lnk.orderRef
    
    INNER JOIN h3giProductCatalogue
    ON h.catalogueVersionId = h3giProductCatalogue.catalogueVersionID
    AND h.deviceId = h3giProductCatalogue.catalogueProductID

	INNER JOIN h3giPricePlanPackage cppp
	ON cppp.pricePlanPackageID = h.childTariffId
	AND cppp.catalogueVersionID = h.catalogueVersionID
    
    WHERE linkedOrderRef = @linkedOrderRef
    AND lnk.orderRef <> @orderRef
    
    --3. Get all the addons for the linked orders.
    SELECT lnk.orderRef, pc.productName
    FROM h3giLinkedOrders lnk
    
    INNER JOIN threeOrderUpgradeHeader h
    ON h.orderRef = lnk.orderRef
    
    INNER JOIN threeOrderUpgradeAddOn a
    ON a.orderRef = h.orderRef
    
    INNER JOIN h3giProductCatalogue pc
    ON pc.catalogueVersionID = h.catalogueVersionId
    AND pc.catalogueProductID = a.addOnId
    
    WHERE linkedOrderRef = @linkedOrderRef
    AND lnk.orderRef <> @orderRef
END


GRANT EXECUTE ON threeGetBusinessUpgradeOrderInfo TO b4nuser
GO
