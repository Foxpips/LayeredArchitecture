

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giSaveUnassistedSales
** Author		:	Attila Pall
** Date Created		:	28/01/2007
** Version		:	1
**					
**********************************************************************************************************************
**				
** Description		:	Saves number of unassisted sales downloaded from Three
**					
**********************************************************************************************************************
**									
** Change Control	:	28/01/2007 - Attila Pall: Created
**						
**********************************************************************************************************************/
CREATE  PROCEDURE dbo.h3giSaveUnassistedSales 
	@numberOfSales int,
	@dataFileCreationDate datetime
AS
	INSERT INTO h3giUnassistedSalesHistory (numberOfSales, dataFileCreationDate, dateStamp)
	VALUES (@numberOfSales, @dataFileCreationDate, CURRENT_TIMESTAMP)



GRANT EXECUTE ON h3giSaveUnassistedSales TO b4nuser
GO
GRANT EXECUTE ON h3giSaveUnassistedSales TO ofsuser
GO
GRANT EXECUTE ON h3giSaveUnassistedSales TO reportuser
GO
