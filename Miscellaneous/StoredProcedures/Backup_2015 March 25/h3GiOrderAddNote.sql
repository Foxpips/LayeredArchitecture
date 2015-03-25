

/****** Object:  Stored Procedure dbo.h3GiOrderAddNote    Script Date: 23/06/2005 13:35:02 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3GiOrderAddNote
** Author		:	Padraig Gorry
** Date Created		:	
** Version		:	
**					
**********************************************************************************************************************
**				
** Description		:	Adds a note to an order
**					
**********************************************************************************************************************
**									
** Change Control	:	12-May-2005- Padraig Gorry - Created
**********************************************************************************************************************/
CREATE PROCEDURE h3GiOrderAddNote (
@OrderRef as int,
@Note as varchar(1000),
@userID as int,
@Sensitive as bit
)
AS


BEGIN TRAN

IF @Note <> ''
BEGIN 
	INSERT INTO h3giNotes 
		(orderRef, userID, noteTime, noteText, sensitive) 
	VALUES
		(@OrderRef, @UserID, getdate(), @Note, @Sensitive)
END

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END

COMMIT TRAN


GRANT EXECUTE ON h3GiOrderAddNote TO b4nuser
GO
GRANT EXECUTE ON h3GiOrderAddNote TO helpdesk
GO
GRANT EXECUTE ON h3GiOrderAddNote TO ofsuser
GO
GRANT EXECUTE ON h3GiOrderAddNote TO reportuser
GO
GRANT EXECUTE ON h3GiOrderAddNote TO b4nexcel
GO
GRANT EXECUTE ON h3GiOrderAddNote TO b4nloader
GO
