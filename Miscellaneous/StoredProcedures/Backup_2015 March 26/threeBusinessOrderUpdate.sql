

/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threeBusinessOrderUpdate
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:					
**					
**********************************************************************************************************************
**									
** Change Control	:	????		-	Adam Jasinski	-	Created
**						10/02/2011	-	Stephen Quin	-	Removed the update of salesAssociateId and salesAssociateName
**															This update wasn't working and resulted in NULL salesAssociateIds
**															and blank salesAssociateNames
**						18/12/2012	-	Stephen Quin	-	Added new parameter: @businessAccManager
**						15/01/2013	-	Stephen King	-	changed @businessAccManager to int
**						05/09/2013	-	Simon Markey	-	Added bic and iban for sepa
**						01/10/2013	-	Stephen King	-	added has sepa field
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[threeBusinessOrderUpdate]
	@orderRef INT,
	@channelCode VARCHAR(20),
	@retailerCode VARCHAR(20),
	@storeCode VARCHAR(20) = '',
	@accountHolderName NVARCHAR(80) = N'',
	@sortCode CHAR(6) = '',
	@accountNumber CHAR(8) = '',
	@timeWithBankYears INT = 0,
	@timeWithBankMonths INT = 0,
	@paymentMethod VARCHAR(30),
	@bankAcceptsDirectDebit BIT = 0,
	@canAuthorizeDebits BIT = 0,
	@businessAccManager INT,
	@bic NVARCHAR(11) = '',
	@iban NVARCHAR(34) = '',
	@hasSepa BIT = 1
	
AS
BEGIN

	DECLARE 
		@NewTranCreated INT,
		@RC INT
	SET @NewTranCreated = 0
	SET @RC=0

	IF @@TRANCOUNT = 0 	--if not in a transaction context yet
	BEGIN
		SET @NewTranCreated = 1
		BEGIN TRANSACTION 	--then create a new transaction
	END


	DECLARE @orderDate DATETIME;
	SET @orderDate = GETDATE();


	UPDATE [dbo].[threeOrderHeader]
	SET		channelCode = @channelCode
			,retailerCode = @retailerCode
			,storeCode = @storeCode
			,accountHolderName = @accountHolderName
			,bankSortCode = @sortCode
			,accountNumber = @accountNumber
			,timeWithBankYears = @timeWithBankYears
			,timeWithBankMonths = @timeWithBankMonths
			,paymentMethod = @paymentMethod
			,bankAcceptsDirectDebit = @bankAcceptsDirectDebit
			,canAuthorizeDebits = @canAuthorizeDebits
			,businessAccManagerId = @businessAccManager
			,bic = @bic
			,iban = @iban
			,hasSepa = @hasSepa
	WHERE orderRef = @orderRef;


	IF @@ERROR <> 0 GOTO ERR_HANDLER;

	

IF @NewTranCreated=1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
RETURN 0

ERR_HANDLER:
	PRINT 'threeBusinessOrderUpdate: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END








GRANT EXECUTE ON threeBusinessOrderUpdate TO b4nuser
GO
GRANT EXECUTE ON threeBusinessOrderUpdate TO ofsuser
GO
GRANT EXECUTE ON threeBusinessOrderUpdate TO reportuser
GO
