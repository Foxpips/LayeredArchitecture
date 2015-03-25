


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giUpdateClickCollectRetailerOrder
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
** Change Control	:	1 AUG 2013 Simon Markey new sproc for updating retailer info for click collect orders
**********************************************************************************************************************/
CREATE proc [dbo].[h3giUpdateClickCollectRetailerOrder]
@OrderRef 		INT,
@IMEI			VARCHAR(30),
@ICCID_MSISDN 	VARCHAR(30),
@slingBoxSerialNumber VARCHAR(20) = '',
@currentMobileSalesAssociatedName VARCHAR(50) ='',
@mobileSalesAssociatesNameId int = NULL
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
	slingBoxSerialNumber = @slingBoxSerialNumber,
	currentMobileSalesAssociatedName = @currentMobileSalesAssociatedName,
	mobileSalesAssociatesNameId = @mobileSalesAssociatesNameId
	WHERE OrderRef = @OrderRef

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END


COMMIT TRAN







GRANT EXECUTE ON h3giUpdateClickCollectRetailerOrder TO b4nuser
GO
GRANT EXECUTE ON h3giUpdateClickCollectRetailerOrder TO reportuser
GO
