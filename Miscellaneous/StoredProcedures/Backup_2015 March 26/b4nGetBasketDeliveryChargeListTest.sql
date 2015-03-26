

/****** Object:  Stored Procedure dbo.b4nGetBasketDeliveryChargeListTest    Script Date: 23/06/2005 13:31:23 ******/

CREATE procedure dbo.b4nGetBasketDeliveryChargeListTest
@nCustomerId int,
@nStoreId int,
@nCountryId int,
@nSubCountryId int,
@nDeliveryTypeId int,
@nSpecialDateId int =0
as
set nocount on
begin


create table #deliverytable
(
areaid int,
minCount real,
maxCount real,
deliveryCharge real,
 deliverydescription varchar(100),
locationdescription varchar(100),
countryid int,
subcountryid int
)


declare @nChargeTypeId int
declare @nProductCount real
declare @countType varchar(50)
declare @basketTotalPrice real


set @basketTotalPrice =

(

select sum(  isnull(cast(apf.attributevalue as real),0) * b.quantity) 
from b4nattributeproductfamily apf with(nolock),b4nbasket b with(nolock),
b4nproduct p with(nolock)
where b.customerid = @nCustomerId
and b.storeid = @nStoreId
and p.productid = b.productid
and apf.productfamilyid = p.productfamilyid
and apf.attributeid = 19
)


set @nChargeTypeId = isnull( (select top 1 a.attributevalue 
from b4nbasket b with(nolock), b4nproduct p with(nolock), b4nproductfamily f with(nolock),
b4nattributeproductfamily a with(nolock), b4ndeliverychargetype ct with(nolock)
where b.customerid = @nCustomerId
and b.storeid = @nStoreId
and p.productid = b.productid 
and f.productfamilyid = p.productfamilyid
and a.productfamilyid = f.productfamilyid
and a.attributeid = 12
and ct.chargeTypeId = a.attributevalue
order by ct.priority asc),1)

set @countType = (select top 1 counttype from b4ndeliverychargetype with(nolock) where chargeTypeid = @nChargeTypeId)

if (@countType = 'product')
begin
set @nProductCount = (select sum(quantity) from b4nbasket witH(nolock)
where customerid = @nCustomerId and storeid = @nStoreId)
end

if (@countType = 'weight')
begin
set @nProductCount = 
(
select sum(    b.quantity *   cast(a.attributevalue as real))
from b4nbasket b with(nolock), b4nproduct p with(nolock), b4nproductfamily f with(nolock),
b4nattributeproductfamily a with(nolock), b4ndeliverychargetype ct with(nolock)
where b.customerid = @nCustomerId
and b.storeid = @nStoreId
and p.productid = b.productid 
and f.productfamilyid = p.productfamilyid
and a.productfamilyid = f.productfamilyid
and a.attributeid = 67
and ct.chargeTypeId = @nChargeTypeId
)
end

if (@nSpecialDateId > 0)
	begin
	insert into #deliverytable
	 select c.areaid,c.minCount,c.maxCount,c.deliveryCharge ,ct.description as deliverydescription,at.description as locationdescription,a.countryid,a.subcountryid
	  from b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)   , b4nDeliveryChargeType ct with(nolock)
	,b4ndeliverytype dt witH(nolock),b4ndeliveryareatype at with(nolock)
	 where a.countryId = @nCountryId
	 and  isnull(a.subcountryId,1) = @nSubCountryId 
	 and c.chargeTypeid = @nChargeTypeId 
	 AND (( @nProductCount  >= c.minCount) 
	 and (@nProductCount    <= c.maxCount) ) 
	 AND c.maxCount <> 0 
	 and ct.chargeTypeid = c.chargeTypeid
	 and ct.countType = @countType
	and dt.deliverytypeid = @nDeliveryTypeId
	and c.deliverytypeid = dt.deliverytypeid
	and c.areaid = a.areaid
	and at.areaid = a.areaid
	and c.specialdateid = @nSpecialDateId
	
	  union 
	
	 select c.areaid,c.minCount,c.maxCount,c.deliveryCharge,ct.description as deliverydescription,at.description as locationdescription,a.countryid,a.subcountryid
	  from b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)  , b4nDeliveryChargeType ct with(nolock)
	,b4ndeliverytype dt witH(nolock),b4ndeliveryareatype at with(nolock)
	 where  a.countryId = @nCountryId 
	 and a.subcountryId =@nSubCountryId 
	 and c.chargeTypeid = @nChargeTypeId 
	 AND ( @nProductCount  >= c.minCount)
	 AND c.maxCount = 0 
	 and ct.countType =  @countType
	 and ct.chargeTypeid = c.chargeTypeid
	and dt.deliverytypeid = @nDeliveryTypeId
	and c.deliverytypeid = dt.deliverytypeid
	and c.areaid = a.areaid
	and at.areaid = a.areaid
	and c.specialdateid = @nSpecialDateId
	end
else
	begin

insert into #deliverytable
	select c.areaid,c.minCount,c.maxCount,c.deliveryCharge ,ct.description as deliverydescription,at.description as locationdescription,a.countryid,a.subcountryid
	  from b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)   , b4nDeliveryChargeType ct with(nolock)
	,b4ndeliverytype dt witH(nolock),b4ndeliveryareatype at with(nolock)
	 where a.countryId = @nCountryId
	 and  isnull(a.subcountryId,1) = @nSubCountryId 
	 and c.chargeTypeid = @nChargeTypeId 
	 AND (( @nProductCount  >= c.minCount) 
	 and (@nProductCount    <= c.maxCount) ) 
	 AND c.maxCount <> 0 
	 and ct.chargeTypeid = c.chargeTypeid
	 and ct.countType = @countType
	and dt.deliverytypeid = @nDeliveryTypeId
	and c.deliverytypeid = dt.deliverytypeid
	and c.areaid = a.areaid
	and at.areaid = a.areaid
	and c.specialdateid is null

	  union 
	
	 select c.areaid,c.minCount,c.maxCount,c.deliveryCharge,ct.description as deliverydescription,at.description as locationdescription,a.countryid,a.subcountryid
	  from b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)  , b4nDeliveryChargeType ct with(nolock)
	,b4ndeliverytype dt witH(nolock),b4ndeliveryareatype at with(nolock)
	 where  a.countryId = @nCountryId 
	 and a.subcountryId =@nSubCountryId 
	 and c.chargeTypeid = @nChargeTypeId 
	 AND ( @nProductCount  >= c.minCount)
	 AND c.maxCount = 0 
	 and ct.countType = @countType
	 and ct.chargeTypeid = c.chargeTypeid
	and dt.deliverytypeid = @nDeliveryTypeId
	and c.deliverytypeid = dt.deliverytypeid
	and c.areaid = a.areaid
	and at.areaid = a.areaid
	and c.specialdateid is null
	end

/*
update #deliverytable
set deliverycharge = 0
where deliverycharge >= 1000
*/

if @basketTotalPrice >= 1000
begin
update #deliverytable
set deliverycharge = 0

end

--DUBLIN
--Flat fee of €12 for any order under €170
---Over €170: free delivery
if (@nCountryId = 105 and @nSubCountryId = 1)
begin
	if ( @basketTotalPrice < 170)
	begin
		update #deliverytable
		set deliverycharge = 12
	end
	else
	begin
		update #deliverytable
		set deliverycharge = 0
	end
end
/*

REST OF IRELAND/NI
Flat fee of €12 for any order under €170
For orders over €170 but below €1,000: flat fee of €20
Orders over €1,000: free delivery

*/
-- ireland outside dublin
if (@nCountryId = 105 and @nSubCountryId != 1)
begin
		if ( @basketTotalPrice < 170)
	begin
		update #deliverytable
		set deliverycharge = 12
	end
	
	if ( @basketTotalPrice >= 170 and @basketTotalPrice < 1000)
	begin
		update #deliverytable
		set deliverycharge = 20
	end
end


if (@nCountryId = 1 )  -- northern ireland
begin
		if ( @basketTotalPrice < 170)
	begin
		update #deliverytable
		set deliverycharge = 12
	end
	
	if ( @basketTotalPrice >= 170 and @basketTotalPrice < 1000)
	begin
		update #deliverytable
		set deliverycharge = 20
	end
end



select *,@basketTotalPrice as basketprice from #deliverytable

end





GRANT EXECUTE ON b4nGetBasketDeliveryChargeListTest TO b4nuser
GO
GRANT EXECUTE ON b4nGetBasketDeliveryChargeListTest TO helpdesk
GO
GRANT EXECUTE ON b4nGetBasketDeliveryChargeListTest TO ofsuser
GO
GRANT EXECUTE ON b4nGetBasketDeliveryChargeListTest TO reportuser
GO
GRANT EXECUTE ON b4nGetBasketDeliveryChargeListTest TO b4nexcel
GO
GRANT EXECUTE ON b4nGetBasketDeliveryChargeListTest TO b4nloader
GO
