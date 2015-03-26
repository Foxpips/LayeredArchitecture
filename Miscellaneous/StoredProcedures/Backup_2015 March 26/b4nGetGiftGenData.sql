

/****** Object:  Stored Procedure dbo.b4nGetGiftGenData    Script Date: 23/06/2005 13:31:50 ******/


CREATE        PROCEDURE dbo.b4nGetGiftGenData
@viewTypeID int,
@storeID int,
@Page int,
@Size int,
@giftatt varchar(8000),
@giftattvalue varchar(8000),
@sortAttributeID int = 0,
@sortDir varchar(20) = 'asc'

/**********************************************************************************************************************
**									
** Change Control	:	15/11/2004 - John Hannon modified this sp to conform with modifications to ProductDisplay.cs (line 1613)
**			which now must take a sort direction (@sortDir) when searching using the gift finder. This change was 
**			brought in due to 3G needing to have a sort direction (e.g. A - Z for sort by Name) in its 
**			gift generator / product finder. This sp has been modified in the appleby, smcc, threeg, and wineroom
**			databases ONLY. This is because these are the only shop4now sites that use a gift generator with sorting
**						
**********************************************************************************************************************/

As
begin
set nocount on
 

declare @inputString as varchar(8000), @delimiter as char(1), @eval as bit,@foundPos as smallint
declare @foundString as varchar(50),@rowCounter int
declare @sql1 varchar(2000),@sqlstep1 varchar(5000), @sqlstep2 varchar(5000),@sql varchar(8000), @sql2 varchar(8000)
DECLARE @Start int, @End int, @numofrows int, @total_products int, @price int
declare @priceattid int
declare @sortAttributeTypeId int
declare @sortAttributeIsNumeric int

set @sortAttributeIsNumeric = 0
if @sortAttributeID <> 0 
	begin -- we need to know if the type is numeric or not for sorting later

	select @sortAttributeTypeId = attributetypeid from b4nattribute where attributeid = @sortAttributeID
	and attributetypeid in (8,9,10,11,16)
	if (@@rowcount > 0 )
		begin
		set @sortAttributeIsNumeric = 1
		end

	end


set @priceattid = 19
set @delimiter = '|'
 
Create Table #tProducts
(
productid	int,
attributetypeid int,
attributTypeName varchar(50),
attributeTypeDescription varchar(1000),
attributeTypeCountOfValues int,
attributeCollectionId int,
attributeId int,
attributeName varchar(50),
attributeSource char(1),
dropdownDescription varchar(100),
multiValue smallint,
multiValueType varchar(12),
productFamilyId int,
storeId int,
multiValuePriority smallint,
attributeAffectsBasePriceBy decimal,
attributeAffectsRRPPriceBy decimal,
attributeImageName varchar(100),
modifyDate smalldatetime,
createDate smalldatetime,
attributeRowID int,
attributeValue varchar(8000),
priority int,
labelDescription varchar(100),
categoryId varchar(50),
displayMultiValues smallInt
)
 
Create table #tPaging
( 
Row int IDENTITY(1,1) PRIMARY KEY,
productid int,
priority int
)
 
create table #tGifts
(
Row int IDENTITY(1,1) ,
productid int PRIMARY KEY
)
create table #tGiftAttributes
(
Row int IDENTITY(1,1) PRIMARY KEY,
attid int,
attvalue varchar(2000)
)
 
Create Table #tSort
(	
Row int IDENTITY(1,1) PRIMARY KEY,
productid int
)


 
 
set @inputString = @giftatt
set @eval = 1
while (@eval = 1)
begin
 set @foundPos = charindex(@delimiter, @inputString)
 if @foundPos <> 0
 begin
  set @foundString = left(@inputString, @foundPos-1)
  set @sql1 =  'insert into #tGiftAttributes values (' + char(39)  + @foundString + char(39) + ',' + char(39) + '' + char(39) + ')'
  exec (@sql1)
  set @inputString = right(@inputString, len(@inputString) - @foundPos)
 end
 else
 begin
  set @sql1 =  'insert into #tGiftAttributes values (' + char(39)  + @inputString  + char(39) + ',' + char(39) + '' + char(39) + ')'
  exec (@sql1)
  set @eval = 0
 end
 
end
 

set @rowCounter = 1
set @inputString = @giftattvalue
 

set @eval = 1
while (@eval = 1)
begin
 set @foundPos = charindex(@delimiter, @inputString)
 if @foundPos <> 0
 begin
  set @foundString = left(@inputString, @foundPos-1)
  set @sql1 =  'update  #tGiftAttributes set attvalue = ' + char(39) +  @foundString + char(39) 
  set @sql1 = @sql1 + ' where row = ' + cast(@rowCounter as varchar(10))
  exec (@sql1)
  set  @rowCounter = @rowCounter + 1
  set @inputString = right(@inputString, len(@inputString) - @foundPos)
 end
 else
 begin
  set @sql1 =  'update  #tGiftAttributes set attvalue = ' + char(39) +  @inputString  + char(39) 
  set @sql1 = @sql1 + ' where row = ' + cast(@rowCounter as varchar(10))
  exec (@sql1)
  set  @rowCounter = @rowCounter + 1
  set @eval = 0
 end
 
end
 

declare @startprice varchar(100), @endprice varchar(100),@lindex  int, @rindex int
 

declare @startage varchar(100), @endage varchar(100),@agestartid int ,@ageendid int
 
set @rindex = 0
set @lindex = 0
 
set @sql =    ' insert into #tGifts '
set @sql = @sql + ' select distinct p.productfamilyid as productid '
set @sql = @sql + '  from b4nproduct p with(nolock) '
  
declare giftCursor insensitive cursor 
for select row,attid,attvalue from #tGiftAttributes
 
open giftCursor
 
declare @row int, @attid int, @attvalue varchar(2000)
set @sqlstep1 = ''
set @sqlstep2 = ''
fetch next from giftCursor into @row, @attid, @attvalue
while (@@fetch_status = 0)
begin
 
 if ( isnull(@attvalue,'') != '0')
 begin
 
  set @attvalue = replace(@attvalue,'%20',' ')
  if (@attid = 1111)
  begin 
   --price range special attribute
   -- price range needs to be split from base values into start and endprices
   -- uses a specific attributeid for the price attribute not the one supplied
   set @lindex = 0
   set @rindex = 0
   set @lindex = (select charindex('-',@attvalue) where charindex('-',@attvalue) != 0) 
   set @rindex = @lindex
   if  (@lindex != 0)
   begin
   set @lindex = @lindex - 1
   end
   set @rindex = len(@attvalue) - @rindex
   set @startprice = isnull((select left(@attvalue,@lindex) where @lindex != 0),0)
   set @endprice = isnull((select right(@attvalue,@rindex) where @rindex > 0),0)
 

   set @sqlstep1 = @sqlstep1 + '  ,b4nattributeproductfamily apf' + cast(@row as varchar(10)) + ' with(nolock) ' 
   set @sqlstep2 = @sqlstep2 + ' and apf' + cast(@row as varchar(10)) + '.attributeid = ' +   cast(@priceattid  as varchar(10))
   set @sqlstep2 = @sqlstep2 + ' and cast(apf' + cast(@row as varchar(10)) + '.attributeValue as real) >= cast(' + cast(@startprice as varchar(100)) + ' as real)'
 
   if(@endprice != '0')
   begin
   set @sqlstep2 = @sqlstep2 + ' and cast(apf' + cast(@row as varchar(10)) + '.attributeValue as real ) <= cast(' + cast(@endprice as varchar(100)) + ' as real)'
   end
   set @sqlstep2 = @sqlstep2 + ' and apf' + cast(@row as varchar(10)) + '.productfamilyid = p.productfamilyid'
 
 
  
   
  end
  else if  (@attid = 1112)
  begin
   --age range special attribute
   -- age range needs to be split from base values into start and end age ranges
   -- uses a specific attributeid for the age attribute not the one supplied
   set @lindex = 0
   set @rindex = 0
   set @lindex = (select charindex('-',@attvalue) where charindex('-',@attvalue) != 0) 
   set @rindex = @lindex
  
   set @agestartid = 98 
   set @ageendid = 99
 
   if  (@lindex != 0)
   begin
   set @lindex = @lindex - 1
   end
   set @rindex = len(@attvalue) - @rindex
   set @startage = isnull((select left(@attvalue,@lindex) where @lindex != 0),0)
   set @endage = isnull((select right(@attvalue,@rindex) where @rindex > 0),0)
 
   if(@endage != '0')
   begin
   set @sqlstep1 = @sqlstep1 + '  ,b4nattributeproductfamily apfa1' + cast(@row as varchar(10)) + ' with(nolock) ' 
   set @sqlstep1 = @sqlstep1 + '  ,b4nattributeproductfamily apfa2' + cast(@row as varchar(10)) + ' with(nolock) ' 
   set @sqlstep2 = @sqlstep2 + ' and apfa1' + cast(@row as varchar(10)) + '.productfamilyid = p.productfamilyid'
   set @sqlstep2 = @sqlstep2 + ' and apfa2' + cast(@row as varchar(10)) + '.productfamilyid = p.productfamilyid'
   set @sqlstep2 = @sqlstep2 + ' and apfa1' + cast(@row as varchar(10)) + '.attributeid = ' +   cast(@agestartid  as varchar(10))
   set @sqlstep2 = @sqlstep2 + ' and apfa2' + cast(@row as varchar(10)) + '.attributeid = ' +   cast(@ageendid  as varchar(10))
   set @sqlstep2 = @sqlstep2 + ' and  ( '

   set @sqlstep2 = @sqlstep2 + ' ( cast( apfa1' + cast(@row as varchar(10)) + '.attributeValue as decimal) >= cast(' + cast(@startage as varchar(100)) + ' as decimal)'
   set @sqlstep2 = @sqlstep2 + ' and cast( apfa2' + cast(@row as varchar(10)) + '.attributeValue as decimal) <= cast(' + cast(@endage as varchar(100)) + ' as decimal) )'

   set @sqlstep2 = @sqlstep2 + '  or '
   set @sqlstep2 = @sqlstep2 + ' ( cast( apfa1' + cast(@row as varchar(10)) + '.attributeValue as decimal) = ' + char(39) + '0' + char(39) 
   set @sqlstep2 = @sqlstep2 + ' and cast( apfa2' + cast(@row as varchar(10)) + '.attributeValue as decimal) = cast(' + cast(@endage as varchar(100)) + ' as decimal) )'

   set @sqlstep2 = @sqlstep2 + '  or '
   set @sqlstep2 = @sqlstep2 + ' ( cast( apfa1' + cast(@row as varchar(10)) + '.attributeValue as decimal) = cast(' + cast(@startage as varchar(100)) + ' as decimal)'
   set @sqlstep2 = @sqlstep2 + ' and cast( apfa2' + cast(@row as varchar(10)) + '.attributeValue as decimal) = ' + char(39) + '99' + char(39)  + ' )'

   set @sqlstep2 = @sqlstep2 + '  or '
   set @sqlstep2 = @sqlstep2 + ' ( cast( apfa1' + cast(@row as varchar(10)) + '.attributeValue as decimal) = ' + char(39) + '0' + char(39) 
   set @sqlstep2 = @sqlstep2 + ' and cast( apfa2' + cast(@row as varchar(10)) + '.attributeValue as decimal) = ' + char(39) + '99' + char(39)  + ' )'

set @sqlstep2 = @sqlstep2 + '  or '
 set @sqlstep2 = @sqlstep2 + ' ( cast( apfa1' + cast(@row as varchar(10)) + '.attributeValue as decimal) <= cast(' + cast(@endage as varchar(100)) + ' as decimal)'
   set @sqlstep2 = @sqlstep2 + ' and cast( apfa2' + cast(@row as varchar(10)) + '.attributeValue as decimal) >= cast(' + cast(@endage as varchar(100)) + ' as decimal) )'

set @sqlstep2 = @sqlstep2 + '   ) '






	
end
else
begin
   set @sqlstep1 = @sqlstep1 + '  ,b4nattributeproductfamily apfa1' + cast(@row as varchar(10)) + ' with(nolock) ' 
   set @sqlstep2 = @sqlstep2 + ' and apfa1' + cast(@row as varchar(10)) + '.productfamilyid = p.productfamilyid'
   set @sqlstep2 = @sqlstep2 + ' and apfa1' + cast(@row as varchar(10)) + '.attributeid = ' +   cast(@agestartid  as varchar(10))
   set @sqlstep2 = @sqlstep2 + ' and cast( apfa1' + cast(@row as varchar(10)) + '.attributeValue as decimal)  >= cast(' + cast(@startage as varchar(100)) + ' as decimal)'

end
    

 

  end
   else if  (@attid = 75)  -- gender
  begin

   set @sqlstep1 = @sqlstep1 + ' , b4nattributeproductfamily apf' + cast(@row as varchar(10)) + ' with(nolock)' 
   set @sqlstep2 = @sqlstep2 + ' and apf' + cast(@row as varchar(10)) + '.attributeid = ' +   cast(@attid  as varchar(10))
   set @sqlstep2 = @sqlstep2 + ' and apf' + cast(@row as varchar(10)) + '.attributevalue in   ( '
   set @sqlstep2 = @sqlstep2 +    char(39) + cast(@attvalue  as varchar(2000)) + char(39) 

	--John Morgan
   	/*if @attvalue = 8
	begin
		set @sqlstep2 = @sqlstep2 + ' , ' 
		set @sqlstep2 = @sqlstep2 +    char(39) + '1' + char(39)
		set @sqlstep2 = @sqlstep2 + ' , ' 
		set @sqlstep2 = @sqlstep2 +    char(39) + '5' + char(39)
	end*/
	
--   set @sqlstep2 = @sqlstep2 + ' , ' 
--   set @sqlstep2 = @sqlstep2 +    char(39) + '8' + char(39) + ' ) ' 

   set @sqlstep2 = @sqlstep2 + ' ) '
	--John Morgan ends	
   set @sqlstep2 = @sqlstep2 + ' and apf' + cast(@row as varchar(10)) + '.productfamilyid = p.productfamilyid'
end
else
  begin
  
   set @sqlstep1 = @sqlstep1 + ' , b4nattributeproductfamily apf' + cast(@row as varchar(10)) + ' with(nolock)' 
   set @sqlstep2 = @sqlstep2 + ' and apf' + cast(@row as varchar(10)) + '.attributeid = ' +   cast(@attid  as varchar(10))
   set @sqlstep2 = @sqlstep2 + ' and apf' + cast(@row as varchar(10)) + '.attributevalue = ' +  char(39) + cast(@attvalue  as varchar(2000)) + char(39) 
   set @sqlstep2 = @sqlstep2 + ' and apf' + cast(@row as varchar(10)) + '.productfamilyid = p.productfamilyid'
  end
 end
 
   fetch next from giftCursor into @row, @attid, @attvalue
end
 
deallocate giftCursor
 

set @sqlstep1 = @sqlstep1 + '  where  p.deleted = 0 ' 
set @sql = @sql + @sqlstep1 + @sqlstep2
 
print(@sqL)
exec (@sql)
  
SET @Start = (((@Page - 1) * @Size) + 1)
SET @End = (@Start + @Size - 1)
SET @numofrows = (@Page * @Size)
 

Insert into #tProducts
Select p.productID,t.attributetypeid,t.attributeTypeName,t.attributeTypeDescription,t.attributeTypeCountOfValues,
	pf.attributeCollectionId,a.attributeid,
	a.attributeName,a.attributeSource,a.dropdownDescription,a.multiValue,a.multiValueType,
	isnull(f.productfamilyId,0) as productFamilyId,f.storeid,f.multivaluepriority,
	f.attributeaffectsbasepriceby,f.attributeaffectsrrpPriceBy,f.attributeimagename,f.modifydate,
	f.createdate,f.attributerowid,f.attributevalue,cp.priority,a.labelDescription
	, c.categoryId  as categoryid,
	'' as displayMultiValues


from
 #tgifts tg	with (nolock) 
,b4nproduct p with(nolock)
, b4nproductfamily pf with(nolock)
 ,b4nCollectionDisplay cd 	with(nolock)
,b4nCategoryProduct cp 		with(nolock)
,b4nCategory c 			with(nolock)
,b4nAttribute a 			with(nolock)
,b4nAttributeType t		with(nolock)
,b4nAttributeProductFamily f 	with(nolock)
where p.productid = tg.productid
and p.deleted = 0
and pf.productfamilyid = p.productfamilyid

	/*John Morgan commented this line out. as can not add other attributecollectionid's to collection display table
	  as product will show up multiple times on page. so hence cant have this join in or products that are of 
	attributecollectionid other than 1 wont come back
	*/
	--and pf.attributecollectionID =cd.attributecollectionid

	and cd.viewtypeID = @viewTypeID 
	and cd.contenttype = 'A'
	and c.categoryid in
 (select top 1 cp2.categoryId from b4ncategoryproduct cp2 with(nolock), b4nproduct cp1 with(nolock)
		where cp1.deleted = 0 and cp1.productid = p.productid and cp2.storeid = @storeid and cp2.productid = cp1.productid   )

	and cp.categoryid = c.categoryid
	and cp.productid = p.productid	
	and cp.storeid = @storeid
	and a.attributeID  = cd.content
	and a.attributesource = 'C'
	and t.attributeTypeID = a.attributeTypeID
and f.productfamilyid = pf.productfamilyid
	and f.attributeID = a.attributeID
order by p.productID,cp.priority asc


update #tProducts
set displayMultiValues = (select distinct(c.displaymultivalues)
    from b4nattributecollection c with(nolock), b4nproductfamily pf with(nolock)
     where c.attributeCollectionID = pf.attributeCollectionID
      and pf.productFamilyId = #tProducts.productFamilyID)
 

if (@sortAttributeID  <> 0 ) -- we use sorting 
	begin
	if ( @sortAttributeIsNumeric = 1 )
		begin
		
			if (@sortdir = 'asc')
			begin
				insert into #tSort(productid)
				select productid
				from #tProducts where attributeid = @sortAttributeID order by cast(attributevalue as real) asc	
			end
			if (@sortdir = 'desc')
			begin
				insert into #tSort(productid)
				select productid
				from #tProducts where attributeid = @sortAttributeID order by cast(attributevalue as real) desc	
			end
				
		end

	if ( @sortAttributeIsNumeric = 0 )
		begin
			if (@sortdir = 'asc')
			begin
				insert into #tSort(productid)
				select productid
				from #tProducts where attributeid = @sortAttributeID order by attributevalue asc		
			end
			if (@sortdir = 'desc')
			begin
				insert into #tSort(productid)
				select productid
				from #tProducts where attributeid = @sortAttributeID order by attributevalue desc		
			end
		end

	Insert into #tPaging(productid,priority)
	select distinct(productID),row from #tSort
	where #tSort.productid in (select productid from #tGifts)
	Order By #tSort.row

	set @total_products = @@rowcount
	end

if (@sortAttributeID = 0 )
	begin

	Insert into #tPaging(productid,priority)
	select distinct(productID),priority from #tProducts tp
	where tp.productid in (select productid from #tGifts)
	order by tp.productid desc
	set @total_products = @@rowcount
	end
 
 
if(@size = 0)
select (@total_products) as productCount, p.*
from #tProducts p, #tPaging pg
WHERE p.productid = pg.productid
Order by pg.priority


if(@size > 0)
select (@total_products) as productCount, p.*
from #tProducts p, #tPaging pg
WHERE (pg.Row >= @Start) AND (pg.Row <= @End)
and p.productid = pg.productid
Order by pg.priority


Select  t.attributetypeid,t.attributeTypeName,t.attributeTypeDescription,t.attributeTypeCountOfValues,
 c.attributeCollectionId,c.attributeid,
 a.attributeName,a.attributeSource,a.dropdownDescription,a.multiValue,a.labelDescription
 ,'0' as categoryId,acl.displayMultiValues
From  b4nAttributeType t with(nolock), 
 b4nAttribute a with(nolock),
 b4nAttributeInCollection c with(nolock)
  left outer join b4nAttributeCollection acl with(nolock) on c.attributeCollectionID = acl.attributeCollectionID
 

Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = 1
and a.attributesource = 'S'
and a.attributeID in
 (select cd.content from b4ncollectiondisplay cd with(nolock)
  where cd.attributecollectionID = c.attributeCollectionID
   and cd.viewtypeID = @viewTypeID
   and cd.contenttype = 'A')
 

end






GRANT EXECUTE ON b4nGetGiftGenData TO b4nuser
GO
GRANT EXECUTE ON b4nGetGiftGenData TO helpdesk
GO
GRANT EXECUTE ON b4nGetGiftGenData TO ofsuser
GO
GRANT EXECUTE ON b4nGetGiftGenData TO reportuser
GO
GRANT EXECUTE ON b4nGetGiftGenData TO b4nexcel
GO
GRANT EXECUTE ON b4nGetGiftGenData TO b4nloader
GO
