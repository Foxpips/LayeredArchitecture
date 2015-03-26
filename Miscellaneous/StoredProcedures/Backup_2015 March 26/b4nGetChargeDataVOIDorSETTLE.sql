


CREATE PROC [dbo].[b4nGetChargeDataVOIDorSETTLE]

@AccountName VARCHAR(20) = '',
@OrderRef VARCHAR(25),
@transactionItemType  INT = 0,
@transactionPassRef VARCHAR(50) = ''
AS

BEGIN

DECLARE @paymentType INT
DECLARE @merchantID VARCHAR (50)
DECLARE @handlerType INT
DECLARE @tempOrderRef INT
DECLARE @accountNo VARCHAR (50)
DECLARE @CCPath VARCHAR(255)
DECLARE @Secret VARCHAR (50)

BEGIN TRAN
	SET @paymentType 	= CAST((SELECT idValue FROM config WHERE idName = 'automaticCharge') AS INT)
	SET @merchantID 	= dbo.fnGetChargeMerchandID(@transactionItemType);
	SET @handlerType 	= (SELECT idValue FROM config WHERE idName = 'handlerType')
	SET @tempOrderRef 	= CAST((SELECT idValue FROM config WHERE idName = 'tempOrderRef') AS INT)
	SET @CCPath 		= (SELECT idValue FROM config WHERE idName = 'CCPath')
	SET @Secret		= (SELECT idValue FROM config WHERE idName = 'secret')

	SELECT @accountNo = dbo.fnGetChargeAccount(@AccountName, @transactionItemType);

	SELECT @paymentType, @merchantID, @handlerType, OrderRef, @accountNo, @CCPath, @Secret, authCode, passRef, OrderRef
	FROM b4nCCTransactionLog 
	WHERE b4nOrderRef = @OrderRef 
	AND TransactionType = 'SHADOW'
	AND transactionItemType = @transactionItemType
	AND (@transactionPassRef = '' OR passRef = @transactionPassRef)
	
COMMIT TRAN

END

GRANT EXECUTE ON b4nGetChargeDataVOIDorSETTLE TO b4nuser
GO
GRANT EXECUTE ON b4nGetChargeDataVOIDorSETTLE TO ofsuser
GO
GRANT EXECUTE ON b4nGetChargeDataVOIDorSETTLE TO reportuser
GO
