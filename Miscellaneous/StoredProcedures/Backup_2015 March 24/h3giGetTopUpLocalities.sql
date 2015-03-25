
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetTopUpLocalities
** Author		:	Peter Murphy
** Date Created		:	29/03/06
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure returns unique localities in a county/postcode
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 

CREATE procedure dbo.h3giGetTopUpLocalities

@CountyID as varchar(2),
@PostCode as varchar(2) = ''

AS BEGIN

	DECLARE @SQL varchar(300)

	SET @SQL = 'select distinct(locality) from h3giTopUpLocation where storeCounty = ' + @CountyID

	IF(NOT @PostCode = '')
	BEGIN
		SET @SQL = @SQL + ' and postCode = ''' + @PostCode + ''''
	END

	SET @SQL = @SQL + ' order by locality'

	EXEC(@SQL)
END


GRANT EXECUTE ON h3giGetTopUpLocalities TO b4nuser
GO
GRANT EXECUTE ON h3giGetTopUpLocalities TO ofsuser
GO
GRANT EXECUTE ON h3giGetTopUpLocalities TO reportuser
GO
