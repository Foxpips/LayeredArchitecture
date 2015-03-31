

/****** Object:  Stored Procedure dbo.b4nGetGiftWrappingCost    Script Date: 23/06/2005 13:31:51 ******/


CREATE PROCEDURE dbo.b4nGetGiftWrappingCost
@giftwrappingtypeid int
AS
select * from b4nGiftWrappingOptions
where giftwrappingtypeid = @giftwrappingtypeid




GRANT EXECUTE ON b4nGetGiftWrappingCost TO b4nuser
GO
GRANT EXECUTE ON b4nGetGiftWrappingCost TO helpdesk
GO
GRANT EXECUTE ON b4nGetGiftWrappingCost TO ofsuser
GO
GRANT EXECUTE ON b4nGetGiftWrappingCost TO reportuser
GO
GRANT EXECUTE ON b4nGetGiftWrappingCost TO b4nexcel
GO
GRANT EXECUTE ON b4nGetGiftWrappingCost TO b4nloader
GO
