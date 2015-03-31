

/****** Object:  Stored Procedure dbo.h3giGetOrderDispatchDate    Script Date: 23/06/2005 13:35:20 ******/
CREATE PROC dbo.h3giGetOrderDispatchDate
@OrderRef int

AS

DECLARE @SQL 	varchar(1000)
DECLARE @GMDB 	varchar(25)

select @GMDB = idValue from config where idName = 'OFS4GMDatabase'


SET @SQL  = '
SELECT MAX(statusDate) from ' + @GMDB + '..gmOrderHistory where orderRef = ' + Cast(@OrderRef as varchar(25)) + ' AND statusID = 3 '
EXEC (@SQL)




GRANT EXECUTE ON h3giGetOrderDispatchDate TO b4nuser
GO
GRANT EXECUTE ON h3giGetOrderDispatchDate TO helpdesk
GO
GRANT EXECUTE ON h3giGetOrderDispatchDate TO ofsuser
GO
GRANT EXECUTE ON h3giGetOrderDispatchDate TO reportuser
GO
GRANT EXECUTE ON h3giGetOrderDispatchDate TO b4nexcel
GO
GRANT EXECUTE ON h3giGetOrderDispatchDate TO b4nloader
GO
