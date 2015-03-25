  
CREATE          proc [dbo].[TESTING_h3giSMSGetSalesDataUnassisted]  
/*********************************************************************************************************************  
**                       
** Procedure Name : h3giSMSGetSalesDataUnassisted  
** Author  : Attila Pall  
** Date Created  : 29/01/2007  
** Version  : 1  
**       
**********************************************************************************************************************  
**      
** Description  : This stored procedure runs against the h3gi database on 172.28.1.36. It brings  
**    back sales data for packaging in an SMS sent to people in 3.  
**       
**********************************************************************************************************************  
**           
** Change Control : 29/01/2007 - Attila Pall: Select 3Pay sales from h3giUnassistedSalesHistory, and remove  
**      3Pay sales from the channels breakdown  
**        
**********************************************************************************************************************/  
as  
begin  
  
	declare @error int  
	set @error = 0  
  
	declare @thisMorning datetime  
	set @thisMorning = convert(datetime,cast(DAY(getdate()) as varchar) + '/'  + cast(MONTH(getdate()) as varchar) + '/' + cast(YEAR(getdate()) as varchar), 103)
  
	declare @salesDataTable table
	(  
		groupId int,  
		groupname varchar(100),  
		sales int,  
		priority int
	)  
  
	declare @3paySales int  
  
	select 
		TOP 1 @3paySales = isnull(numberOfSales,0)  
	from 
		h3giUnassistedSalesHistory  
	where 
		dateStamp >= @thisMorning  
	order by 
		dateStamp Desc  
	
	print '3PaySales : ' + cast(@3paySales as varchar(10))
	
	declare @groupid int  
	declare @grouptypeid int  
	declare @groupname varchar(100)  
	declare @priority int  
  
	declare @lastgroupid int  
	declare @count int  
	set @count = 1  
  
	declare cCursor cursor local for  
	select groupid,grouptypeid,groupname,priority  
	from h3giSMSGroupHeader  
	order by groupid  
  
	open cCursor  
	fetch cCursor into @groupid,@grouptypeid,@groupname,@priority  
  
	while @@fetch_status = 0  
	begin  
		print 'In cursor loop'
		
		if (@count = 1)  
		begin  
			set @lastgroupid = @groupid  
		end
         
		if (@lastgroupid <> @groupid or @count = 1) --do once per group  
		begin  
     
			if (@grouptypeid in (1))--Total  
			begin   
				print 'Total'
				insert into @salesDataTable  
				select @groupid, @groupname as groupname,isnull(count(oh.orderref),0) + ISNULL(@3paySales,0) as sales, @priority as priority  
				from h3giOrderHeader oh with(nolock), b4nOrderHistory ohi with(nolock)  
				where 
					oh.orderref = ohi.orderref  
					and ohi.statusdate <= getdate()  
					and ohi.statusdate >=  @thisMorning  
					and ohi.orderstatus in (312,306, 102) --retailer confirmed + credit approved  
					/*note: the retail channel has a different credit approved code (311) compared   
					to the direct channels, therefore the above code does not generate duplicates.*/  
					and isnull( (select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0'  
					and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')  
					and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')  
			end  
			else if (@grouptypeid in (2))--channels  
			begin   
				print 'channels'
				insert into @salesDataTable  
				select @groupid, @groupname as groupname,isnull(count(oh.orderref),0) as sales,  @priority as priority  
				from h3giOrderHeader oh with(nolock), b4nOrderHistory ohi with(nolock)  
				where 
					oh.orderref = ohi.orderref 
					and ohi.statusdate <= getdate()  
					and ohi.statusdate >=  @thisMorning  
					and  ( (ohi.orderstatus in (312,306) and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0')) --retailer confirmed + credit approved  
					/*note: the retail channel has a different credit approved code (311) compared   
					to the direct channels, therefore the above code does not generate duplicates.*/  
					and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')  
					and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')  
			end  
			else if (@grouptypeid in (5))-- All Channels - Pre Pay  
			begin   
				print 'All Channels - Pre Pay'
				insert into @salesDataTable  
				select @groupid, @groupname as groupname, ISNULL(@3paySales, 0) as sales, @priority as priority  
			end  
			else if (@grouptypeid in (6))-- All Channels - Contract  
			begin   
				print 'All Channels - Contract'
				insert into @salesDataTable  
				select @groupid, @groupname as groupname,isnull(count(oh.orderref),0) as sales, @priority as priority  
				from 
					h3giOrderHeader oh with(nolock)  
				inner join 
					b4nOrderHistory ohi with(nolock) on oh.orderref = ohi.orderref  
				inner join 
					h3giProductCatalogue pc on pc.catalogueVersionId = oh.catalogueVersionId  
					and pc.catalogueProductId = dbo.fnGetCatalogueProductIdFromS4NProductId(oh.phoneProductCode) 
					and pc.productType = 'HANDSET'  
				where 
					ohi.statusdate <= getdate()      
					and ohi.statusdate >=  @thisMorning  
					and ohi.orderstatus in (312,306) --retailer confirmed + credit approved  
					/*note: the retail channel has a different credit approved code (311) compared   
					to the direct channels, therefore the above code does not generate duplicates.*/  
					and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')  
					and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')  
					and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0'  
			end  
			else if (@grouptypeid in (7))-- All Channels - Upgrades  
			begin   
				print 'All Channels - Upgrades'
				insert into @salesDataTable  
				select @groupid, @groupname as groupname,isnull(count(oh.orderref),0) as sales, @priority as priority  
				from 
					h3giOrderHeader oh with(nolock), b4nOrderHistory ohi with(nolock)  
				where 
					oh.orderref = ohi.orderref  
					and ohi.statusdate <= getdate()  
					and ohi.statusdate >=  @thisMorning  
					and ohi.orderstatus in (102,312) --retailer confirmed + credit approved  
					and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')  
					and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')  
					and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '2'  
			end  
			else if (@grouptypeid in (8))-- All Channels - Contract Datacards  
			begin
				print 'All Channels - Contract Datacards'
				insert into @salesDataTable  
				select @groupid, @groupname as groupname,isnull(count(oh.orderref),0) as sales,  @priority as priority  
				from 
					h3giOrderHeader oh with(nolock)  
				inner join 
					b4nOrderHistory ohi with(nolock) on oh.orderref = ohi.orderRef  
				inner join 
					h3giProductCatalogue pc  on pc.catalogueVersionId = oh.catalogueVersionId 
					and pc.productfamilyId = oh.phoneProductCode  
				inner join 
					h3giProductAttribute pa on pa.attributeName = 'HANDSETTYPE'  
				inner join 
					h3giProductAttributeValue pav on pav.catalogueProductId = pc.catalogueProductId  and pav.attributeId = pa.attributeId  and pav.attributeValue = 'DATACARD'  
				where 
					oh.orderref = ohi.orderref 
					and ohi.statusdate <= getdate()  
					and ohi.statusdate >=  @thisMorning
					and ohi.orderstatus in (312,306) --retailer confirmed + credit approved  
					and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')  
					and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0'  
			end  
			else --retailers  
			begin  
				print 'retailers group name: ' + @groupname
				insert into 
					@salesDataTable  
				select 
					@groupid, @groupname as groupname, isnull(count(oh.orderref),0) as sales,  @priority as priority  
				from 
					h3giOrderHeader oh with(nolock), b4nOrderHistory ohi with(nolock)  
				where 
					oh.orderref = ohi.orderref 
					and ohi.statusdate <= getdate()  
					and ohi.statusdate >=  @thisMorning 
					--retailer confirmed  
					and ((ohi.orderstatus = 312 and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0')) and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')  
				    and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where groupid = @groupid and retailercode != '')  
			end  
		end  
  
		if @@error <> 0  
		begin  
			set @error = @@error  
			goto ERROR  
		end  
		
		set @count = @count + 1  
		set @lastgroupid = @groupid  
		fetch cCursor into @groupid,@grouptypeid,@groupname,@priority  
	end  
	close cCursor  
	deallocate cCursor  
  
	DECLARE @businessEndUserCount INT  
	
	SELECT  
		@businessEndUserCount = COUNT(*)  
	FROM 
		threeOrderItem item  
	INNER JOIN threeOrderHeader header ON 
		item.orderRef = header.orderRef  
	INNER JOIN b4nOrderHistory history ON 
		history.orderref = header.orderref 
		AND history.orderStatus = header.orderStatus  
	WHERE 
		header.orderStatus = 312  
		AND history.statusDate > @thisMorning  
		AND item.parentItemId IS NOT NULL  
  
	print '@businessEndUserCount : ' + cast(@businessEndUserCount as varchar(10))
	
	UPDATE 
		@salesDataTable  
	SET 
		sales = sales + @businessEndUserCount  
	WHERE 
		groupId = 1  
  
	INSERT INTO 
		@salesDataTable(groupId, groupName, sales, priority)  
	SELECT 
		MAX(groupId) + 1, 
		'Business', 
		@businessEndUserCount, 
		4  
	FROM 
		h3giSMSGroupHeader  
  
	select groupName, sales, priority from @salesDataTable  order by priority  
  
	if @@error <> 0  
	begin  
		set @error = @@error  
		goto ERROR  
	end  
  
ERROR:  
	if @error <> 0  
	begin   
		select 'error--' + @error 'in h3giSMSGetSalesDataUnassisted'  
		goto ENDPROC  
	end  
  
ENDPROC:  
  
end  
GRANT EXECUTE ON TESTING_h3giSMSGetSalesDataUnassisted TO b4nuser
GO
