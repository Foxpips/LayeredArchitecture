

/****** Object:  Stored Procedure dbo.b4nGetOrderDetailsEmail    Script Date: 23/06/2005 13:31:55 ******/

CREATE procedure dbo.b4nGetOrderDetailsEmail
@orderref int

/**********************************************************************************************************************
**									
** Change Control	:	19.11.2004 - John Hannon modified this sp in 3G to bring back promotional line items too
**						
**********************************************************************************************************************/

as
begin
select o.*
from b4norderheader o with(nolock)
where o.orderref = @orderref


select l.OrderLineID,
l.storeid,l.OrderRef,l.ProductID,l.Quantity,cast(l.Instructions as varchar(8000)),l.Price,l.createDate,l.modifyDate,l.itemName,
l.giftWrappingTypeId,l.giftWrappingDescription,l.giftWrappingCost,l.gen1,l.gen2,l.gen3,l.gen4,l.gen5,
l.gen6,
cast(apf.attributevalue as varchar(8000)) as productName
from b4norderline l with(nolock), b4nproduct p with(nolock), b4nproductfamily f with(nolock), b4nattribute a with(nolock)
, b4nattributeproductfamily apf with(nolock)
where l.orderref = @orderref
and l.productid = p.productid 
and f.productfamilyid = p.productfamilyid
and a.attributeid = '2'
and apf.attributeid = a.attributeid
and apf.productfamilyid = f.productfamilyid
union
select l.OrderLineID,
l.storeid,l.OrderRef,l.ProductID,l.Quantity,cast(l.Instructions as varchar(8000)),l.Price,l.createDate,l.modifyDate,l.itemName,
l.giftWrappingTypeId,l.giftWrappingDescription,l.giftWrappingCost,l.gen1,l.gen2,l.gen3,l.gen4,l.gen5,
l.gen6,
l.itemname as productName
from b4norderline l with(nolock)
where l.orderref = @orderref
and l.productid < 0
order by l.orderlineid asc

end






GRANT EXECUTE ON b4nGetOrderDetailsEmail TO b4nuser
GO
GRANT EXECUTE ON b4nGetOrderDetailsEmail TO helpdesk
GO
GRANT EXECUTE ON b4nGetOrderDetailsEmail TO ofsuser
GO
GRANT EXECUTE ON b4nGetOrderDetailsEmail TO reportuser
GO
GRANT EXECUTE ON b4nGetOrderDetailsEmail TO b4nexcel
GO
GRANT EXECUTE ON b4nGetOrderDetailsEmail TO b4nloader
GO
