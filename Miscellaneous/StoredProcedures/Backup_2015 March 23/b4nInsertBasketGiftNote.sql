

/****** Object:  Stored Procedure dbo.b4nInsertBasketGiftNote    Script Date: 23/06/2005 13:32:11 ******/


CREATE procedure dbo.b4nInsertBasketGiftNote
@nBasketId int,
@nNote varchar(8000)
as
declare @action int
set @action = (select isnull(basketid,0) from b4nbasketattribute where basketid = @nBasketId and attributeid = 1074)

if (@action > 0)
begin
	update b4nbasketAttribute
	set attributeuservalue = @nNote
	where basketid = @nBasketid 
	and attributeid = 1074
end
else
begin
	insert into b4nBasketAttribute (basketid,attributeid,attributeuservalue)
	values (@nBasketId,1074,@nNote)
end




GRANT EXECUTE ON b4nInsertBasketGiftNote TO b4nuser
GO
GRANT EXECUTE ON b4nInsertBasketGiftNote TO helpdesk
GO
GRANT EXECUTE ON b4nInsertBasketGiftNote TO ofsuser
GO
GRANT EXECUTE ON b4nInsertBasketGiftNote TO reportuser
GO
GRANT EXECUTE ON b4nInsertBasketGiftNote TO b4nexcel
GO
GRANT EXECUTE ON b4nInsertBasketGiftNote TO b4nloader
GO
