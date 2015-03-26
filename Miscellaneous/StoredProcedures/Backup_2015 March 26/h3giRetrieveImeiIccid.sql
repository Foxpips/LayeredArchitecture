
CREATE PROC [dbo].[h3giRetrieveImeiIccid]
@orderRef INT
AS
DECLARE @activated NVARCHAR(10)

BEGIN
SET NOCOUNT ON;

BEGIN
IF EXISTS(SELECT orderref 
FROM h3giSalesCapture_Audit
WHERE orderref = @orderRef)

BEGIN
SELECT @activated = 'yes'
END
ELSE
SELECT @activated = 'no'

SELECT ICCID,IMEI,orderType,@activated alreadyActivated
FROM h3giOrderheader 
WHERE orderref = @orderRef

END
END


GRANT EXECUTE ON h3giRetrieveImeiIccid TO b4nuser
GO
