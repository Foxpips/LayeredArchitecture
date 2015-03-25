



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetStoreName
** Author			:	Gearóid Healy
** Date Created		:	05/07/2005
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure the name of a store
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/

create Procedure [dbo].[h3giGetStoreName]

	@StoreCode varchar(20)

as

	select storename
	from h3giretailerstore with(nolock)
	where storecode = @StoreCode





GRANT EXECUTE ON h3giGetStoreName TO b4nuser
GO
GRANT EXECUTE ON h3giGetStoreName TO helpdesk
GO
GRANT EXECUTE ON h3giGetStoreName TO ofsuser
GO
GRANT EXECUTE ON h3giGetStoreName TO reportuser
GO
GRANT EXECUTE ON h3giGetStoreName TO b4nexcel
GO
GRANT EXECUTE ON h3giGetStoreName TO b4nloader
GO
