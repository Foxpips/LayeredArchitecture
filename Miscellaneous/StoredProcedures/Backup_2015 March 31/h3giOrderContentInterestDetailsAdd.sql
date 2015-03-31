

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giOrderContentInterestAdd
** Author			:	Audrey Pender
** Date Created		:	27/02/2007
**					
**********************************************************************************************************************
**				
** Description		:	Adds content interest item to dbo.h3giOrderContentInterestDetails			
**
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giOrderContentInterestDetailsAdd]
	@contentInterestID INT,
	@contentInterestList VARCHAR(4000)
	
AS
BEGIN

SET NOCOUNT ON;


	INSERT INTO dbo.h3giOrderContentInterestDetails
	(
		contentInterestId,
		contentCode
	)
	SELECT 
		@contentInterestID,
		value
	FROM dbo.[fnSplitter](@contentInterestList)


END
 


GRANT EXECUTE ON h3giOrderContentInterestDetailsAdd TO b4nuser
GO
