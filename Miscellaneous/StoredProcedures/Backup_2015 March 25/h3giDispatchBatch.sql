

/****** Object:  Stored Procedure dbo.h3giDispatchBatch    Script Date: 23/06/2005 13:35:10 ******/
CREATE PROCEDURE dbo.h3giDispatchBatch
@BatchID int

AS

UPDATE h3giBatch SET status = 3 WHERE BatchID = @BatchID


GRANT EXECUTE ON h3giDispatchBatch TO b4nuser
GO
GRANT EXECUTE ON h3giDispatchBatch TO helpdesk
GO
GRANT EXECUTE ON h3giDispatchBatch TO ofsuser
GO
GRANT EXECUTE ON h3giDispatchBatch TO reportuser
GO
GRANT EXECUTE ON h3giDispatchBatch TO b4nexcel
GO
GRANT EXECUTE ON h3giDispatchBatch TO b4nloader
GO
