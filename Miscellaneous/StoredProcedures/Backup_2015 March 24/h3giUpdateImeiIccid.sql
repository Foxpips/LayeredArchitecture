
CREATE PROC [dbo].[h3giUpdateImeiIccid]
@orderRef AS INT,
@Imei AS NVARCHAR(50),
@Iccid AS NVARCHAR(50)

AS

BEGIN
UPDATE h3giOrderheader
SET IMEI=@imei
WHERE orderref = @orderRef

UPDATE h3giOrderheader
SET ICCID=@iccid
WHERE orderref = @orderRef

END

GRANT EXECUTE ON h3giUpdateImeiIccid TO b4nuser
GO
