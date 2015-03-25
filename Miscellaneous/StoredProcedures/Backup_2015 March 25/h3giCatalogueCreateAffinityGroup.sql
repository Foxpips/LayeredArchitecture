
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreateAffinityGroup
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Creates a new affinity group, or updates its name if it exists
**					
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giCatalogueCreateAffinityGroup
	@affinityGroupId int, 
	@affinityGroupName nvarchar(255)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM h3giAffinityGroup WHERE groupID = @affinityGroupId)
	INSERT INTO h3giAffinityGroup (groupID, groupName)
	VALUES  (@affinityGroupId, @affinityGroupName);
ELSE
	UPDATE h3giAffinityGroup
	SET groupName = @affinityGroupName
	WHERE groupID = @affinityGroupId;
END


GRANT EXECUTE ON h3giCatalogueCreateAffinityGroup TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueCreateAffinityGroup TO reportuser
GO
