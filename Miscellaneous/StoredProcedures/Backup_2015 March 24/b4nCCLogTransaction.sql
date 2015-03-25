


/***********************************************************************************************************************
* Change Control
* GH - 11/08/2011 - added @NumItems parameter to handle multisettle (where there could more than 1 orderref per @transactionid)
* SQ - 06/01/2012 - removed the section that worked out the orderRef for VOID and REBATES. The orderRef is now passed as
					a parameter
* SQ - 22/03/2012 - added in section to handle FULL transactions
************************************************************************************************************************/


/****** Object:  Stored Procedure dbo.b4nCCLogTransaction    Script Date: 23/06/2005 13:31:00 ******/
CREATE PROC [dbo].[b4nCCLogTransaction]


@customerId INT  = 0,
@merchantId VARCHAR (50) = '',
@authCode VARCHAR (50) = '',
@passRef VARCHAR (50) = '',
@paymentType INT = 0,
@transactionDate DATETIME = '9999-09-09',
@resultCode INT = 0,
@resultMessage VARCHAR (300) = '',
@handlerType INT = 0,
@OrderRef VARCHAR(54) = '',
@chargeAmount INT,
@b4nOrderRef VARCHAR(25) = '',
@TransactionType VARCHAR(50) = '',
@transactionItemType INT = 0,
@account VARCHAR(50) = '',
@NumItems INT = 1

AS

BEGIN

DECLARE @NumItemsVar INT
SET @NumItemsVar = 1
	
	WHILE(@NumItemsVar <= @NumItems)
	BEGIN
		IF(@TransactionType = 'SHADOW' OR @TransactionType = 'FULL')
			SET @b4nOrderRef = @NumItemsVar
	
		INSERT INTO b4nCCTransactionLog
			(customerID, merchantID, authCode, passRef, paymentType, transactionDate, resultCode,
			resultMessage, handlerType, OrderRef, chargeAmount, TransactionType, b4nOrderRef, transactionItemType, account)

		SELECT 	@customerId,@merchantId,@authCode,@passRef,@paymentType,
			@transactionDate,@resultCode,@resultMessage,@handlerType, @OrderRef, @chargeAmount, 
			@TransactionType, @b4nOrderRef, @transactionItemType, @account
			
		SET @NumItemsVar = @NumItemsVar + 1
	END

END






GRANT EXECUTE ON b4nCCLogTransaction TO b4nuser
GO
GRANT EXECUTE ON b4nCCLogTransaction TO ofsuser
GO
GRANT EXECUTE ON b4nCCLogTransaction TO reportuser
GO
