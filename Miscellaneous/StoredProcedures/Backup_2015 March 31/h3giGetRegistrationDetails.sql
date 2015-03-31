
create proc dbo.h3giGetRegistrationDetails
/*********************************************************************************************************************
**                                                                                                              
** Procedure Name    :    h3giGetRegistrationDetails
** Author            :    John Hannon
** Date Created      :    03/03/06
**                         
**********************************************************************************************************************
**                   
** Description       :    Returns the registration details attached to the order - for PrePay
**                         
**********************************************************************************************************************
**                                              
** Change Control    :    
**                              
**********************************************************************************************************************/
@orderref int
as
begin

	select * from h3giRegistration
	where orderref = @orderref

end


GRANT EXECUTE ON h3giGetRegistrationDetails TO b4nuser
GO
GRANT EXECUTE ON h3giGetRegistrationDetails TO ofsuser
GO
GRANT EXECUTE ON h3giGetRegistrationDetails TO reportuser
GO
