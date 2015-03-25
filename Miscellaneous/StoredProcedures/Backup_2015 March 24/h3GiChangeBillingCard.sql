

/****** Object:  Stored Procedure dbo.h3GiChangeBillingCard    Script Date: 23/06/2005 13:35:01 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3GiChangeBillingCard
** Author		:	Padraig Gorry
** Date Created		:	
** Version		:	
**					
**********************************************************************************************************************
**				
** Description		:	Changes the billing card on the order
**					
**********************************************************************************************************************
**									
** Change Control	:	10-May-2005- Padraig Gorry - Created
**********************************************************************************************************************/
CREATE PROCEDURE h3GiChangeBillingCard (
@OrderRef as int,
@CardType as int,
@CardNumber as varchar(255),
@Expiry as DateTime,
@CCV as varchar(10),
@UserID as int
)
AS


BEGIN TRAN


UPDATE 
	b4nOrderHeader 
SET 
	ccTypeID = @CardType,
	ccNumber = @CardNumber,
	ccExpiryDate = @Expiry,
	securitycode = @CCV
WHERE
	OrderRef = @OrderRef

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END

UPDATE 
	h3giOrderHeader 
SET 
	ChargeAttempts = ChargeAttempts + 1
WHERE
	OrderRef = @OrderRef

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END

COMMIT TRAN


GRANT EXECUTE ON h3GiChangeBillingCard TO b4nuser
GO
GRANT EXECUTE ON h3GiChangeBillingCard TO helpdesk
GO
GRANT EXECUTE ON h3GiChangeBillingCard TO ofsuser
GO
GRANT EXECUTE ON h3GiChangeBillingCard TO reportuser
GO
GRANT EXECUTE ON h3GiChangeBillingCard TO b4nexcel
GO
GRANT EXECUTE ON h3GiChangeBillingCard TO b4nloader
GO
