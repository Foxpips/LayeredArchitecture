

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3GiUpdateRetailerOrder
** Author			:	?
** Date Created		:	
** Version			:	1.1.0
**					
**********************************************************************************************************************
**				
** Description		:	SETs an ICCID/IMEI/Slingbox serial
**					
**********************************************************************************************************************
**									
** Change Control	:	30 Mar 2006 - NC - Using the MSISDN to work out the ICCID for Kitted phones
**					:	09 Mar 2007 - Adam Jasinski - added @slingBoxSerialNumber parameter
**********************************************************************************************************************/
CREATE proc [dbo].[h3GiUpdateRetailerOrder]
@OrderRef 		INT,
@IMEI			VARCHAR(30),
@ICCID_MSISDN 	VARCHAR(30),
@slingBoxSerialNumber VARCHAR(20) = ''
AS
BEGIN TRAN

DECLARE @Kitted BIT
DECLARE @ICCID varchar(30)

SELECT @Kitted = Kitted FROM viewOrderPhone WHERE OrderRef = @OrderRef

IF @Kitted = 0
BEGIN
	SET	@ICCID = @ICCID_MSISDN
END
ELSE
BEGIN
	IF SubString(@ICCID_MSISDN,1,3) = '083'
		SELECT @ICCID = ICCID FROM h3giICCID WHERE MSISDN = '353' + SubString(@ICCID_MSISDN, 2, Len(@ICCID_MSISDN))
	ELSE
		SELECT @ICCID = ICCID FROM h3giICCID WHERE MSISDN = @ICCID_MSISDN
END

UPDATE h3giorderHeader 
	SET IMEI = @IMEI, 
	ICCID = @ICCID,
	slingBoxSerialNumber = @slingBoxSerialNumber
	WHERE OrderRef = @OrderRef

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END


COMMIT TRAN






GRANT EXECUTE ON h3GiUpdateRetailerOrder TO b4nuser
GO
GRANT EXECUTE ON h3GiUpdateRetailerOrder TO reportuser
GO
