

/****** Object:  Stored Procedure dbo.h3GiLogAuditEvent    Script Date: 23/06/2005 13:35:01 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3GiLogAuditEvent
** Author		:	Padraig Gorry
** Date Created		:	
** Version		:	
**					
**********************************************************************************************************************
**				
** Description		:	Logs a new Audit Event
**					
**********************************************************************************************************************
**									
** Change Control	:	9-May-2005- Padraig Gorry - Created
**********************************************************************************************************************/
CREATE PROCEDURE h3GiLogAuditEvent (
@OrderRef as int,
@Event as varchar(20),
@Info as varchar(1000),
@userID as int
)
AS

BEGIN TRAN

INSERT INTO h3giAudit (auditEvent, orderRef, auditTime, userID, auditInfo)
VALUES (@Event, @OrderRef, getdate(), @userID, @Info)

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END


COMMIT TRAN


GRANT EXECUTE ON h3GiLogAuditEvent TO b4nuser
GO
GRANT EXECUTE ON h3GiLogAuditEvent TO helpdesk
GO
GRANT EXECUTE ON h3GiLogAuditEvent TO ofsuser
GO
GRANT EXECUTE ON h3GiLogAuditEvent TO reportuser
GO
GRANT EXECUTE ON h3GiLogAuditEvent TO b4nexcel
GO
GRANT EXECUTE ON h3GiLogAuditEvent TO b4nloader
GO
