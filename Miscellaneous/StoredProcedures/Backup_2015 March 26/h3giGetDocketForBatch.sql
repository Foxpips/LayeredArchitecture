
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetDocketForBatch
** Author		:	????? 
** Date Created		:	??/??/??
**					
**********************************************************************************************************************
**				
** Description		:	Retrieves docket information for a batch.
**						Returns 2 tables:
**							1) orders in the batch
**							2) order lines in the batch
**				
** Parameters:		: 
**						@BatchID - batch ID
******************************************************************************************************************************************
**									
** Change Control	:	??/??/??  - ???? - Created
**					:	13/03/2007 - Adam Jasinski - added query returning order table (it is executed before existing order lines query)
**
**					:	02/10/2008 - Stephen Quin - (1) Added a join to the viewOrderAddress view and concatenated the views apartmentNumber, 
**														houseNumber and houseName fields to provide the new value for deliveryAddr1
**													(2) Created a table variable, @BatchOrderRefs, that will store all the orderRefs
**														associated with the batchId passed as a parameter. Joins are then made with this
**														table variable rather than h3giOrderHeader or b4nOrderHeader to help speed up
**														the retrieval of records
**					:	12/07/2011 - Stephen Quin        - Topup Vouchers are now excluded from the delivery docket
**					:	28/07/2011 - Stephen Quin        - removed the joins to viewOrderPhone
**					:	13/09/2011	-	Stephen Mooney	 -	Join to catalogue to retrieve tariff name, price and contrract length
**					:	04/10/2011	-	Stephen Quin	 -	Surf Kits are now excluded from the docket
**					:	06/02/2012	-	Simon Markey	 -	Now returns h3giorderheader recurring tariff price instead of base catalogue price,
**														 	in order to take discounts into account
**					:	14/02/2012	-	Simon Markey	 -	Changed h3giProductCatalogue Join and h3giPricePlanPackage Join to Left outer joins
**													 	 	in order to allow Accessories to be displayed in delivery dockets
**					:	25/09/2012	-	Stephen Quin	 -	contract length pulled from h3giOrderHeader rather than from the pricePlanPackage table
**					:	22/10/2012	-	Stephen Quin	 -	order by orderRef rather than AddedOrder
**					:	21/11/2012	-	Stephen Quin	 -	Added Temp orderRefVar which is a varchar version of batchOrder.orderRef for faster seek
**					:	26/04/2013	-	Sorin Oboroceanu -	Included business upgrade orders.
**					:	31/07/2013	-	Simon Markey	 -	Included if orderref is business
*****************************************************************************************************************************************/


CREATE PROCEDURE [dbo].[h3giGetDocketForBatch]
@BatchID int
AS
	DECLARE @BatchOrderRefs 
	TABLE(batchId INT, orderRef INT, addedOrder INT, PRIMARY KEY(batchId,orderRef))

	INSERT INTO @BatchOrderRefs
		SELECT	batchOrder.batchId, batchOrder.orderRef, batchOrder.AddedOrder
		FROM	h3giBatchOrder batchOrder 
		WHERE	batchOrder.batchId = @BatchID

	--First table - orders in the batch
	SELECT	batchOrderRef.batchId,
			batchOrderRef.orderRef,
			b4nHeader.deliveryForeName, 
			b4nHeader.deliverySurName, 
			CASE WHEN LEN(viewAddress.apartmentNumber) > 0 THEN viewAddress.apartmentNumber + ' ' ELSE '' END +
			CASE WHEN LEN(viewAddress.houseNumber) > 0 THEN viewAddress.houseNumber + ' ' ELSE '' END +
			viewAddress.houseName AS deliveryAddr1, 
			b4nHeader.deliveryAddr2, 
			b4nHeader.deliveryAddr3, 
			b4nHeader.deliveryCity, 
			b4nHeader.deliveryCounty, 
			b4nHeader.ccNumber,
 			batch.Courier, 
			h3giHeader.orderType AS PrePay, 
			registration.firstname, 
			registration.surname, 
			upgrade.BillingAccountNumber AS BAN
	FROM	@BatchOrderRefs batchOrderRef
			INNER JOIN h3giBatch batch
				ON batchOrderRef.batchId = batch.batchId
			INNER JOIN b4nOrderHeader b4nHeader
				ON b4nHeader.orderRef = batchOrderRef.orderRef
			INNER JOIN h3giOrderHeader h3giHeader
				ON h3giHeader.orderRef = batchOrderRef.orderRef
			INNER JOIN viewOrderAddress viewAddress 
				ON viewAddress.orderRef = batchOrderRef.orderRef
				AND viewAddress.addressType = 'Delivery'			
			LEFT OUTER JOIN h3giRegistration registration
				ON registration.orderRef = batchOrderRef.orderRef
			LEFT OUter JOIN h3giUpgrade upgrade
				ON upgrade.upgradeId = h3giHeader.upgradeId
	
	UNION	
	
	SELECT	batchOrderRef.batchId,
			batchOrderRef.orderRef,
			'' as deliveryForeName, --b4nHeader.deliveryForeName, 
			threeUpgrade.userName deliverySurName, --b4nHeader.deliverySurName, 
			CASE WHEN LEN(threeOrderUpgradeAddress.aptNumber) > 0 THEN threeOrderUpgradeAddress.aptNumber+ ' ' ELSE '' END +
			CASE WHEN LEN(threeOrderUpgradeAddress.houseNumber) > 0 THEN threeOrderUpgradeAddress.houseNumber + ' ' ELSE '' END +
			threeOrderUpgradeAddress.houseName AS deliveryAddr1, 
			threeOrderUpgradeAddress.street as deliveryAddr2, --b4nHeader.deliveryAddr2, 
			threeOrderUpgradeAddress.locality as deliveryAddr3, --b4nHeader.deliveryAddr3, 
			threeOrderUpgradeAddress.town as deliveryCity, --b4nHeader.deliveryCity, 
			b4nClassCodes.b4nClassDesc as deliveryCounty, --b4nHeader.deliveryCounty, 
			'' as ccNumber, --b4nHeader.ccNumber,
 			h3giBatch.Courier, --batch.Courier, 
			2 as PrePay, --h3giHeader.orderType AS PrePay, 
			'' as firstname, --registration.firstname, 
			'' as surname, --registration.surname, 
			'' as BAN --upgrade.BillingAccountNumber AS BAN
	FROM	@BatchOrderRefs batchOrderRef
			INNER JOIN h3giBatch
				ON batchOrderRef.batchId = h3giBatch.batchId
			INNER JOIN threeOrderUpgradeHeader
				ON threeOrderUpgradeHeader.orderRef = batchOrderRef.orderRef
			INNER JOIN threeOrderUpgradeParentHeader
				ON threeOrderUpgradeParentHeader.parentId = threeOrderUpgradeHeader.parentId
			INNER JOIN threeOrderUpgradeAddress
				ON threeOrderUpgradeAddress.parentId = threeOrderUpgradeParentHeader.parentId AND
				threeOrderUpgradeAddress.addressType = 'Delivery'
			LEFT JOIN b4nClassCodes
				ON b4nClassCodes.b4nClassSysID = 'SubCountry' AND b4nClassCodes.b4nClassCode = threeOrderUpgradeAddress.countyId
			INNER JOIN threeUpgrade
				ON threeUpgrade.upgradeId = threeOrderUpgradeHeader.upgradeId
	ORDER BY batchOrderRef.orderRef ASC

	DECLARE @BatchOrderRefs2 
	TABLE(batchId INT, orderRef INT, addedOrder INT, orderRefVar VARCHAR(50) PRIMARY KEY(batchId,orderRef))

	INSERT INTO @BatchOrderRefs2
	SELECT  batchOrder.batchId, batchOrder.orderRef, batchOrder.AddedOrder, CONVERT(VARCHAR(50), batchOrder.orderRef)
	FROM   h3giBatchOrder batchOrder 
	WHERE batchOrder.batchId = @BatchID

	SELECT	batchOrderRef.BatchID, 
			batchOrderRef.OrderRef, 
			b4nHeader.deliveryForeName, 
			b4nHeader.deliverySurName, 
			CASE WHEN LEN(viewAddress.apartmentNumber) > 0 THEN viewAddress.apartmentNumber + ' ' ELSE '' END +
			CASE WHEN LEN(viewAddress.houseNumber) > 0 THEN viewAddress.houseNumber + ' ' ELSE '' END +
			viewAddress.houseName AS deliveryAddr1, 			
			b4nHeader.deliveryAddr2, 
			b4nHeader.deliveryAddr3, 
			b4nHeader.deliveryCity, 
			b4nHeader.deliveryCounty, 
			b4nHeader.ccNumber,
			orderLine.productName, 
			orderLine.qty,
 			orderLine.Price, 
			orderLine.gen1 AS IMEI, 
			orderLine.gen2 AS SCCID, 
			batch.Courier, 
			h3giHeader.orderType AS PrePay, 
			registration.firstname, 
			registration.surname, 
			upgrade.BillingAccountNumber AS BAN, 
			catalogue.ProductType,
			ISNULL(tariffcatalogue.productName,'') as TariffName,
			h3giHeader.tariffRecurringPrice as TariffMonthlyPrice,
			h3giHeader.contractTerm as ContractLength,
			'0' as IsBusinessUpgrade
	FROM	@BatchOrderRefs2 batchOrderRef
			INNER JOIN h3giBatch batch
				ON batch.batchId = batchOrderRef.batchId
			INNER JOIN b4nOrderHeader b4nHeader
				ON b4nHeader.orderRef = batchOrderRef.orderRef
			INNER JOIN h3giOrderHeader h3giHeader
				ON h3giHeader.orderRef = batchOrderRef.orderRef			
			INNER JOIN viewOrderAddress viewAddress
				ON viewAddress.orderRef = batchOrderRef.orderRef
				AND viewAddress.addressType = 'Delivery'
			INNER JOIN h3gi_gm..gmOrderLine orderLine
				ON orderLine.orderRef = batchOrderRef.orderRefVar
				AND orderLine.retailerID = 60
			INNER JOIN h3giProductCatalogue catalogue
				ON catalogue.productFamilyId = orderLine.productId
				AND catalogue.catalogueVersionId = h3giHeader.catalogueVersionId
			LEFT OUTER JOIN h3giProductCatalogue tariffcatalogue
				ON tariffcatalogue.peoplesoftID = h3giHeader.tariffProductCode
				AND tariffcatalogue.catalogueVersionID = h3giHeader.catalogueVersionID			
			LEFT OUTER JOIN h3giRegistration registration
				ON registration.orderRef = batchOrderRef.orderRef
			LEFT OUTER JOIN h3giUpgrade upgrade WITH (NOLOCK)
				ON upgrade.upgradeId = h3giHeader.upgradeId
	WHERE catalogue.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')

	UNION 
	
	SELECT	batchOrderRef.BatchID, 
			batchOrderRef.OrderRef, 
			'' AS deliveryForeName, --b4nHeader.deliveryForeName, 
			threeUpgrade.userName as deliverySurName, --b4nHeader.deliverySurName, 
			CASE WHEN LEN(threeOrderUpgradeAddress.aptNumber) > 0 THEN threeOrderUpgradeAddress.aptNumber+ ' ' ELSE '' END +
			CASE WHEN LEN(threeOrderUpgradeAddress.houseNumber) > 0 THEN threeOrderUpgradeAddress.houseNumber + ' ' ELSE '' END +
			threeOrderUpgradeAddress.houseName AS deliveryAddr1, 
			threeOrderUpgradeAddress.street as deliveryAddr2, --b4nHeader.deliveryAddr2, 
			threeOrderUpgradeAddress.locality as deliveryAddr3, --b4nHeader.deliveryAddr3, 
			threeOrderUpgradeAddress.town as deliveryCity, --b4nHeader.deliveryCity, 
			b4nClassCodes.b4nClassDesc as deliveryCounty, --b4nHeader.deliveryCounty, 
			'' as ccNumber, --b4nHeader.ccNumber,
			orderLine.productName, 
			orderLine.qty,
 			orderLine.Price, 
			orderLine.gen1 AS IMEI, 
			orderLine.gen2 AS SCCID, 
			batch.Courier, 
			2 as PrePay, --h3giHeader.orderType AS PrePay, 
			'' as firstname, --registration.firstname, 
			'' as surname, --registration.surname, 
			'' as BAN, --upgrade.BillingAccountNumber AS BAN, 
			catalogue.ProductType,
			h3giPricePlanPackage.pricePlanPackageName as TariffName,
			threeOrderUpgradeHeader.totalMRC as TariffMonthlyPrice,
			threeOrderUpgradeHeader.contractDuration as ContractLength, --h3giHeader.contractTerm as ContractLength
			CASE WHEN threeOrderUpgradeHeader.orderRef IS NOT NULL THEN 1 END
	FROM	@BatchOrderRefs2 batchOrderRef
			INNER JOIN h3giBatch batch
				ON batch.batchId = batchOrderRef.batchId

			INNER JOIN threeOrderUpgradeHeader
				ON threeOrderUpgradeHeader.orderRef = batchOrderRef.orderRef
			INNER JOIN threeOrderUpgradeParentHeader
				ON threeOrderUpgradeParentHeader.parentId = threeOrderUpgradeHeader.parentId
			INNER JOIN threeOrderUpgradeAddress
				ON threeOrderUpgradeAddress.parentId = threeOrderUpgradeParentHeader.parentId AND
				threeOrderUpgradeAddress.addressType = 'Delivery'
			LEFT JOIN b4nClassCodes
				ON b4nClassCodes.b4nClassSysID = 'SubCountry' AND b4nClassCodes.b4nClassCode = threeOrderUpgradeAddress.countyId
			INNER JOIN threeUpgrade
				ON threeUpgrade.upgradeId = threeOrderUpgradeHeader.upgradeId
				
			INNER JOIN h3gi_gm..gmOrderLine orderLine
				ON orderLine.orderRef = batchOrderRef.orderRefVar
				AND orderLine.retailerID = 60
			INNER JOIN h3giProductCatalogue catalogue
				ON catalogue.productFamilyId = orderLine.productId
				AND catalogue.catalogueVersionId = threeOrderUpgradeHeader.catalogueVersionId
			INNER JOIN h3giPricePlanPackage
				ON h3giPricePlanPackage.pricePlanPackageID = threeOrderUpgradeHeader.childTariffId
				AND h3giPricePlanPackage.catalogueVersionID = threeOrderUpgradeHeader.catalogueVersionID			
	WHERE catalogue.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')





GRANT EXECUTE ON h3giGetDocketForBatch TO b4nuser
GO
GRANT EXECUTE ON h3giGetDocketForBatch TO ofsuser
GO
GRANT EXECUTE ON h3giGetDocketForBatch TO reportuser
GO
