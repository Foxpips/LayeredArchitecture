
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giSMSGetPastSalesDataUnassisted
** Author			:	Stephen Quin
** Date Created		:	20/02/2009
** Version			:	1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure runs against the h3gi database on 172.28.1.36. It brings
**						back sales data for packaging in an SMS sent to people in 3 for a particular date.
**					
**********************************************************************************************************************/
CREATE          proc [dbo].[h3giSMSGetPastSalesDataUnassisted]	
	@smsSalesDate DATETIME
as
begin

	declare @error int
	set @error = 0

	declare @thisMorning datetime
	set @thisMorning = convert(datetime,cast(DAY(@smsSalesDate) as varchar)+
		'/'  + cast(MONTH(@smsSalesDate) as varchar) + 
		'/' + cast(YEAR(@smsSalesDate) as varchar), 103)

	declare @salesDataTable table(
				groupId int,
				groupname varchar(100),
				sales int,
				priority int)

	declare @3paySales int

	select TOP 1 @3paySales = isnull(numberOfSales,0)
	from h3giUnassistedSalesHistory
	where dateStamp >= @thisMorning
	order by dateStamp Desc

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
		
		if (@count = 1)
		begin
			set @lastgroupid = @groupid
		end
		
			
		if (@lastgroupid <> @groupid or @count = 1) --do once per group
		begin
			

			if (@grouptypeid in (1))--Total
			begin	
				insert into @salesDataTable
				select @groupid, @groupname as groupname,isnull(count(oh.orderref),0) + ISNULL(@3paySales,0) as sales, 
				@priority as priority
				from h3giOrderHeader oh with(nolock), b4nOrderHistory ohi with(nolock)
				where oh.orderref = ohi.orderref
				and ohi.statusdate <= @smsSalesDate
				and ohi.statusdate >= @thisMorning
				and ohi.orderstatus in (312,306) --retailer confirmed + credit approved
					/*note: the retail channel has a different credit approved code (311) compared 
					to the direct channels, therefore the above code does not generate duplicates.*/
				and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0'
				and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')
				and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')
			end
			else if (@grouptypeid in (2))--channels
			begin	
				insert into @salesDataTable
				select @groupid, @groupname as groupname,isnull(count(oh.orderref),0) as sales, 
				@priority as priority
				from h3giOrderHeader oh with(nolock), b4nOrderHistory ohi with(nolock)
				where oh.orderref = ohi.orderref
				and ohi.statusdate <= @smsSalesDate
				and ohi.statusdate >= @thisMorning
				and 	(	(ohi.orderstatus in (312,306) and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0') --retailer confirmed + credit approved
					/*note: the retail channel has a different credit approved code (311) compared 
					to the direct channels, therefore the above code does not generate duplicates.*/
					)
				and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')
				and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')
			end
			else if (@grouptypeid in (5))-- All Channels - Pre Pay
			begin	
				insert into @salesDataTable
				select @groupid, @groupname as groupname, ISNULL(@3paySales, 0) as sales, @priority as priority
			end
			else if (@grouptypeid in (6))-- All Channels - Contract
			begin	
				insert into @salesDataTable
				select @groupid, @groupname as groupname,isnull(count(oh.orderref),0) as sales, 
				@priority as priority
				from h3giOrderHeader oh with(nolock)
				inner join b4nOrderHistory ohi with(nolock)
					on oh.orderref = ohi.orderref
				inner join h3giProductCatalogue pc
					on pc.catalogueVersionId = oh.catalogueVersionId
					and pc.catalogueProductId = dbo.fnGetCatalogueProductIdFromS4NProductId(oh.phoneProductCode)
					and pc.productType = 'HANDSET'
				where ohi.statusdate <= @smsSalesDate
				and ohi.statusdate >= @thisMorning
				and ohi.orderstatus in (312,306) --retailer confirmed + credit approved
				/*note: the retail channel has a different credit approved code (311) compared 
				to the direct channels, therefore the above code does not generate duplicates.*/
				and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')
				and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')
				and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0'
			end
			else if (@grouptypeid in (7))-- All Channels - Upgrades
			begin	
				insert into @salesDataTable
				select @groupid, @groupname as groupname,isnull(count(oh.orderref),0) as sales, 
				@priority as priority
				from h3giOrderHeader oh with(nolock), b4nOrderHistory ohi with(nolock)
				where oh.orderref = ohi.orderref
				and ohi.statusdate <= @smsSalesDate
				and ohi.statusdate >= @thisMorning
				and ohi.orderstatus in (102,312) --retailer confirmed + credit approved
				and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')
				and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')
				and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '2'
			end
			else if (@grouptypeid in (8))-- All Channels - Contract Datacards
			begin	
				insert into @salesDataTable
				select @groupid, @groupname as groupname,isnull(count(oh.orderref),0) as sales, 
				@priority as priority
				from h3giOrderHeader oh with(nolock)
				inner join b4nOrderHistory ohi with(nolock)
					on oh.orderref = ohi.orderRef
				inner join h3giProductCatalogue pc
					on pc.catalogueVersionId = oh.catalogueVersionId
					and pc.productfamilyId = oh.phoneProductCode
				inner join h3giProductAttribute pa
					on pa.attributeName = 'HANDSETTYPE'
				inner join h3giProductAttributeValue pav
					on pav.catalogueProductId = pc.catalogueProductId
					and pav.attributeId = pa.attributeId
					and pav.attributeValue = 'DATACARD'
				where oh.orderref = ohi.orderref
				and ohi.statusdate <= @smsSalesDate
				and ohi.statusdate >= convert(datetime,cast(datepart(dd,@smsSalesDate) as varchar)+
							'/'  + cast(datepart(mm,@smsSalesDate) as varchar) + 
							'/' + cast(datepart(yyyy,@smsSalesDate) as varchar), 103)
				and ohi.orderstatus in (312,306) --retailer confirmed + credit approved
				and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')
				and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0'
			end
			else	--retailers
			begin
				insert into @salesDataTable
				select @groupid, @groupname as groupname,isnull(count(oh.orderref),0) as sales, 
				@priority as priority
				from h3giOrderHeader oh with(nolock), b4nOrderHistory ohi with(nolock)
				where oh.orderref = ohi.orderref
				and ohi.statusdate <= @smsSalesDate
				and ohi.statusdate >= @thisMorning
				and 	(	(ohi.orderstatus = 312 and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0') --retailer confirmed
					)
				and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')
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
	FROM threeOrderItem item
	INNER JOIN threeOrderHeader header
		ON item.orderRef = header.orderRef
	INNER JOIN b4nOrderHistory history
		ON history.orderref = header.orderref
		AND history.orderStatus = header.orderStatus
	WHERE header.orderStatus = 312
		AND history.statusDate <= @smsSalesDate
		AND history.statusDate >= @thisMorning
		AND item.parentItemId IS NOT NULL

	UPDATE @salesDataTable
	SET sales = sales + @businessEndUserCount
	WHERE groupId = 1

	INSERT INTO @salesDataTable(groupId, groupName, sales, priority)
	SELECT MAX(groupId) + 1, 'Business', @businessEndUserCount, 4
	FROM h3giSMSGroupHeader

	select groupName, sales, priority from @salesDataTable
	order by priority

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




















GRANT EXECUTE ON h3giSMSGetPastSalesDataUnassisted TO b4nuser
GO
