

/****** Object:  Stored Procedure dbo.b4nDataLoader    Script Date: 23/06/2005 13:31:06 ******/


CREATE proc b4nDataLoader
AS
Begin

CREATE table #PricePerUnit(
	productfamilyid	int,
	pricePerUnit	varchar(20),
	perUnit		varchar(20)
)

Declare @currentDate smalldatetime
Set @currentdate = getdate()

Delete from dataloader
Where isNumeric(pipcode) = 0

Delete from dataloader
Where ltrim(rtrim(pipcode)) not in 
	(select ltrim(rtrim(attributevalue)) from b4nattributeproductfamily with(nolock) where attributeid = 3)

Insert Into #PricePerUnit
Select a.productfamilyid,cast((cast(d.price as real) / cast(d.unitQuantity as real) * g.unitRate) as decimal(6,2)) as pricePerUnit,
	('per ' + g.unitParentCode) as perUnit
From 	genUnit g with(nolock),
	dataloader d with(nolock) 
		left outer join b4nattributeproductfamily a with(nolock) 
			on d.pipcode = a.attributevalue 
where a.attributeid = 3					
	and ltrim(rtrim(d.unitCode)) = ltrim(rtrim(g.unitCode))
	and cast(d.unitQuantity as real) > 49
	and cast(d.price as real) > 0
	and isNumeric(a.attributevalue) = 1

Update b4nAttributeProductFamily
Set attributevalue = '€ ' + pricePerUnit + ' '+ perUnit
From #PricePerUnit u
Where u.productfamilyid = b4nattributeproductfamily.productfamilyid
	and b4nattributeproductfamily.attributeid = 220


End




GRANT EXECUTE ON b4nDataLoader TO b4nuser
GO
GRANT EXECUTE ON b4nDataLoader TO helpdesk
GO
GRANT EXECUTE ON b4nDataLoader TO ofsuser
GO
GRANT EXECUTE ON b4nDataLoader TO reportuser
GO
GRANT EXECUTE ON b4nDataLoader TO b4nexcel
GO
GRANT EXECUTE ON b4nDataLoader TO b4nloader
GO
