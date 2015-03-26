
/*********************************************************************************************************************
**																					
** Procedure Name	:	[h3giCheckIsClickAndCollect]
** Author			:	Simon Markey
** Date Created		:	21/03/2013
** Version			:	1.0.0
**					
** Test				:	exec [h3giCheckIsClickAndCollect] 12341
**********************************************************************************************************************
**				
** Description		:	Check if order is a click and collect order for credit checking purposes
**					
**********************************************************************************************************************
**				
** Change Log		:	<Modification date> - <Developer name> - <Description>
**					
**********************************************************************************************************************/



CREATE PROCEDURE [dbo].[h3giCheckIsClickAndCollect](@OrderRef int)  
AS  
SELECT IsClickAndCollect  
FROM h3giOrderheader
WHERE orderref = @OrderRef  

GRANT EXECUTE ON h3giCheckIsClickAndCollect TO b4nuser
GO
