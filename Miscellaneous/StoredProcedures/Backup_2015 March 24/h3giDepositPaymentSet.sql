


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giDepositPaymentSet
** Author		:	Attila Pall
** Date Created		:	28/03/2007
** Version		:	
**					
**********************************************************************************************************************
**				
** Description		:	Sets the payment of a deposit
**					
**********************************************************************************************************************
**									
** Change Control	:	28/03/2007 Attila Pall - Created
**********************************************************************************************************************/
CREATE  PROCEDURE dbo.h3giDepositPaymentSet 
	@depositId int, 
	@paymentMethod varchar(20)
AS
BEGIN

	DECLARE @depositReferenceNumber INT
	DECLARE @thisMorning DATETIME
	DECLARE @errorSave INT

	SET @thisMorning = CONVERT(DATETIME,CAST(DAY(GETDATE()) as varchar)+
		'/'  + CAST(MONTH(GETDATE()) as varchar) + 
		'/' + CAST(YEAR(GETDATE()) as varchar), 103)

	SET LOCK_TIMEOUT 2000
	BEGIN TRANSACTION depositPayment

	SET @depositReferenceNumber = ISNULL( (SELECT MAX(referenceNumber) FROM h3giOrderDepositReference WHERE depositDate > @thisMorning)  + 1, 10000) 
	
	UPDATE h3giOrderDeposit
	SET
		depositPaid = 1,
		paymentMethod = @paymentMethod
	WHERE depositId = @depositId
	IF (@@ERROR <> 0) SET @errorSave = 1
	
	INSERT INTO h3giOrderDepositReference
	VALUES(@depositId, GETDATE(), @depositReferenceNumber)
	IF (@@ERROR <> 0) SET @errorSave = 1

	IF (@errorSave <> 0)
	BEGIN
		PRINT 'Error occured, rolling back'
		ROLLBACK TRANSACTION depositPayment
	END
	ELSE
	BEGIN
		PRINT 'No error, commiting'
		COMMIT TRANSACTION depositPayment
	END	
END



GRANT EXECUTE ON h3giDepositPaymentSet TO b4nuser
GO
GRANT EXECUTE ON h3giDepositPaymentSet TO reportuser
GO
