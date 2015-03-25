
/*********************************************************************************************************************
**                                                                                                                                                                                                                                                          
** Procedure Name	:	h3giGetPriceplanPackageName
** Author		:	Attila Pall
** Date Created		:	05/07/2006
**                                                          
**********************************************************************************************************************
**                                              
** Description		:  	Gets the name of a priceplan package
**                                                          
**********************************************************************************************************************
**                                                                                                          
** Change Control	:	1.0.0 - Initial version created
**
**********************************************************************************************************************/

CREATE PROCEDURE dbo.h3giGetPriceplanPackageName

	@priceplanId int,	
	@priceplanPackageId int

AS

BEGIN

	SELECT DISTINCT priceplanpackagename
	FROM h3gipriceplanpackage
	WHERE
		priceplanpackageid = @priceplanPackageId
		and priceplanid = @priceplanId

END

GRANT EXECUTE ON h3giGetPriceplanPackageName TO b4nuser
GO
GRANT EXECUTE ON h3giGetPriceplanPackageName TO ofsuser
GO
GRANT EXECUTE ON h3giGetPriceplanPackageName TO reportuser
GO
