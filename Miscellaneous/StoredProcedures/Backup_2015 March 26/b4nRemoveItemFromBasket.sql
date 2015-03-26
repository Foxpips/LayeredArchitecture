



/*********************************************************************************************************************
**																					
** Procedure Name	:	b4nRemoveItemFromBasket
** Author		:	Peter Murphy
** Date Created		:	
** Version		:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Remove a specified item from a basket
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Created
**
**********************************************************************************************************************/


CREATE procedure dbo.b4nRemoveItemFromBasket

@ProductFamilyID int,
@CustomerID int

AS BEGIN

	delete b4nBasket 
	where ProductID = @ProductFamilyID
	and CustomerID = @CustomerID

END


GRANT EXECUTE ON b4nRemoveItemFromBasket TO b4nuser
GO
GRANT EXECUTE ON b4nRemoveItemFromBasket TO ofsuser
GO
GRANT EXECUTE ON b4nRemoveItemFromBasket TO reportuser
GO
