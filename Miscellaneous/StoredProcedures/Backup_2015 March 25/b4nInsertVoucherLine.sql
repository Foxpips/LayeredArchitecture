

/****** Object:  Stored Procedure dbo.b4nInsertVoucherLine    Script Date: 23/06/2005 13:32:12 ******/




CREATE  Proc [dbo].[b4nInsertVoucherLine]
@orderRef int,
@voucherPromotionId real,
@voucherValue real,
@voucherDescription varchar(200)

AS
set nocount on

Begin

Insert into SMOrderLine
	(OrderRef,ProductID,Quantity,UnitID,Instructions,Price)
Select @orderRef,@voucherPromotionId,1,1,@voucherDescription,@voucherValue

End





GRANT EXECUTE ON b4nInsertVoucherLine TO b4nuser
GO
GRANT EXECUTE ON b4nInsertVoucherLine TO helpdesk
GO
GRANT EXECUTE ON b4nInsertVoucherLine TO ofsuser
GO
GRANT EXECUTE ON b4nInsertVoucherLine TO reportuser
GO
GRANT EXECUTE ON b4nInsertVoucherLine TO b4nexcel
GO
GRANT EXECUTE ON b4nInsertVoucherLine TO b4nloader
GO
