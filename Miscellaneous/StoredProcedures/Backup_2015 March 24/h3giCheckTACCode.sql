

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCheckTACCode
** Author			:	Niall Carroll
** Date Created		:	
** Version			:	1.2.0
**					
**********************************************************************************************************************
**				
** Description		:	Validates an IMEI
**					
**********************************************************************************************************************
**									
** Change Control	:	06 April - NC - Added Prepay parameter
**********************************************************************************************************************/
CREATE   PROCEDURE [dbo].[h3giCheckTACCode]
@productid				int,
@IMEI					varchar(50),
@Prepay					int = 0

AS
	DECLARE @foundProductID		int
	DECLARE @mismatchProductID	int
	DECLARE @ResultCode			int
	DECLARE @OrderRefWithIMEI	int
	DECLARE @OldOrderDate 		datetime

	SET @ResultCode = 0

	SELECT @foundProductID = productID
	FROM h3giTACLookup
	WHERE SubString(@IMEI, 1, len(TAC)) = TAC AND productID = @ProductID AND Prepay = @Prepay

	IF (@foundProductID IS NOT NULL)
	BEGIN
		-- We are happy , we have found the phone
		-- Let's check if the IMEI has already been used before
		SET @OrderRefWithIMEI = 0
		
		SELECT @OrderRefWithIMEI = Max(OrderRef) 
		FROM h3giOrderHeader
		WHERE IMEI = @IMEI

		IF (@OrderRefWithIMEI = 0)
		BEGIN
			-- Search in business upgrades table.
			SELECT @OrderRefWithIMEI = Max(OrderRef) 
			FROM threeOrderUpgradeHeader
			WHERE IMEI = @IMEI
		END

		IF (@OrderRefWithIMEI > 0)
		BEGIN
			SET @ResultCode = 3
			
			SELECT @OldOrderDate = orderDate 
			FROM b4norderheader b
			WHERE b.OrderRef = @OrderRefWithIMEI
			
			PRINT 'IMEI already in Database'
		END
		ELSE
		BEGIN
			SET @ResultCode = 0 -- TAC / IMEI MATCH
			PRINT 'TAC / IMEI MATCH'	
		END
	END
	ELSE
	BEGIN
		-- We are sad, we haven't found a product
		-- Let's check if the IMEI belongs to a different phone
		SET @mismatchProductID = (
			SELECT TOP 1 productID 
			FROM h3giTACLookup
			WHERE SubString(@IMEI, 1, len(TAC)) = TAC AND productID <> @ProductID
		) 
		
		--AND Prepay = @Prepay		
		SELECT @mismatchProductID = IsNull (@mismatchProductID, 0)

		IF (@mismatchProductID > 0)
		BEGIN 
			SET @ResultCode = 2 -- TAC / IMEI Match refers to different phone
			PRINT 'TAC / IMEI Match refers to different phone'
		END
		ELSE
		BEGIN
			SET @ResultCode = 1 -- TAC / IMEI Match not found
			PRINT 'TAC / IMEI Match not found'
		END
	END

	SELECT @ResultCode as ResultCode, @OrderRefWithIMEI as OldOrderRef, @OldOrderDate as OldOrderDate


GRANT EXECUTE ON h3giCheckTACCode TO b4nuser
GO
GRANT EXECUTE ON h3giCheckTACCode TO ofsuser
GO
GRANT EXECUTE ON h3giCheckTACCode TO reportuser
GO
