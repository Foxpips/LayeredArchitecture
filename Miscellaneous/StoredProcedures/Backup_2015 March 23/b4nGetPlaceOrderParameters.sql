

/****** Object:  Stored Procedure dbo.b4nGetPlaceOrderParameters    Script Date: 23/06/2005 13:31:55 ******/
/*													  */
/* Change Control	:	05/07/2005 Kevin Roche - Modified to use versioning of catalogue 		  *													  */
/** Change Control	:	18/01/2006 - John Hannon updated this stored procedure to fix bug. */
/*				Since a new tariff with a priceplanpackageid 10 has been added, the following 
**				where clause will cause an error, since
**				left(10,1) gives 1 instead of 10 which we need
**										
**				and left(f.attributevalue,1) = ppp.priceplanpackageid
**
**				Changed to 	
**				
**				and f.attributevalue = ppp.priceplanpackageid		
**Change Control	:	31/01/2007 - Adam Jasinski	- added PricePlanId to the result set	
**			:	13/02/2007 - Attila Pall	- added deliverycharge to the result set
**	
**********************************************************************************************************/


--PhoneProductCode -- Shop4Now productid (varchar 20)
--TariffProductCode -- peoplesoft internal id for TARIFF, from h3giProductCatalogue (varchar 20)
--BillingTariffID -- productbillingId for TARIFF from h3giProductCatalogue (varchar 20)
--TariffRecurringPrice -- productrecurringprice for TARIFF in h3giProductCatalogue (money)
--DiscountPriceChargeCode -- charge code for TARIFF in h3giPricePlanPackageDetail (varchar 25)
--BasePriceChargeCode -- productChargeCode for HANDSET in h3giProductCatalogue (varchar 25)
--pricePlanPackageID -- h3giPricePlanPackageDetail (int)
--catalogueVersionID -- from h3giProductCatalogue (smallint)



CREATE            proc dbo.b4nGetPlaceOrderParameters
@CustomerID	int
AS
Begin


Declare @CatalogueVersion int

set @CatalogueVersion = (select catalogueVersionID from h3giCatalogueVersion where activeCatalog = 'Y')


CREATE table #tParameters
(
	customerid		int,
	attributerowid		int,
	phoneProductCode	varchar(20),
	tariffProductCode	varchar(20),
	billingTariffID		varchar(20),
	tariffRecurringPrice	money,
	productDeliveryCharge	money,
	discountPriceChargeCode varchar(25),
	basePriceChargeCode	varchar(25),
	pricePlanID		int,
	pricePlanPackageID	int,
	catalogueVersionID	smallint,
	catalogueProductIDHandset	int,
	catalogueProductIDTariff	int
)

insert into #tParameters(customerid,attributerowid,phoneProductCode,basePriceChargeCode,discountPriceChargeCode,pricePlanId,pricePlanPackageID,catalogueVersionID,catalogueProductIDHandset, productDeliveryCharge)
select 	customerid,
	f.attributerowid,
	b.productid,
	pc.productchargecode,
	pgpp.chargeCode,
	ppp.pricePlanId,
	--left(f.attributevalue,1),
	f.attributevalue,
	@CatalogueVersion,
	pc.catalogueProductId as catalogueProductIDHandset,
	pgpp.deliveryCharge
from 	b4nbasket b with(nolock)
	inner join b4nbasketattribute ba with(nolock)
		on ba.basketId = b.basketId
	inner join b4nattributeproductfamily f with(nolock)
		on f.productfamilyid = b.productid
		and f.attributeRowId = ba.attributeRowId
	inner join h3giProductCatalogue pc with(nolock)
		on pc.productFamilyID = f.productfamilyid
		and pc.catalogueversionID = @CatalogueVersion
 	inner join h3giPricePlanPackageDetail pppd with(nolock)
		on pppd.catalogueProductID = pc.catalogueProductID
		and CAST(pppd.pricePlanPackageId as varchar(20)) = f.attributevalue
		and pppd.catalogueVersionId = @CatalogueVersion
	inner join h3giPricePlanPackage ppp
		on ppp.catalogueVersionId = @CatalogueVersion
		and ppp.priceplanpackageID = pppd.priceplanpackageID
	left outer join h3giPriceGroupPackagePrice pgpp
		on pgpp.pricePlanPackageDetailId = pppd.pricePlanPackageDetailId
		and pgpp.catalogueVersionId = @CatalogueVersion
		and pgpp.priceGroupId = f.priceGroupId
where b.customerid = @customerID


/*GET PRICEPLAN INFORMATION*/
Update #tParameters

Set 	tariffProductCode = pc.peoplesoftid, 
	billingtariffId = pc.productbillingid,
	tariffrecurringprice = pc.productrecurringprice,	catalogueProductIDTariff = pc.catalogueProductID

From  	h3giPricePlanPackageDetail pppd, h3giProductCatalogue pc

Where 	pppd.priceplanpackageID = #tParameters.priceplanpackageID
and 	pppd.catalogueProductID = pc.catalogueProductID
and 	pc.producttype = 'TARIFF'
and	pc.catalogueVersionID = @catalogueVersion

Select 	phoneProductCode,
	tariffProductCode,
	billingTariffID,
	tariffRecurringPrice,
	productDeliveryCharge,
	DiscountPriceChargeCode,
	basePriceChargeCode,
	pricePlanID,
	pricePlanPackageID,
	catalogueVersionID 
From #tParameters


End






GRANT EXECUTE ON b4nGetPlaceOrderParameters TO b4nuser
GO
GRANT EXECUTE ON b4nGetPlaceOrderParameters TO ofsuser
GO
GRANT EXECUTE ON b4nGetPlaceOrderParameters TO reportuser
GO
