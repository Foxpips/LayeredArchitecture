





/******************************************************************************************************  
*  
*Change Control:17/05/2005 - Gearóid Healy - Modified to read SLA value from b4nSysDefaults  
*	03/06/2005 - Kevin Roche   - Modified for retailer channel  
*	05/07/2005 - Gearóid Healy - bug fix from join on smapplicationusers  
*	08/07/2005 - Gearóid Healy - brings back retailer name, and not store also  
*	11/07/2005 - Kevin Roche   - eliminate rowcount for retailer queues  
*	13/07/2005 - Kevin Roche   - Modified to limit results to 48hours  
*	22/08/2005 - Gearóid Healy - Modified to allow retailer orders up to 72 hours old  
*	15/03/2006 - Peter Murphy  - Link to b4nOrderHistory for orders 72 hours after credit approval  
*	07/04/2006 - Niall Carroll - Fixed bug where no retailer orders where appearing in credit approval  
*	18/04/2006 - Peter Murphy  - Only select Contract orders in this sproc.  PrePay removed.  
*	14/06/2006 - Peter Murphy  - Allow Web orders to be queued - Fraud changes  
*	23/10/2006 - Peter Murphy  - BUG!  Removed lines "and VOP.PrePay = 0"  
*	07/12/2006 - Peter Murphy  - BUG!  Orders were not showing in review credit decision queue.  Added status 300 for "awaiting credit check"  
*	28/03/2007 - Attila Pall   - Added Awaiting Deposit status to viewtype All   
*	13/03/2007 - Adam Jasinski - Added Own Retail channel support  
*	26/02/2008 - Adam Jasinski - Added OrderType (aka VOP.Prepay) to the output list  
*	29/08/2008 - Adam Jasinski - Added a delay for 'ordered' type for direct orders  
*	22/10/2008 - Adam Jasinski - Removed 'waiting' and 'exceedingSLA' result set (we don't need to run the same query twice!) Added new column 'isExceedingSLA' to the main result set.  
*	28/10/2008 - Adam Jasinski - Added new queue type ('orderedPrepay')  
*	05/12/2008 - Stephen Quin  - Fulfilled orders will now appear in the orderPrepay queue  
*	10/11/2010 - Stephen Quin  - Telesales/Distance Prepay orders will now appear in declined callback queue
*	26/07/2011 - Stephen Quin  - Removed the join to viewOrderPhone
*	05/09/2011 - Gearoid Healy - changed order type for retailer to be 0 or 1 to include prepay handsets in linked orders with contract handsets
*   27/02/2012 - Stephen Quin  - tweak to Gearoids change where only prepay orders that have been
*								 credit checked (and were therefore placed as part of a contract linked order)
*								 will be returned
*	06/03/2013 - Stephen King  - Added click and collect type
*	27/07/2013 - Stephen King  - Added filter on click and collect for own or 3rd party
*	30/08/2013 - Simon Markey  - Changed the retail credit/fops queue to return orders in last 15 days instead of 5
*	03/09/2013 - Simon Markey  - Changed retail/fops queue date back to 10 instead of 15
*	05/12/2013 - Smarkey	   - Increased queue size
*******************************************************************************************************/  
  

  
  
CREATE procedure [dbo].[h3giGetOrders]
(  
	@Type as varchar(20),  
	@Future as bit = 0,  
	@channel as varchar(20)='',  
	@retailerCode as varchar(20) = '',  
	@storeCode as varchar(20) = '',  
	@max int = 1000  
)  
as  
begin  
	SET NOCOUNT ON;  
  
	declare @waiting   as int  
	declare @exceedingSLA   as int  
	declare @status   as int  
	declare @sql    as nvarchar(4000)  
	declare @retChannelCodeList  as varchar(255)  
	declare @timeNow datetime   
  
	set @timeNow = getdate()  
	
	if (@channel = 'web')  
	begin   
		select @retChannelCodeList = '(' + char(39) + channelCode + char(39) + ')'   
		from h3giChannel with(nolock) where channelName = 'Web'   
	end  
	else if (@channel = 'distance')  
	begin  
		select @retChannelCodeList = '(' + char(39) + channelCode + char(39) + ')'   
		from h3giChannel with(nolock) where channelName = 'Distance Reseller'  
	end  
	else if (@channel = 'telesales')  
	begin  
		select @retChannelCodeList = ' (' + char(39) + channelCode + char(39)  
		from h3giChannel with(nolock) where channelName = '3rd Party Retail'   
		
		select @retChannelCodeList = @retChannelCodeList + ',' + char(39) + channelCode + char(39)  
		from h3giChannel with(nolock) where channelName = 'Own Retail'   
		
		select @retChannelCodeList = @retChannelCodeList + ',' + char(39) + channelCode + char(39) + ') '   
		from h3giChannel with(nolock) where channelName = 'Distance Reseller'  
	end  
	else  
	begin  
		select @retChannelCodeList = ' (' + char(39) + channelCode + char(39)  
		from h3giChannel with(nolock) where channelName = '3rd Party Retail'   
		
		select @retChannelCodeList = @retChannelCodeList + ',' + char(39) + channelCode + char(39) + ') '   
		from h3giChannel with(nolock) where channelName = 'Own Retail'   
	end  
  
  
  
  
	set @status = dbo.fn_GetStatusCode(@Type)  
	
	set @sql = 'select top ' + str(@max)  
	set @sql = @sql + ' u.userName as lock, o.orderref, o.billingForename as forename, h.initials, o.billingSurname as surname,  '  
	set @sql = @sql + 'h.billinghousename as housename, h.billinghousenumber as housenumber, o.billingAddr1 as address1, o.billingAddr2 as address2, o.billingAddr3 as address3, '  
	set @sql = @sql + 'o.billingCity as city, o.billingCounty as county, o.billingCountry as country, o.orderdate, h.channelCode, h.CallbackDate, '  
	set @sql = @sql + 'c.channelname as channel, h.channelCode, h.retailerCode, h.storeCode, o.status, cc.b4nclassdesc as statusDesc, r.retailername as nameofuser, od.depositAmount, h.orderType, o.ccNumber, '  
	
	if(@Type = 'fopsAwaiting')
		set @sql = @sql + ' dbo.fnIsExceedingSLA(@Type, h.channelCode, oh.statusDate, @timeNow) as isExceedingSLA '  
	else
		set @sql = @sql + ' dbo.fnIsExceedingSLA(@Type, h.channelCode, o.orderDate, @timeNow) as isExceedingSLA '  
		
	set @sql = @sql + 'from b4nOrderheader o with(nolock) '  
	set @sql = @sql + 'join h3giOrderHeader h with(nolock) on h.orderref = o.orderref '  
	set @sql = @sql + 'left join h3gilock l with(nolock) on o.orderref = l.orderID '  
	set @sql = @sql + 'left join smApplicationUsers u with(nolock) on u.userId = l.userId '  
	set @sql = @sql + 'left join b4nClassCodes cc with(nolock) on cc.b4nClassSysID = ' + char(39) + 'StatusCode' + char(39) + ' and cc.b4nclasscode = o.status '  
	set @sql = @sql + 'left join h3gichannel c with(nolock) on c.channelcode = h.channelcode '  
	set @sql = @sql + 'left outer join h3giretailer r with(nolock) on r.retailercode = h.retailercode '  
	set @sql = @sql + 'left outer join h3giretailerstore rs with(nolock) on rs.storecode = h.storecode '  
	set @sql = @sql + 'left outer join h3giOrderDeposit od with(nolock) on od.orderref = h.orderref '    
  
  
	-- Peter Murphy - added to allow selection of the correct date from the order history table --  
	if(@channel = 'retailer'  or @channel = 'web')  
	BEGIN  
		SET @SQL = @SQL + 'right outer join b4nOrderHistory OH on OH.orderRef = o.orderRef '  
		SET @SQL = @SQL + 'AND OH.orderStatus = o.status '  
	END
	
	if(@Type = 'fopsAwaiting')
	begin
		set @SQL = @SQL + 'right outer join b4nOrderHistory OH on OH.orderRef = o.orderRef and oh.orderStatus = o.status '
	end
  
	if(@Type = 'all')  
		set @SQL = @SQL + ' where o.Status in (311, 312, 305, 306, 302, 300, 402, 404, 500, 502, 505, 506) '  
	else if (@Type = 'ordered')  
		set @sql = @sql + 'where o.status in (' + cast(@status as varchar) + ', 404) '  
	else if (@Type = 'orderedPrepay')  
		set @sql = @sql + 'where o.status in (' + cast(@status as varchar) + ', 500, 501, 502, 505, 506, 311, 312) '  
	else if (@Type = 'clickandcollect')
		set @sql = @sql + 'where o.status in (  300, 301, 302, 305, 402, 403, 404, 311, 312)' 
	else  
		set @sql = @sql + 'where o.status = ' + cast(@status as varchar)  
  
	if(@Type IN ('fopsAwaiting', 'fopsUnderReview', 'declinedcallback'))  
		set @sql = @sql + ' and h.orderType IN (0, 1) '  
	else if(@Type = 'orderedPrepay')  
		set @sql = @sql + ' and h.orderType = 1 '
	else if(@Type = 'clickandcollect')
		set @sql = @sql --Stephen King - Dont know what to put in here
	else  
	begin  
		--Peter Murphy - defect 639  
		if(@channel = 'retailer')  
			set @sql = @sql + ' and (h.orderType = 0 or (h.orderType = 1 and exists (select h2.orderref from b4nOrderHeader h2 where h2.orderRef = o.OrderRef and h2.status in (300,311))))'
		else if(@channel = 'web')  
			set @sql = @sql + ' and h.orderType in (1, 3) '  
		else  
			set @sql = @sql + ' and h.orderType = 0 '  
	end  
  
	if (@channel = 'retailer' or @channel = 'web')  
	Begin  
		set @sql = @sql + ' and h.channelcode in ' + @retChannelCodeList  
  
		if(@channel = 'retailer')  
		begin  
		if (@Type = 'clickandcollect')
		begin
		set @sql = @sql + ' and h.retailercode = ' + char(39) + @retailerCode + char(39) + ' '  
		set @sql = @sql + ' and h.storecode = ' + char(39) + @storeCode + char(39) + ' ' 
		set @sql = @sql + ' and h.retailercode <> ' + char(39) +  char(39) + ' '  
			set @sql = @sql + ' and h.storecode <> ' + char(39) +  char(39) + ' '  
  			set @sql = @sql + ' and ((OH.orderStatus in (  300, 301, 302, 305, 402, 403, 404, 311, 312) AND OH.statusDate > '+ char(39) + cast(dateadd(dd,-7,getdate()) as varchar(25)) + char(39)  + ' )) '  
		end
		else
		begin
			set @sql = @sql + ' and h.retailercode <> ' + char(39) +  char(39) + ' '  
			set @sql = @sql + ' and h.storecode <> ' + char(39) +  char(39) + ' '  
  			set @sql = @sql + ' and ((OH.orderStatus in (312) AND OH.statusDate > '+ char(39) + cast(dateadd(dd,-10,getdate()) as varchar(25)) + char(39)  + ' ) '  
			set @sql = @sql + ' OR (OH.orderStatus not in (312) AND OH.statusDate > '+ char(39) + cast(dateadd(dd,-30,getdate()) as varchar(25)) + char(39) + ' ) OR OH.StatusDate IS NULL)'  
		end  
		end
		if(@storeCode <> '')   
		Begin  
			set @sql = @sql + ' and h.retailercode = ' + char(39) + @retailerCode + char(39) + ' '  
			set @sql = @sql + ' and h.storecode = ' + char(39) + @storeCode + char(39) + ' '  
		End  
	End  
	else if (@channel = 'distance')  
	begin  
		set @sql = @sql + ' and h.channelcode in ' + @retChannelCodeList  
  		set @sql = @sql + ' and h.retailercode = ' + char(39) + @retailerCode + char(39) + ' '  
		set @sql = @sql + ' and h.storecode = ' + char(39) + @storeCode + char(39) + ' '  
  
		if (@Type = 'pending' or @Type = 'declinedcallback') and @future = 1  
			set @sql = @sql + ' and CallbackDate > getdate() '  
		else if (@Type = 'pending' or @Type = 'declinedcallback') and @future = 0  
			set @sql = @sql + ' and CallbackDate <= getdate() '  
	end  
	else  
	Begin  
		if NOT (@Type IN ('fopsAwaiting', 'fopsUnderReview'))  
		begin  
			set @sql = @sql + ' and h.channelcode not in ' + @retChannelCodeList  
			
			if (@Type = 'pending' or @Type = 'declinedcallback') and @future = 1  
				set @sql = @sql + ' and CallbackDate > getdate() '  
			else if (@Type = 'pending' or @Type = 'declinedcallback') and @future = 0  
				set @sql = @sql + ' and CallbackDate <= getdate() '  
		end  
	End  
  
	--If we got here from the credit queue for direct orders (Cases awaiting decision)  
	if(@Type='ordered' and @channel = '')  
	begin  
		set @sql = @sql + ' and o.orderdate < DATEADD(mi, -10, getdate()) '  
	end  

    if (@Type = 'clickandcollect')
    begin
		
		set @sql = @sql + ' and h.IsClickAndCollect = 1'
		
	end
	else
	begin
		set @sql = @sql + ' and h.IsClickAndCollect = 0'
	end
  
  
  
	if @Type in ('ordered', 'orderedPrepay', 'all')  
		set @sql = @sql + ' order by o.orderdate asc '  
	else if @Type = 'declinedcallback' or @Type = 'pending'  
		set @sql = @sql + ' order by h.CallbackDate asc'  
	else  
		set @sql = @sql + ' order by h.orderRef asc'  
    

  
  
   
	PRINT (@SQL)  
	
	declare @Params nvarchar(200)  
	set @Params = N'@Type varchar(20), @timeNow datetime'  
	exec sp_executesql @sql, @Params, @Type, @timeNow  
  
	select idValue as RefreshSeconds from b4nsysdefaults with(nolock) where idName = 'QueueRefresh'  
end







GRANT EXECUTE ON h3giGetOrders TO b4nuser
GO
