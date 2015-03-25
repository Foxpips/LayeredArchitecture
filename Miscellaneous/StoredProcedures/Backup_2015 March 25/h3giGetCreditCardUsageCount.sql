/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetCreditCardUsageCount
** Author		:	Peter Murphy
** Date Created		:	29/05/06
**					
**********************************************************************************************************************
**				
** Description		:	Count the number of times a specified card has been used
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Initial version created
**				1.0.1 - Added join to a table of allowed cards (used for testing)
**					Peter Murphy / 08/06/06
**						
**********************************************************************************************************************/
 

CREATE procedure h3giGetCreditCardUsageCount

@CCNo varchar(50)

as begin

	declare @UsageCount int

	select @UsageCount = count(*) from b4nOrderHeader OH
	inner join viewOrderPhone VOP on VOP.OrderRef = OH.OrderRef
	where OH.ccNumber = @CCNo
		and OH.orderDate > cast(dateadd(dd,-30,getdate()) as varchar(25))
		and VOP.PrePay = 1
		and OH.ccNumber not in (select CCNo from h3giAllowedCC)
	
	print( @UsageCount )
	return @UsageCount

end


GRANT EXECUTE ON h3giGetCreditCardUsageCount TO b4nuser
GO
GRANT EXECUTE ON h3giGetCreditCardUsageCount TO ofsuser
GO
GRANT EXECUTE ON h3giGetCreditCardUsageCount TO reportuser
GO
