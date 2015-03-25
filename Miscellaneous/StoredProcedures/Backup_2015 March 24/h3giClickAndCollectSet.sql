

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giClickAndCollectSet
** Author			:	Stephen King
** Date Created		:	06/03/2013
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Sets whether a handset is click and collectable. If not it deletes the row
**					
**********************************************************************************************************************
**				
** Change Log		:	<Modification date> - <Developer name> - <Description>
**					
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giClickAndCollectSet]
	@PeopleSoftId varchar(50), 
	@isEnabled bit
AS
BEGIN
	if (@isEnabled = 1)
	Begin
		if not exists( select *  from h3giClickAndCollect where PeopleSoftId = @PeopleSoftId)
			insert into h3giClickAndCollect (PeopleSoftId) Values (@PeopleSoftId)
	end
	else
	Begin
		delete from h3giClickAndCollect where PeopleSoftId = @PeopleSoftId
	end
END

GRANT EXECUTE ON h3giClickAndCollectSet TO b4nuser
GO
