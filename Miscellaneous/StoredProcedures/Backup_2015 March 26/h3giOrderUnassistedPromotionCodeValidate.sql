
/**********************************************************************************************************************
**
**	Validates an unassisted prmotion code. checks wheter the code has already been used in orders that are not cancelled
**
**	Change Control	:	24/07/2007 - Attila Pall: Created
**
*********************************************************************************************************************/
CREATE   PROCEDURE [dbo].[h3giOrderUnassistedPromotionCodeValidate] 
	@promotionCode 	varchar(20),
	@result int output
AS
BEGIN
	--	result (based on H3GIClasses.H3GIOrder.Validation.UniqueCodeStatuses):
	--		0: if the code is free
	--		1: if the code is used
	
	SELECT orderref
	INTO #containingOrders
	FROM h3giOrderHeader hoh
	WHERE hoh.unassistedPromotionCode = @promotionCode
	
	IF EXISTS	(
					SELECT * FROM #containingOrders
					WHERE orderRef NOT IN
						(SELECT DISTINCT co.orderRef
						FROM b4nOrderHistory ohi
						INNER JOIN #containingOrders co
							on ohi.orderRef = co.orderRef
						WHERE ohi.orderStatus IN (301,305)
						)
				)
	BEGIN
		SET @result = 1;
	END
	ELSE
	BEGIN 
		SET @result = 0;
	END
END

GRANT EXECUTE ON h3giOrderUnassistedPromotionCodeValidate TO b4nuser
GO
GRANT EXECUTE ON h3giOrderUnassistedPromotionCodeValidate TO reportuser
GO
