


------------------------------

/****** Object:  Stored Procedure dbo.h3giInsertAudit    Script Date: 23/06/2005 13:35:22 ******/
CREATE PROC [dbo].[h3giInsertAudit]
/*
John Hannon created this sp 04.05.2005 to maintain an audit table of all the orderrefs
for each order sent to Three in the sales data capture (by sequence number)

**Change Control	:	John Hanon - 29/03/2006 added new parameter @prepay
					:	NC - 17/07/2006 - Stopped inserting mixed order types
					:	SQ - 03/07/2012 - added functionality to handle contract upgrade and prepay upgrade orders
					:	SQ - 31/05/2013 - add functionality to handle business upgrade orders
*/
@prepay INT = 0,
@isBusiness BIT = 0
AS
BEGIN

DECLARE @sequence_no INT
DECLARE @err INT

SET @err = 0

BEGIN TRANSACTION tTransaction

IF (@prepay = 0)
BEGIN
	SELECT @sequence_no = CAST(idvalue AS INT)
	FROM b4nsysdefaults
	WHERE idname = 'sequence_no_contract'
END
ELSE IF(@prepay = 1)
BEGIN
	SELECT @sequence_no = CAST(idvalue AS INT)
	FROM b4nsysdefaults
	WHERE idname = 'sequence_no_prepay'
END
ELSE IF(@prepay = 2 AND @isBusiness = 0)
BEGIN
	SELECT @sequence_no = CAST(idvalue AS INT)	
	FROM b4nsysdefaults
	WHERE idname = 'sequence_no_contractupg'
END
ELSE IF(@prepay = 2 AND @isBusiness = 1)
BEGIN
	SELECT @sequence_no = CAST(idvalue AS INT)	
	FROM b4nsysdefaults
	WHERE idname = 'sequence_no_businessupg'
END
ELSE
BEGIN
	SELECT @sequence_no = CAST(idvalue AS INT)	
	FROM b4nsysdefaults
	WHERE idname = 'sequence_no_prepayupg'	
END

SET @err = @err + @@ERROR

INSERT INTO h3giSalesCapture_Audit
SELECT @sequence_no, orderref, GETDATE(), @prepay
FROM gmOrdersDispatched_Temp
WHERE prepay = @prepay

SET @err = @err + @@ERROR

IF (@err > 0)
BEGIN
	ROLLBACK TRANSACTION tTransaction
END
ELSE
BEGIN
	COMMIT TRANSACTION tTransaction
END


END







GRANT EXECUTE ON h3giInsertAudit TO b4nuser
GO
GRANT EXECUTE ON h3giInsertAudit TO ofsuser
GO
GRANT EXECUTE ON h3giInsertAudit TO reportuser
GO
