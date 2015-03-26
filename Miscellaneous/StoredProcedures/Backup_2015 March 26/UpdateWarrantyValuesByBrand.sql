

/****** Object:  Stored Procedure dbo.UpdateWarrantyValuesByBrand    Script Date: 23/06/2005 13:30:54 ******/


create  procedure dbo.UpdateWarrantyValuesByBrand
as
begin

declare @pId as int
declare @attId as int
declare @attValue as varchar(1000)

set @pId = 0
set @attId = 0 
set @attValue = ''

--Updates b4nAttributeProductFamily by adding the row to each product that doesnt have the warranty row

declare tmpCursor CURSOR Global
for select distinct apf.productfamilyid 
from b4nAttributeProductFamily apf
where 122 not in (select attributeid from b4nAttributeProductFamily where productfamilyid = apf.productfamilyid)

open tmpCursor
Fetch tmpCursor into @pId -- prime the cursor
while @@Fetch_status = 0
Begin

	insert into b4nAttributeProductFamily(productFamilyId,storeId,attributeId,attributeValue,multiValuePriority,
	attributeAffectsBasePriceBy,attributeAffectsRRPPriceBy,attributeImageName,attributeImageNameSmall,modifyDate,
	createDate)
	Values(@pId,'1','122','warranty stuff','0','0.0','0.0','','',getDate(),getDate())

	Fetch tmpCursor into @pid -- fetch next
end
close tmpCursor
deallocate tmpCursor

--end of 

--This section selects a list of all products for the list of brands, then will update the warranty info for each product
declare productCursor CURSOR Global
for select productFamilyId, attributeid, attributeValue from b4nAttributeProductFamily where (attributeValue like '%bosch%' or attributeValue like '%Paykel%' 
or attributeValue like '%Siemens%' or attributeValue like '%Britannia%' or attributeValue like '%Miele%' or attributeValue like '%Dietrich%'
or attributeValue like '%smeg%' or attributeValue like '%hotpoint%' or attributeValue like '%creda%' or attributeValue like '%cannon%' 
or attributeValue like '%lieb%' or attributeValue like '%lemax%' or attributeValue like '%sony%' or attributeValue like '%phillips%'
or attributeValue like '%philips%' or attributeValue like '%whirlpool%')
and attributeid = 2
order by attributevalue


open productCursor
Fetch productCursor into @pId,@attId,@attValue -- prime the cursor
while @@Fetch_status = 0
Begin
	if @attValue like '%bosch%' or @attValue like '%Paykel%' or @attValue like '%Siemens%' or @attValue like '%Britannia%' or @attValue like '%Miele%'
	Begin
		update b4nAttributeProductFamily set attributeValue = '2 Years Parts & Service' where attributeid = 122 and productFamilyId = @pId
	end 
	
	else if @attValue like '%Dietrich%' or @attValue like '%smeg%' 
	Begin
		update b4nAttributeProductFamily set attributeValue = '3 Years Parts & Service' where attributeid = 122 and productFamilyId = @pId
	end 
	
	else if @attValue like '%hotpoint%' or @attValue like '%creda%' or @attValue like '%cannon%' or @attValue like '%lieb%' 
	Begin
		update b4nAttributeProductFamily set attributeValue = '5 Years Parts & Service' where attributeid = 122 and productFamilyId = @pId
	end 
	
	else if @attValue like '%lemax%' or @attValue like '%sony%' or @attValue like '%phillips%' or @attValue like '%philips%' 
	Begin
		update b4nAttributeProductFamily set attributeValue = '1 Year Parts & Service' where attributeid = 122 and productFamilyId = @pId
	end 
	
	else if @attValue like '%whirlpool%'
	Begin
		update b4nAttributeProductFamily set attributeValue = '8 Years Parts & Service' where attributeid = 122 and productFamilyId = @pId
	end 
	
	Fetch productCursor into @pid,@attId,@attValue -- fetch next
end
close productCursor
deallocate productCursor

--end of

end





GRANT EXECUTE ON UpdateWarrantyValuesByBrand TO b4nuser
GO
GRANT EXECUTE ON UpdateWarrantyValuesByBrand TO helpdesk
GO
GRANT EXECUTE ON UpdateWarrantyValuesByBrand TO ofsuser
GO
GRANT EXECUTE ON UpdateWarrantyValuesByBrand TO reportuser
GO
GRANT EXECUTE ON UpdateWarrantyValuesByBrand TO b4nexcel
GO
GRANT EXECUTE ON UpdateWarrantyValuesByBrand TO b4nloader
GO
