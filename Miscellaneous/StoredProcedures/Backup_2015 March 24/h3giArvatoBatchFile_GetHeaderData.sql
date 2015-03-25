  
/**********************************************************************************************************************  
* Change Control:	24/06/2014 - Sorin Oboroceanu - Gets the data used to generate the Arvato batch file header.
**********************************************************************************************************************/  
CREATE PROCEDURE [dbo].[h3giArvatoBatchFile_GetHeaderData]    
(
	@BatchId INT    
)
AS    
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @SimTypeAttributeId INT
    SET @SimTypeAttributeId = dbo.fn_GetAttributeByName('SimType');

	-- CONSUMER ---------------------------------------------------
	DECLARE @ConsumerUpgradeOrdersNoSim INT,
			@ConsumerKittedProducts INT,
			@ConsumerAccessoryProducts INT,
			@ConsumerSimProducts INT

	DECLARE @ConsumerBatchOrders TABLE    
	(
		orderRef INT PRIMARY KEY
	);    
	INSERT INTO @ConsumerBatchOrders(orderRef)
	SELECT bo.OrderRef
	FROM h3giBatchOrder bo
	INNER JOIN h3giOrderheader head ON bo.OrderRef = head.orderref
	WHERE bo.BatchID = @BatchId	
  
	-- Count the number of consumer upgrade order that don't require a SIM (the customer kept his SIM).
	SELECT @ConsumerUpgradeOrdersNoSim = ISNULL(COUNT(h.orderref), 0)
	FROM @ConsumerBatchOrders b  
	INNER JOIN h3giOrderheader h ON b.orderRef = h.orderref  
	INNER JOIN h3giUpgrade u ON u.UpgradeId = h.UpgradeID  
	INNER JOIN b4nAttributeProductFamily a ON a.productFamilyId = h.phoneProductCode AND a.attributeId = @SimTypeAttributeId  
	WHERE u.simType = a.attributeValue
	AND h.orderType IN (2, 3)
    
	--Count the number of  kitted products so that we can     
	--subtract this amount from the "Segments" in the header row    
	SELECT @ConsumerKittedProducts = COUNT(*)    
	FROM h3giOrderHeader HOH
	INNER JOIN viewOrderPhone  VOP ON VOP.OrderRef = HOH.OrderRef    
	WHERE HOH.OrderRef IN (SELECT OrderRef FROM @ConsumerBatchOrders)    
	AND VOP.Kitted = 1
  
	--Count the number of accessory products so    
	--we can subtract the amount from the "Segments" in the header row    
	SELECT @ConsumerAccessoryProducts = COUNT(*)    
	FROM h3giOrderheader h3gi    
	 INNER JOIN @ConsumerBatchOrders b    
	 ON h3gi.orderref = b.orderRef    
	WHERE h3gi.orderType = 4   

	--Count the number of SIM orders and subtract that from the Segments in the header
	--we no longer want to add a SIM row to the file for SIM only orders
	SELECT @ConsumerSimProducts = COUNT(*) 
	FROM @ConsumerBatchOrders b   
	INNER JOIN h3giOrderheader h3gi
		ON b.orderRef = h3gi.orderref
	INNER JOIN h3giProductCatalogue cat
		ON h3gi.catalogueVersionID = cat.catalogueVersionID
		AND h3gi.phoneProductCode = cat.productFamilyId
	INNER JOIN h3giProductAttributeValue pav
		ON pav.catalogueProductId = cat.catalogueProductID
	INNER JOIN h3giProductAttribute att
		ON att.attributeId = pav.attributeId
	WHERE att.attributeName = 'SIM'

	-- BUSINESS------------------------------------------------------
	DECLARE	@BusinessUpgradeOrdersNoSim INT,
			@BusinessUpgradeKittedProducts INT

	DECLARE @BusinessUpgradeBatchOrders TABLE    
	(
		orderRef INT PRIMARY KEY
	);	    
	INSERT INTO @BusinessUpgradeBatchOrders(orderRef)    
	SELECT bo.OrderRef
	FROM h3giBatchOrder bo
	INNER JOIN threeOrderUpgradeHeader head	ON bo.OrderRef = head.orderref
	WHERE bo.BatchID = @BatchId

	--Count the number of orders that don't require SIMs so that we can     
	--subtract this amount from the "Segments" in the header row    
	SELECT @BusinessUpgradeOrdersNoSim = ISNULL(COUNT(head.orderref), 0)
	FROM @BusinessUpgradeBatchOrders b  
	INNER JOIN threeOrderUpgradeHeader head ON b.orderRef = head.orderref
	INNER JOIN threeUpgrade upg ON upg.UpgradeId = head.UpgradeID
	INNER JOIN h3giProductCatalogue cat	ON head.deviceId = cat.catalogueProductID AND head.catalogueVersionId = cat.catalogueVersionID
	INNER JOIN b4nAttributeProductFamily a ON a.productFamilyId = cat.productFamilyId AND a.attributeId = @SimTypeAttributeId  
	WHERE upg.simType = a.attributeValue  
	
	--Count the number of  kitted products so that we can     
	--subtract this amount from the "Segments" in the header row    
	SELECT @BusinessUpgradeKittedProducts = COUNT(*)    
	FROM threeOrderUpgradeHeader head
	INNER JOIN h3giProductCatalogue cat ON head.deviceId = cat.catalogueProductID AND head.catalogueVersionId = cat.catalogueVersionID
	WHERE cat.Kitted = 1
	--------------------------------------------------------------
   
	SELECT	'H1' AS SegmentId,
			BatchId,
			b4nClassCodes.b4nClassCode AS CarrierCode,
			Courier AS CarrierName,
			'SearchProduct:' + CAST(SearchProduct AS VARCHAR(10)) + ';' +
			'SearchDateFrom:' + CAST(ISNULL(SearchDateFrom, '') AS VARCHAR (20))+ ';' +
			'SearchDateTo:' + CAST(ISNULL(SearchDateTo, '') AS VARCHAR (20)) + ';' +
			'SearchOutOfStock:' + CAST(SearchOutOfStock AS VARCHAR(1)) + ';' AS FilterCriteria,
			CreateDate,
			(SELECT COUNT(OrderRef) FROM @ConsumerBatchOrders) AS ConsumerTransactions,
			((((SELECT COUNT(OrderRef) FROM @ConsumerBatchOrders) * 3) + 1) - @ConsumerUpgradeOrdersNoSim - @ConsumerKittedProducts - @ConsumerAccessoryProducts - @ConsumerSimProducts) AS ConsumerSegments,
			(SELECT	COUNT(orderRef) FROM @BusinessUpgradeBatchOrders) AS BusinessUpgradeTransactions,			
			(SELECT ((COUNT (orderRef) * 3) - @BusinessUpgradeOrdersNoSim - @BusinessUpgradeKittedProducts) FROM @BusinessUpgradeBatchOrders) AS BusinessUpgradeSegments
	FROM h3giBatch
	INNER JOIN b4nClassCodes ON b4nClassCodes.b4nClassDesc = h3giBatch.Courier AND b4nClassCodes.b4nClassSysID = 'SONO_CARRIER'
	WHERE BatchID = @BatchId
END
GRANT EXECUTE ON h3giArvatoBatchFile_GetHeaderData TO b4nuser
GO
