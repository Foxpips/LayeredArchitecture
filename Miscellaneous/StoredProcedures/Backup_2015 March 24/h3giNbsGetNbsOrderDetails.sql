
CREATE proc [dbo].[h3giNbsGetNbsOrderDetails]
	@orderref int
as
begin
	select nbsLevel from h3giOrderHeader with(nolock) where orderref = @orderref
end

GRANT EXECUTE ON h3giNbsGetNbsOrderDetails TO b4nuser
GO
