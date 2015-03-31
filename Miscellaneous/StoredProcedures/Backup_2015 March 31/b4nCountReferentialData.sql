

/****** Object:  Stored Procedure dbo.b4nCountReferentialData    Script Date: 23/06/2005 13:31:04 ******/
CREATE      proc dbo.b4nCountReferentialData
@referentialType varchar(50),
@linkFrom varchar(50),
@customerId int = 0,
@referentialCount int output

as

set nocount on

begin



if (@customerid != 0)
	Begin
		set @referentialCount = 
		(
		select count(p.productid)
		From 	 b4nReferential r with(Nolock), b4nProductFamily pf with(nolock), b4nProduct p with(nolock), b4nattributecollection ac with(nolock)
		where  r.referentialType = @referentialType
			  and r.linkFrom = @linkFrom
			  and cast(r.linkTo as int) = p.productid
			  and p.productfamilyid = pf.productfamilyid
			  and p.deleted = 0
			  and pf.attributeCollectionID = ac.attributeCollectionID
			  and r.linkto not in (select cast(ba.productid as varchar(20)) from b4nbasket ba with(nolock) where ba.customerid = @customerId) 
		)
	End
else
	Begin
		set @referentialCount = 
		(
		select count(p.productid)
		From 	 b4nReferential r with(Nolock), b4nProductFamily pf with(nolock), b4nProduct p with(nolock), b4nattributecollection ac with(nolock)
		where  r.referentialType = @referentialType
			  and r.linkFrom = @linkFrom
			  and cast(r.linkTo as int) = p.productid
			  and p.productfamilyid = pf.productfamilyid
			  and p.deleted = 0
			  and pf.attributeCollectionID = ac.attributeCollectionID
		)
	End


select @referentialCount
end




GRANT EXECUTE ON b4nCountReferentialData TO b4nuser
GO
GRANT EXECUTE ON b4nCountReferentialData TO helpdesk
GO
GRANT EXECUTE ON b4nCountReferentialData TO ofsuser
GO
GRANT EXECUTE ON b4nCountReferentialData TO reportuser
GO
GRANT EXECUTE ON b4nCountReferentialData TO b4nexcel
GO
GRANT EXECUTE ON b4nCountReferentialData TO b4nloader
GO
