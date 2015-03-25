
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAccChangeRequestFields_Create
** Author			:	N/A
** Date Created		:	N/A
**					
**********************************************************************************************************************
**				
** Description		:	Returns the Customer Service Request field values submitted by a customer
**					
**********************************************************************************************************************
**									
** Change Control	:	07/09/2012	Changed intVal to be a varchar in order to allow leading zeros to be stored for bank
									account numbers (BRT requested)
**********************************************************************************************************************/


CREATE PROCEDURE [dbo].[h3giAccChangeRequestFields_Create] 
@requestHeaderId INT,
@fieldTypeId INT,
@intVal VARCHAR(100),
@varCharMaxVal VARCHAR(max)

AS
BEGIN

	INSERT INTO [dbo].[h3giAccChangeRequestFields]
			([RequestHeaderId]
			,[FieldTypeId]
			,[IntVal]
			,[VarCharMaxVal])
		VALUES
			(@requestHeaderId
			,@fieldTypeId
			,@intVal
			,@varCharMaxVal)
END



GRANT EXECUTE ON h3giAccChangeRequestFields_Create TO b4nuser
GO
