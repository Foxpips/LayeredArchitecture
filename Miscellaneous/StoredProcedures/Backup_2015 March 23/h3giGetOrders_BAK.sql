









/******************************************************************************************************
*
*	Change Control:	17/05/2005 - Gearóid Healy - Modified to read SLA value from b4nSysDefaults
*			03/06/2005 - Kevin Roche   - Modified for retailer channel
*			05/07/2005 - Gearóid Healy - bug fix from join on smapplicationusers
*			08/07/2005 - Gearóid Healy - brings back retailer name, and not store also
*			11/07/2005 - Kevin Roche   - eliminate rowcount for retailer queues
*			13/07/2005 - Kevin Roche   - Modified to limit results to 48hours
*
*******************************************************************************************************/

CREATE                     procedure dbo.h3giGetOrders_BAK (
@Type as varchar(20),
@Future as bit,
@channel as varchar(20)='',
@retailerCode as varchar(20) = '',
@storeCode as varchar(20) = ''
)
as

declare @waiting 		as int
declare @exceedingSLA 		as int
declare @status 		as int
declare @sql 			as nvarchar(4000)
declare @max 			as int
declare @ExceedingSLAMins	as int
declare @retChannelCode		as varchar(20)

select @max = idValue from b4nsysdefaults with(nolock) where idName = 'MaxOrdersInQueue'

select @ExceedingSLAMins = idValue from b4nsysdefaults with(nolock) where idName = 'exceedingSLA'

select @retChannelCode = channelCode from h3giChannel with(nolock) where channelName = '3rd Party Retail'


if (@channel <> 'retailer')
	set rowcount @max

set @status = dbo.fn_GetStatusCode(@Type)

set @sql = 'select @waiting = count(*)'
set @sql = @sql + 'from b4nOrderheader o with(nolock) '
set @sql = @sql + 'join h3giOrderHeader h with(nolock) on h.orderref = o.orderref '

if(@Type = 'all')
	set @sql = @sql + 'where o.status = o.status '	
else
	set @sql = @sql + 'where o.status = @status '

if (@channel = 'retailer')
Begin
	set @sql = @sql + ' and h.channelcode = ' + char(39) + @retChannelCode + char(39) + ' '
	set @sql = @sql + ' and o.orderdate > '+ char(39) + cast(dateadd(dd,-2,getdate()) as varchar(25)) + char(39) + ' '
			
	if(@storeCode <> '')	
		Begin
		set @sql = @sql + ' and h.retailercode = ' + char(39) + @retailerCode + char(39) + ' '
		set @sql = @sql + ' and h.storecode = ' + char(39) + @storeCode + char(39) + ' '		
		End
	
End
else
Begin
	set @sql = @sql + ' and h.channelcode <> ' + char(39) + @retChannelCode + char(39) + ' '

	if (@Type = 'pending' or @Type = 'declinedcallback') and @future = 1
		set @sql = @sql + ' and CallbackDate > getdate() '
	else if (@Type = 'pending' or @Type = 'declinedcallback') and @future = 0
		set @sql = @sql + ' and CallbackDate <= getdate() '
End
	
exec sp_executesql @sql, N'@waiting int out, @status int', @waiting out, @status

if @Type = 'ordered'
begin
	select  @exceedingSLA = count(*) 
	from b4nOrderheader o with(nolock) 
	join h3giOrderHeader h with(nolock) on h.orderref = o.orderref
	where o.status = @status
	and datediff(mi, o.OrderDate, getDate()) > @ExceedingSLAMins
end
else
begin 
	set @exceedingSLA = 0
end

select @waiting as waiting, @exceedingSLA as exceedingSLA


set @sql = 'select u.userName as lock, o.orderref, o.billingForename as forename, h.initials, o.billingSurname as surname,  '
set @sql = @sql + 'h.billinghousename as housename, h.billinghousenumber as housenumber, o.billingAddr1 as address1, o.billingAddr2 as address2, o.billingAddr3 as address3, '
set @sql = @sql + 'o.billingCity as city, o.billingCounty as county, o.billingCountry as country, o.orderdate, h.channelCode, h.CallbackDate, '
set @sql = @sql + 'c.channelname as channel, h.channelCode, h.retailerCode, h.storeCode, o.status, cc.b4nclassdesc, r.retailername as nameofuser '
set @sql = @sql + 'from b4nOrderheader o with(nolock) '
set @sql = @sql + 'join h3giOrderHeader h with(nolock) on h.orderref = o.orderref '
set @sql = @sql + 'left join h3gilock l with(nolock) on o.orderref = l.orderID '
set @sql = @sql + 'left join smApplicationUsers u with(nolock) on u.userId = l.userId '
set @sql = @sql + 'left join b4nClassCodes cc with(nolock) on cc.b4nClassSysID = ' + char(39) + 'StatusCode' + char(39) + ' and cc.b4nclasscode = o.status '
set @sql = @sql + 'left join h3gichannel c with(nolock) on c.channelcode = h.channelcode '
set @sql = @sql + 'left outer join h3giretailer r with(nolock) on r.retailercode = h.retailercode '
set @sql = @sql + 'left outer join h3giretailerstore rs with(nolock) on rs.storecode = h.storecode '


if(@Type = 'all')
	set @sql = @sql + 'where o.status = o.status '	
else
	set @sql = @sql + 'where o.status = ' + cast(@status as varchar)

if (@channel = 'retailer')
Begin
	set @sql = @sql + ' and h.channelcode = ' + char(39) + @retChannelCode + char(39) + ' '
	set @sql = @sql + ' and h.retailercode <> ' + char(39) +  char(39) + ' '
	set @sql = @sql + ' and h.storecode <> ' + char(39) +  char(39) + ' '
	set @sql = @sql + ' and o.orderdate > '+ char(39) + cast(dateadd(dd,-2,getdate()) as varchar(25)) + char(39) + ' '	
	
		
	if(@storeCode <> '')	
		Begin
		set @sql = @sql + ' and h.retailercode = ' + char(39) + @retailerCode + char(39) + ' '
		set @sql = @sql + ' and h.storecode = ' + char(39) + @storeCode + char(39) + ' '
		End
End 
else
Begin
	set @sql = @sql + ' and h.channelcode <> ' + char(39) + @retChannelCode + char(39) + ' '

	if (@Type = 'pending' or @Type = 'declinedcallback') and @future = 1
		set @sql = @sql + ' and CallbackDate > getdate() '
	else if (@Type = 'pending' or @Type = 'declinedcallback') and @future = 0
		set @sql = @sql + ' and CallbackDate <= getdate() '
End



if @Type = 'ordered'
	set @sql = @sql + ' order by o.orderdate asc '
else if @Type = 'declinedcallback' or @Type = 'pending'
	set @sql = @sql + ' order by h.CallbackDate asc'
else if @Type= 'all'
	set @sql = @sql + ' order by o.orderdate asc '
	

exec (@sql)

select idValue as RefreshSeconds from b4nsysdefaults with(nolock) where idName = 'QueueRefresh'




GRANT EXECUTE ON h3giGetOrders_BAK TO b4nuser
GO
GRANT EXECUTE ON h3giGetOrders_BAK TO helpdesk
GO
GRANT EXECUTE ON h3giGetOrders_BAK TO ofsuser
GO
GRANT EXECUTE ON h3giGetOrders_BAK TO reportuser
GO
GRANT EXECUTE ON h3giGetOrders_BAK TO b4nexcel
GO
GRANT EXECUTE ON h3giGetOrders_BAK TO b4nloader
GO
