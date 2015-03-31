



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetStoreCode
** Author			:	Gearóid Healy
** Date Created		:	06/07/2005
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure the code of a store
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/

create Procedure [dbo].[h3giGetStoreCode]

	@StoreName varchar(50)

as

	select storecode
	from h3giretailerstore with(nolock)
	where storename = @StoreName





GRANT EXECUTE ON h3giGetStoreCode TO b4nuser
GO
GRANT EXECUTE ON h3giGetStoreCode TO helpdesk
GO
GRANT EXECUTE ON h3giGetStoreCode TO ofsuser
GO
GRANT EXECUTE ON h3giGetStoreCode TO reportuser
GO
GRANT EXECUTE ON h3giGetStoreCode TO b4nexcel
GO
GRANT EXECUTE ON h3giGetStoreCode TO b4nloader
GO
