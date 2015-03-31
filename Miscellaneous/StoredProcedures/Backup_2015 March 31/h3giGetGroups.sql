

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetGroups
** Author		:	Peter Murphy
** Date Created		:	20/03/06
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure returns a list of all SMS groups
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/


CREATE procedure dbo.h3giGetGroups

@GroupID varchar(4) = ''

AS

DECLARE @SQL varchar(500)

SET @SQL =
'select Head.GroupID, Head.GroupTypeID, Head.GroupName, CC.b4nClassDesc as GroupTypeName
from h3giSMSGroupHeader Head
join b4nClassCodes CC on CC.b4nClassCode = Head.groupTypeID
where Head.Visible = 1 and CC.b4nClassSysID = ''SMSGroupType'''

IF NOT @GroupID = ''
BEGIN
	SET @SQL = @SQL + ' and Head.GroupID = ''' + @GroupID + ''''
END

SET @SQL = @SQL + ' order by Head.GroupName'

EXEC(@SQL)


GRANT EXECUTE ON h3giGetGroups TO b4nuser
GO
GRANT EXECUTE ON h3giGetGroups TO ofsuser
GO
GRANT EXECUTE ON h3giGetGroups TO reportuser
GO
