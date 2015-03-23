


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreateTACCode
** Author			:	Adam Jasinski 
** Date Created		:	08/12/2006
**					
**********************************************************************************************************************
**				
** Description		:	Sets up a TAC code for a handset - for EACH existing contract, prepay and upgrade handset of given peopleSoftID				
**					
**********************************************************************************************************************
**									
** Change Control	:	08/12/2006 - Adam Jasinski - Created
**					:	22/12/2008 - John O'Sullivan - Added code to check if the TAC exists and return a value of -2 
					:	if it does
**********************************************************************************************************************/

CREATE  PROCEDURE [dbo].[h3giCatalogueCreateTACCode]
		@peopleSoftId varchar(50),
		@TAC varchar(25)
AS
BEGIN

DECLARE 
@NewTranCreated int,
@RC int,
@catalogueVersionId int,
@ExistingTacCount int

SET @NewTranCreated = 0
SET @RC=0

SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion();

IF @@TRANCOUNT = 0 	--if not in a transaction context yet
BEGIN
	SET @NewTranCreated = 1
	BEGIN TRANSACTION 	--then create a new transaction
END

DELETE FROM h3giTACLookup
WHERE peopleSoftId=@peopleSoftId
	and TAC = @TAC
IF @@ERROR<>0  GOTO ERR_HANDLER

--Insert TAC code FOR EACH existing contract, prepay and upgrade handset of given peopleSoftID
INSERT INTO h3giTACLookup 
(
	[productId], 
	[peoplesoftID], 
	[TAC], 
	[Prepay]
)
SELECT     
	b4n.productFamilyId, 
	@peopleSoftId,
	@TAC, 
	pc.prepay
FROM
	dbo.h3giProductCatalogue pc 
INNER JOIN
	dbo.b4nAttributeProductFamily b4n ON pc.catalogueProductID = b4n.attributeValue AND b4n.attributeId = 303
WHERE     
	pc.catalogueVersionID = @catalogueVersionId AND 
	pc.peopleSoftId = @peopleSoftId
			  
IF @@ERROR<>0  GOTO ERR_HANDLER

IF @NewTranCreated = 1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
RETURN 0

ERR_HANDLER:
	PRINT 'h3giCatalogueCreateTACCode: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END

grant exec on h3giCatalogueCreateTACCode to b4nuser




GRANT EXECUTE ON h3giCatalogueCreateTACCode TO b4nuser
GO
