

/****** Object:  Stored Procedure dbo.b4nGetGiftDetails    Script Date: 23/06/2005 13:31:48 ******/


CREATE  PROCEDURE dbo.b4nGetGiftDetails
@attributeid int
 AS
begin

if not exists(select attributevalue from b4nattributebase where attributeid = @attributeid)
begin

select distinct f.attributevalue as attributeValue,
 f.attributevalue as displayvalue,1 as priority
 from b4nattributeproductfamily f with(nolock)
 where attributeid = @attributeid


union
select '0' as attributeValue,dropdowndescription as displayvalue,0 as priority
from b4nattribute 
where attributeid = @attributeid
and attributeSource = 'C'
order  by priority, attributevalue asc
end
else
begin

select ab.attributeValue,ab.displayvalue,ab.priority
from b4nattribute a,b4nattributebase ab
where a.attributeid = @attributeid
and a.attributeid = ab.attributeid
union
select '0' as attributeValue,dropdowndescription as displayvalue,0 as priority
from b4nattribute 
where attributeid = @attributeid
and attributeSource = 'C'
order  by priority, attributevalue asc


end




end





GRANT EXECUTE ON b4nGetGiftDetails TO b4nuser
GO
GRANT EXECUTE ON b4nGetGiftDetails TO helpdesk
GO
GRANT EXECUTE ON b4nGetGiftDetails TO ofsuser
GO
GRANT EXECUTE ON b4nGetGiftDetails TO reportuser
GO
GRANT EXECUTE ON b4nGetGiftDetails TO b4nexcel
GO
GRANT EXECUTE ON b4nGetGiftDetails TO b4nloader
GO
