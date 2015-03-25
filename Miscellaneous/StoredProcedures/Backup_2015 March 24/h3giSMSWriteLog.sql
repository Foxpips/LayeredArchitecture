create proc dbo.h3giSMSWriteLog
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giSMSWriteLog
** Author		:	John Hannon
** Date Created		:	04/01/2006
** Version		:	1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure runs against the h3gi database on 172.28.1.36. It logs 
**				the results of SMS sends from the SMS sender application.
**					
**********************************************************************************************************************
**									
** Change Control	:		
**						
**********************************************************************************************************************/
@logError int,
@logDate datetime,
@logDescription varchar(255)
as
begin
	insert into h3giSMSLog
	select @logError,@logDate,@logDescription
end


GRANT EXECUTE ON h3giSMSWriteLog TO b4nuser
GO
GRANT EXECUTE ON h3giSMSWriteLog TO ofsuser
GO
GRANT EXECUTE ON h3giSMSWriteLog TO reportuser
GO
