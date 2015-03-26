


/********************************************************************
*	Change Control:		
*		15/11/2010	-	Stephen Quin	-	now also returns b4nValid
*********************************************************************/
CREATE PROCEDURE [dbo].[h3giGetClasscodes] AS

select b4nClassSysID, b4nClassCode, b4nClassDesc, b4nValid from b4nClassCodes




GRANT EXECUTE ON h3giGetClasscodes TO b4nuser
GO
GRANT EXECUTE ON h3giGetClasscodes TO ofsuser
GO
GRANT EXECUTE ON h3giGetClasscodes TO reportuser
GO
