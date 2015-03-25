

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCreateSMSGroup
** Author		:	Peter Murphy
** Date Created		:	22/03/06
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure creates an SMSGroupHeader
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 


CREATE  procedure h3giCreateSMSGroup

@GroupName varchar(100),
@GroupTypeID int

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
select @RecFound = count(*) from h3giSMSGroupHeader where h3giSMSGroupHeader.GroupName = @GroupName
if @RecFound > 0
BEGIN
	return 2
END


--Try to insert records
BEGIN TRAN

INSERT INTO h3giSMSGroupHeader(GroupID, GroupName, GroupTypeID)
VALUES(@NextID, @GroupName,@GroupTypeID)


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


GRANT EXECUTE ON h3giCreateSMSGroup TO b4nuser
GO
GRANT EXECUTE ON h3giCreateSMSGroup TO ofsuser
GO
GRANT EXECUTE ON h3giCreateSMSGroup TO reportuser
GO
