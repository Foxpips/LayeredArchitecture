


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAffinityGroupsGet
** Author			:	Adam Jasinski
** Date Created		:	08/05/2007
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Returns list of affinity groups
**		
** Parameters		:   @all: if 0, return groups with groupIDs > 1 only; otherwise return 	all groups
**
** Changes			:	Stephen Quin	-	10/01/2011	-	added new parameters @channelCode, @retailerCode and 
**															@storeCode and joined to the h3giAffinittyRetailers table 
**															using these parameters	
**						Stephen Quin	-	22/03/2011	-	Had to make a change to return all affinity groups if all 
**															was set. This was part of the Deposit Session Issue Hotfix	
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giAffinityGroupsGet]  
	@all int = 0,
	@channelCode VARCHAR(20),
	@retailerCode VARCHAR(20),
	@storeCode VARCHAR(20)
AS  
BEGIN  

	IF(@all = 1)
	BEGIN
		SELECT	affGroup.groupID, 
				affGroup.groupName
		FROM	h3giAffinityGroup affGroup
		WHERE	affGroup.groupID > 1
		AND	affGroup.deleted = 0
	END
	ELSE
	BEGIN
		SELECT	affGroup.groupID, 
				affGroup.groupName
		FROM h3giAffinityGroup affGroup
		INNER JOIN h3giAffinityRetailers affRetailers
			ON affGroup.groupID = affRetailers.affinityGroupId
			AND affRetailers.channelCode = @channelCode
			AND affRetailers.retailerCode = @retailerCode
			AND affRetailers.storeCode = @storeCode
			AND affGroup.deleted = 0
		WHERE affGroup.groupID > 1
		ORDER BY affGroup.groupID ASC
	END
END
  





GRANT EXECUTE ON h3giAffinityGroupsGet TO b4nuser
GO
GRANT EXECUTE ON h3giAffinityGroupsGet TO ofsuser
GO
GRANT EXECUTE ON h3giAffinityGroupsGet TO reportuser
GO
