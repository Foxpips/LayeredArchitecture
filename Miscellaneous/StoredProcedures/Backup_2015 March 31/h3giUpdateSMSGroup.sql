
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giUpdateSMSGroup
** Author		:	Peter Murphy
** Date Created		:	22/03/06
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure updates an SMSGroupHeader
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 


CREATE procedure dbo.h3giUpdateSMSGroup

@GroupName varchar(100),
@GroupTypeID int,
@GroupID int

AS

DECLARE @ErrorCount int
DECLARE @ErrorCode int
DECLARE @RecFound int
DECLARE @NextID int


--Get the last used ID and add 1
select @NextID = max(groupID) from h3giSMSGroupHeader
SET @NextID = @NextID + 1


SET @ErrorCount = 0
 

--Check if the Group Name is already in use
select @RecFound = count(*) from h3giSMSGroupHeader 
where h3giSMSGroupHeader.GroupName = @GroupName
  and h3giSMSGroupHeader.GroupID <> @GroupID

if @RecFound > 0
BEGIN
	return 2
END


--Try to insert records
BEGIN TRAN

update h3giSMSGroupHeader
set GroupName = @GroupName,
    GroupTypeID = @GroupTypeID
where GroupID = @GroupID


SET @ErrorCode = @@ERROR
if @ErrorCode > 0
BEGIN
	SET @ErrorCount = @ErrorCount + 1
END


--If there were any errors, abort and return 1, otherwise commit and return 0
if @ErrorCount > 0
BEGIN
	ROLLBACK TRAN
	return 1
END
ELSE
BEGIN
	COMMIT TRAN
	return 0
END


GRANT EXECUTE ON h3giUpdateSMSGroup TO b4nuser
GO
GRANT EXECUTE ON h3giUpdateSMSGroup TO ofsuser
GO
GRANT EXECUTE ON h3giUpdateSMSGroup TO reportuser
GO
