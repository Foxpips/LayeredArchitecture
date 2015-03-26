

/****** Object:  Stored Procedure dbo.h3giFinaliseBatch    Script Date: 23/06/2005 13:35:11 ******/

CREATE PROCEDURE dbo.h3giFinaliseBatch

@BatchID int

AS

DECLARE @SQL varchar(500)
DECLARE @GMDB varchar(40)

BEGIN TRAN

SELECT @GMDB = idValue FROM config WHERE idName = 'OFS4GMDatabase'
SET @SQL = 
'UPDATE ' + @GMDB + '..gmOrderHeader set StatusID = 3 WHERE OrderRef in 
		(
			select OrderRef from h3giBatchOrder Where BatchID = ' + Cast(@BatchID as varchar(10)) +'
		)'
EXEC (@SQL)
UPDATE h3giBatch set Status = 3 WHERE BatchID = @BatchID

IF @@ERROR = 0
BEGIN
	COMMIT TRAN
END
ELSE
BEGIN
	ROLLBACK TRAN
END


GRANT EXECUTE ON h3giFinaliseBatch TO b4nuser
GO
GRANT EXECUTE ON h3giFinaliseBatch TO helpdesk
GO
GRANT EXECUTE ON h3giFinaliseBatch TO ofsuser
GO
GRANT EXECUTE ON h3giFinaliseBatch TO reportuser
GO
GRANT EXECUTE ON h3giFinaliseBatch TO b4nexcel
GO
GRANT EXECUTE ON h3giFinaliseBatch TO b4nloader
GO
