-- =============================================
-- Author:		Stephen Quin
-- Create date: 30/10/07
-- Description:	Returns the MSISDN
-- =============================================
CREATE PROCEDURE [dbo].[threeItemDetailsGetMsisdn]
	@iccid varchar(25),
	@msisdn varchar(50) OUTPUT
AS
BEGIN
	SELECT @msisdn = msisdn 
	FROM h3giIccid
	WHERE iccid = @iccid
END

GRANT EXECUTE ON threeItemDetailsGetMsisdn TO b4nuser
GO
GRANT EXECUTE ON threeItemDetailsGetMsisdn TO reportuser
GO
