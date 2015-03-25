
/***********************************************************************************************************************
* Change Control
* GH - 11/08/2011 - added @loopVar parameter to handle multisettle (where there could more than 1 orderref per @transactionid)
************************************************************************************************************************/

CREATE  proc [dbo].[b4nCCUpdateTransactionLog]
@orderref varchar(50),
@transactionid varchar(50),
@loopVar int = 1
as
begin
	update b4nCCTransactionLog
	set B4NOrderRef = @orderref 
	where orderref = @transactionid
	and B4NOrderRef = @loopVar
	
end



GRANT EXECUTE ON b4nCCUpdateTransactionLog TO b4nuser
GO
