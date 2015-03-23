

CREATE         proc dbo.h3giSMSGetSalesData_070704
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giSMSGetSalesData_070704
** Author		:	John Hannon
** Date Created		:	04/01/2006
** Version		:	1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure runs against the h3gi database on 172.28.1.36. It brings
**				back sales data for packaging in an SMS sent to people in 3.
**					
**********************************************************************************************************************
**									
** Change Control	:	John Hannon - 24/03/2006 Change to handle 2 new group types 'All channels - Pre Pay' (5)
**				and 'All channels - Contract' (6)
**			:	John Hannon - 27/03/2006 Change for PrePay orders - have a status of 312 in b4nOrderHistory
**			:	Peter Murphy - 19/09/2006 Change for upgrades - grouptypeid 7
**						
**********************************************************************************************************************/
as
begin

PRINT '1'
	declare @error int
	set @error = 0

	declare @salesDataTable table(
				groupname varchar(100),
				sales int,
				priority int)

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
		print 'ARGH'
		if (@count = 1)
		begin
			set @lastgroupid = @groupid
		end
		
			
		if (@lastgroupid <> @groupid or @count = 1) --do once per group
		begin
			

			if (@grouptypeid in (1,2))--channels
			begin	
				insert into @salesDataTable
				select @groupname as groupname,isnull(count(oh.orderref),0) as sales, 
				@priority as priority
				from h3giOrderHeader oh with(nolock), b4nOrderHistory ohi with(nolock)
				where oh.orderref = ohi.orderref
				and ohi.statusdate <= getdate()
				and ohi.statusdate >= 	convert(datetime,cast(datepart(dd,getdate()) as varchar)+
							'/'  + cast(datepart(mm,getdate()) as varchar) + 
							'/' + cast(datepart(yyyy,getdate()) as varchar))
				and 	(	(ohi.orderstatus in (312,306) and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0') --retailer confirmed + credit approved
					/*note: the retail channel has a different credit approved code (311) compared 
					to the direct channels, therefore the above code does not generate duplicates.*/
					or 	(ohi.orderstatus in (312,102) and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '1')
					)
				and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')
				and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')
			end
			else if (@grouptypeid in (5))-- All Channels - Pre Pay
			begin	
				insert into @salesDataTable
				select @groupname as groupname,isnull(count(oh.orderref),0) as sales, 
				@priority as priority
				from h3giOrderHeader oh with(nolock), b4nOrderHistory ohi with(nolock)
				where oh.orderref = ohi.orderref
				and ohi.statusdate <= getdate()
				and ohi.statusdate >= 	convert(datetime,cast(datepart(dd,getdate()) as varchar)+
							'/'  + cast(datepart(mm,getdate()) as varchar) + 
							'/' + cast(datepart(yyyy,getdate()) as varchar))
				and ohi.orderstatus in (102,312) --confirmed and retailerconfirmed
				and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')
				and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')
				and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '1'
			end
			else if (@grouptypeid in (6))-- All Channels - Contract
			begin	
				insert into @salesDataTable
				select @groupname as groupname,isnull(count(oh.orderref),0) as sales, 
				@priority as priority
				from h3giOrderHeader oh with(nolock)
				inner join b4nOrderHistory ohi with(nolock)
					on oh.orderref = ohi.orderref
				where ohi.statusdate <= getdate()
				and ohi.statusdate >= 	convert(datetime,cast(datepart(dd,getdate()) as varchar)+
							'/'  + cast(datepart(mm,getdate()) as varchar) + 
							'/' + cast(datepart(yyyy,getdate()) as varchar), 103)
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
				select @groupname as groupname,isnull(count(oh.orderref),0) as sales, 
				@priority as priority
				from h3giOrderHeader oh with(nolock), b4nOrderHistory ohi with(nolock)
				where oh.orderref = ohi.orderref
				and ohi.statusdate <= getdate()
				and ohi.statusdate >= 	convert(datetime,cast(datepart(dd,getdate()) as varchar)+
							'/'  + cast(datepart(mm,getdate()) as varchar) + 
							'/' + cast(datepart(yyyy,getdate()) as varchar))
				and ohi.orderstatus in (102,312) --retailer confirmed + credit approved
				and oh.channelcode in (select distinct channelcode from h3giSMSGroupDetail where groupid = @groupid and channelcode != '')
				and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')
				and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '2'
			end
			else if (@grouptypeid in (8))-- All Channels - Datacards
			begin	
				insert into @salesDataTable
				select @groupname as groupname,isnull(count(oh.orderref),0) as sales, 
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
				and ohi.statusdate <= getdate()
				and ohi.statusdate >= 	convert(datetime,cast(datepart(dd,getdate()) as varchar)+
							'/'  + cast(datepart(mm,getdate()) as varchar) + 
							'/' + cast(datepart(yyyy,getdate()) as varchar), 103)
				and ohi.orderstatus in (312,306) --retailer confirmed + credit approved
				and oh.retailercode in (select distinct retailercode from h3giSMSGroupDetail where channelcode = oh.channelcode and retailercode != '')
				and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0'
			end
			else	--retailers
			begin
				insert into @salesDataTable
				select @groupname as groupname,isnull(count(oh.orderref),0) as sales, 
				@priority as priority
				from h3giOrderHeader oh with(nolock), b4nOrderHistory ohi with(nolock)
				where oh.orderref = ohi.orderref
				and ohi.statusdate <= getdate()
				and ohi.statusdate >= 	convert(datetime,cast(datepart(dd,getdate()) as varchar)+
							'/'  + cast(datepart(mm,getdate()) as varchar) + 
							'/' + cast(datepart(yyyy,getdate()) as varchar))
				and 	(	(ohi.orderstatus = 312 and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '0') --retailer confirmed
					or 	(ohi.orderstatus = 312 and isnull((select top 1 bol.gen6 from b4norderline bol where bol.orderref = oh.orderref),'0') = '1')
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

	select * from @salesDataTable
	order by priority

	if @@error <> 0
	begin
		set @error = @@error
		goto ERROR
	end


	ERROR:
	if @error <> 0
	begin	
		select 'error--' + @error 'in h3giSMSGetSalesData_070704'
		goto ENDPROC
	end

	ENDPROC:

end



GRANT EXECUTE ON h3giSMSGetSalesData_070704 TO b4nuser
GO
GRANT EXECUTE ON h3giSMSGetSalesData_070704 TO ofsuser
GO
GRANT EXECUTE ON h3giSMSGetSalesData_070704 TO reportuser
GO
