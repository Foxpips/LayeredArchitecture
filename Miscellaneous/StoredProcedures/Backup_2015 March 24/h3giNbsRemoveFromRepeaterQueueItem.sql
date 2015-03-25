
create proc h3giNbsRemoveFromRepeaterQueueItem
	@orderref int,
	@state int
as
begin
	update 
		h3giNbsRepeaterQueue
	set
		[state] = @state,
		auditTimestamp = getdate()
	where
		orderref = @orderref
end

GRANT EXECUTE ON h3giNbsRemoveFromRepeaterQueueItem TO b4nuser
GO
