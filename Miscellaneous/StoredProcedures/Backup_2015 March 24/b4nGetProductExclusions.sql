

/****** Object:  Stored Procedure dbo.b4nGetProductExclusions    Script Date: 23/06/2005 13:31:59 ******/


CREATE PROCEDURE dbo.b4nGetProductExclusions
@productFamilyID int
AS
set nocount on

select * from b4nattributeproductexclude with(nolock)
where productfamilyID = @productfamilyID

select count(distinct(exclusionID)) as exclusionCount from b4nattributeproductexclude with(nolock)
where productfamilyID = @productfamilyID





GRANT EXECUTE ON b4nGetProductExclusions TO b4nuser
GO
GRANT EXECUTE ON b4nGetProductExclusions TO helpdesk
GO
GRANT EXECUTE ON b4nGetProductExclusions TO ofsuser
GO
GRANT EXECUTE ON b4nGetProductExclusions TO reportuser
GO
GRANT EXECUTE ON b4nGetProductExclusions TO b4nexcel
GO
GRANT EXECUTE ON b4nGetProductExclusions TO b4nloader
GO
