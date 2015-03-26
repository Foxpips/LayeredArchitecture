

/****** Object:  Stored Procedure dbo.b4nUpdateOrderStatus    Script Date: 23/06/2005 13:32:52 ******/




CREATE  proc  dbo.b4nUpdateOrderStatus
@nStoreID 		INT=1,
@nCustomerID 		INT=1,
@nStatus 		INT=101,
@nOrderRef		int,
@status			int output
as
begin
set nocount on

	DECLARE @attempt 		INT
	DECLARE @error_no 		INT
	DECLARE @stage 			VARCHAR(20)
	declare	@resultrowcount		int

	set @status =0
		
	begin transaction

	update b4nOrderheader
	set status = @nStatus where orderref = @nOrderRef
	SELECT @error_no = @@error, @resultrowcount = @@rowcount
	IF ( @resultrowcount = 0 )
	BEGIN
			set @status = 1
			GOTO error
	END

	SET @stage = 'stage 1'

	-- Remove Items from basket
	DELETE FROM b4nBasketAttribute WHERE basketid in (SELECT basketid FROM b4nbasket WHERE CustomerId = @nCustomerId AND storeId = @nStoreId)	
	DELETE FROM b4nBasket WHERE  CustomerId = @nCustomerId AND storeId = @nStoreId

	-- Handle Error
	SELECT @error_no = @@error, @resultrowcount = @@rowcount
	IF ( @resultrowcount = 0 )
	BEGIN
		set @status = 2
		GOTO error
	END
	commit transaction

goto finished

error:
ROLLBACK TRAN
goto finished
noerror:
set @status = 3

finished:
select @status
end





GRANT EXECUTE ON b4nUpdateOrderStatus TO b4nuser
GO
GRANT EXECUTE ON b4nUpdateOrderStatus TO helpdesk
GO
GRANT EXECUTE ON b4nUpdateOrderStatus TO ofsuser
GO
GRANT EXECUTE ON b4nUpdateOrderStatus TO reportuser
GO
GRANT EXECUTE ON b4nUpdateOrderStatus TO b4nexcel
GO
GRANT EXECUTE ON b4nUpdateOrderStatus TO b4nloader
GO
