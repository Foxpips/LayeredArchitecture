

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giOrderContentInterestAdd
** Author			:	Audrey Pender
** Date Created		:	27/02/2008
**
** Changes:
					 10/03/2008 - Adam Jasinski - contentInterestId is an Identity column now
**********************************************************************************************************************
**				
** Description		:	Adds content interest item to dbo.h3giOrderContentInterest			
**
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giOrderContentInterestAdd]
	@orderRef INT,
	@email VARCHAR(255),
	@contentInterestID INT OUT
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO dbo.h3giOrderContentInterest
	(
		orderRef,
		email
	)
	VALUES
	(
		@orderRef,
		@email
	);
	
	SELECT @contentInterestID = SCOPE_IDENTITY();

END

GRANT EXECUTE ON h3giOrderContentInterestAdd TO b4nuser
GO
