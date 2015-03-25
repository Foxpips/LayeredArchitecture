
create proc [dbo].[h3giRemoveFromBatch]
	@orderRef int
as
begin
	declare @batchId int
	select @batchId = BatchId from h3giBatchOrder where OrderRef = @orderRef

	delete from h3giBatchOrder where OrderRef = @orderRef

	declare @batchCount int
	select @batchCount = count(*) from h3giBatchOrder where BatchId = @batchId

	if(@batchCount = 0)
	begin
		delete from h3giBatch where BatchId = @batchId
	end
end
GRANT EXECUTE ON h3giRemoveFromBatch TO b4nuser
GO
