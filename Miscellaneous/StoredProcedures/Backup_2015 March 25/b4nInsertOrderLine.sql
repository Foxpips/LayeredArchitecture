

/****** Object:  Stored Procedure dbo.b4nInsertOrderLine    Script Date: 23/06/2005 13:32:11 ******/

CREATE  proc dbo.b4nInsertOrderLine
@nStoreID int =1,
@nOrderRef int,
@nProductID real=0,
@nQuantity real,
@Instructions text = '',
@Price money=0,
@itemName varchar(1000) = '',
@giftWrappingTypeId int =0,
@giftWrappingDescription varchar(2000) = '',
@giftWrappingCost money = 0,
@gen1 varchar(80) = '',
@gen2 varchar(80)  = '',
@gen3 varchar(80) = '',
@gen4 varchar(80) = '',
@gen5 varchar(80) = '',
@gen6 varchar(80) = ''

as
begin
set nocount on

insert into b4norderline
(
storeid,OrderRef,ProductID,Quantity,Instructions,Price,
createDate,modifyDate,itemName,giftWrappingTypeId,giftWrappingDescription,
giftWrappingCost,gen1,gen2,gen3,gen4,gen5,gen6
)
values
(
@nStoreID,@nOrderRef,@nProductID,@nQuantity,@Instructions,@Price,
getdate(),getdate(),@itemName,@giftWrappingTypeId,@giftWrappingDescription,
@giftWrappingCost,@gen1,@gen2,@gen3,@gen4,@gen5,@gen6
)

end







GRANT EXECUTE ON b4nInsertOrderLine TO b4nuser
GO
GRANT EXECUTE ON b4nInsertOrderLine TO helpdesk
GO
GRANT EXECUTE ON b4nInsertOrderLine TO ofsuser
GO
GRANT EXECUTE ON b4nInsertOrderLine TO reportuser
GO
GRANT EXECUTE ON b4nInsertOrderLine TO b4nexcel
GO
GRANT EXECUTE ON b4nInsertOrderLine TO b4nloader
GO
