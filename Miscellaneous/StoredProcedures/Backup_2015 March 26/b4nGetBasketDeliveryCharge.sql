

/****** Object:  Stored Procedure dbo.b4nGetBasketDeliveryCharge    Script Date: 23/06/2005 13:31:17 ******/



CREATE procedure dbo.b4nGetBasketDeliveryCharge
@nCustomerId int,
@nStoreId int,
@nCountryId int,
@nSubCountryId int,
@nDeliveryType int,
@nProductCount int,
@strShippingZones varchar(100)
as
set nocount on
begin

declare @sql varchar(2000)
declare @shippingzoneId int


--set @shippingzoneId =  ( select top 1 shippingzoneid from b4nDeliveryShippingZone with(nolock) where  shippingzoneid in @strShippingZones      order by increment asc ) 


set @sql = ' select z.shippingzoneid,z.description,z.increment,c.areaid,c.minCount,c.maxCount,c.deliveryCharge '
set @sql = @sql + '  from b4nDeliveryShippingZone z with(nolock), b4nDeliveryAreaShippingZone az with(nolock) '
set @sql = @sql + ' , b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)   , b4nDeliveryChargeType ct with(nolock)'
set @sql = @sql + ' where az.shippingzoneid = z.shippingzoneid '
set @sql = @sql + ' and a.countryId = ' + cast(@nCountryId as varchar(10)) 
set @sql = @sql + ' and a.subcountryId = ' + cast(@nSubCountryId as varchar(10))
set @sql = @sql + ' and c.chargeType = ' + cast( @nDeliveryType as varchar(10))

set @sql = @sql + ' AND ( (' + cast(@nProductCount as varchar(10)) + ' >= c.minCount) '
set @sql = @sql + ' and ( ' + cast(@nProductCount as varchar(10)) + '  <= c.maxCount) ) '
set @sql = @sql + ' AND c.maxCount <> 0 '
set @sql = @Sql + ' and ct.chargeType = c.chargeType '
set @sql = @sql + ' and ct.countType = ' + char(39) + 'product' + char(39)
set @sql = @sql + ' and z.shippingzoneid in  ' + @strShippingZones


--set @sql = @sql + ' and z.shippingzoneid in   ( select top 1 shippingzoneid from b4nDeliveryShippingZone with(nolock) where '
--set @sql = @sql + ' shippingzoneid in  ' + @strShippingZones   + '   order by increment asc ) '


set @sql = @sql + '  union ' 


set @sql = @sql + ' select z.shippingzoneid,z.description,z.increment,c.areaid,c.minCount,c.maxCount,c.deliveryCharge '
set @sql = @sql + '  from b4nDeliveryShippingZone z with(nolock), b4nDeliveryAreaShippingZone az with(nolock) '
set @sql = @sql + ' , b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)  , b4nDeliveryChargeType ct with(nolock)'
set @sql = @sql + ' where az.shippingzoneid = z.shippingzoneid '
set @sql = @sql + ' and a.countryId = ' + cast(@nCountryId as varchar(10)) 
set @sql = @sql + ' and a.subcountryId = ' + cast(@nSubCountryId as varchar(10))
set @sql = @sql + ' and c.chargeType = ' + cast( @nDeliveryType as varchar(10))
--set @sql = @sql + ' and z.shippingzoneid in  ' + @strShippingZones
set @sql = @sql + ' AND ( ( ' + cast(@nProductCount as varchar(10)) + ' >= c.minCount) )'
set @sql = @sql + ' AND c.maxCount = 0 '
set @sql = @sql + ' and ct.countType = ' + char(39) + 'product' + char(39)
set @sql = @Sql + ' and ct.chargeType = c.chargeType '
set @sql = @sql + ' and z.shippingzoneid in  ' + @strShippingZones


--set @sql = @sql + ' and z.shippingzoneid in   ( select top 1 shippingzoneid  from b4nDeliveryShippingZone with(nolock) where '
--set @sql = @sql + ' shippingzoneid in  ' + @strShippingZones   + '   order by increment asc ) '


set @sql = @sql + ' order by z.increment asc '


print(@sql)
exec(@sql)

end




GRANT EXECUTE ON b4nGetBasketDeliveryCharge TO b4nuser
GO
GRANT EXECUTE ON b4nGetBasketDeliveryCharge TO helpdesk
GO
GRANT EXECUTE ON b4nGetBasketDeliveryCharge TO ofsuser
GO
GRANT EXECUTE ON b4nGetBasketDeliveryCharge TO reportuser
GO
GRANT EXECUTE ON b4nGetBasketDeliveryCharge TO b4nexcel
GO
GRANT EXECUTE ON b4nGetBasketDeliveryCharge TO b4nloader
GO
