

/****** Object:  Stored Procedure dbo.b4nGetReferentialMenu    Script Date: 23/06/2005 13:32:02 ******/


create procedure b4nGetReferentialMenu
@parentCategoryID varchar(40)
as
begin
select * from b4nReferentialMenu with(nolock)  
 order by priority,menuTitle  
end





GRANT EXECUTE ON b4nGetReferentialMenu TO b4nuser
GO
GRANT EXECUTE ON b4nGetReferentialMenu TO helpdesk
GO
GRANT EXECUTE ON b4nGetReferentialMenu TO ofsuser
GO
GRANT EXECUTE ON b4nGetReferentialMenu TO reportuser
GO
GRANT EXECUTE ON b4nGetReferentialMenu TO b4nexcel
GO
GRANT EXECUTE ON b4nGetReferentialMenu TO b4nloader
GO
