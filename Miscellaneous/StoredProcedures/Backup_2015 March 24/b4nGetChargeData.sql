
----------------------------------------------------
/*********************************************************************************************************************
**																					
** Procedure Name	:	b4nGetChargeData
** Author			:	?
** Date Created		:	?
** Version			:	1.1.0
**					
**********************************************************************************************************************
**				
** Description		:	Gets details from the config tables for use with the CCtransaction Object
**					
**********************************************************************************************************************
**									
** Change Control	:	09 Mar 2006: ncarroll - Added 3dSecure Path
**					:	30 Oct 2008: ajasinski - Added @transactionItemType parameter
**					:	
**********************************************************************************************************************/
CREATE procedure [dbo].[b4nGetChargeData]

@AccountName VARCHAR(20) = '',
@transactionItemType int = 0,
@incrementTempOrderRef bit = 1
AS

BEGIN

DECLARE @paymentType 		INT
DECLARE @merchantID 		VARCHAR (50)
DECLARE @handlerType 		INT
DECLARE @tempOrderRef 		VARCHAR (50)
DECLARE @accountNo 			VARCHAR (50)
DECLARE @CCPath 			VARCHAR(255)
DECLARE @ThreeDSecurePath	VARCHAR(255)
declare @3dsecureSecret		varchar(255)
declare @3dsecureMerchantId varchar(255)
DECLARE @Secret 			VARCHAR (50)
DECLARE @orderRefPrefix VARCHAR(20)

BEGIN TRANSACTION
	if(@incrementTempOrderRef = 1)
		UPDATE config WITH (rowlock) SET idValue = CAST((CAST(idValue AS INT) + 1) AS VARCHAR) where idName = 'tempOrderRef' 

	SET @paymentType 		= cast((SELECT idValue FROM config WHERE idName = 'automaticCharge') AS INT)
	SET @merchantID 		= dbo.fnGetChargeMerchandID(@transactionItemType);
	SET @handlerType 		= (SELECT idValue FROM config WHERE idName = 'handlerType')

	SET @orderRefPrefix		= (SELECT idValue FROM config WHERE idName = 'orderRefPrefix')

	SET @tempOrderRef 		= ISNULL(@orderRefPrefix,'H3GI_') + (SELECT idValue FROM config WHERE idName = 'tempOrderRef')

	SET @CCPath 			= (SELECT idValue FROM config WHERE idName = 'CCPath')
	SET @ThreeDSecurePath	= (SELECT idValue FROM config WHERE idName = '3DSecurePath')
	SET @Secret				= (SELECT idValue FROM config WHERE idName = 'secret')
	
	set @3dsecureSecret		= (select idValue from config where idName = '3dsecureSecret')
	set @3dsecureMerchantId	= (select idValue from config where idName = '3dsecureMerchantId')

	SELECT @accountNo = dbo.fnGetChargeAccount(@AccountName, @transactionItemType);
	SELECT 	@paymentType 		AS PaymentType, 
			@merchantID 		AS merchantID, 
			@handlerType  		AS handlerType, 
			@tempOrderRef 		AS tempOrderRef, 
			@accountNo 			AS accountNo, 
			@CCPath 			AS CCPath, 
			@Secret 			AS Secret, 
			@ThreeDSecurePath  	AS ThreeDSecurePath,
			@3dsecureSecret		as ThreeDSecret,
			@3dsecureMerchantId	as ThreeDsecureMerchantId
COMMIT TRAN

END

GRANT EXECUTE ON b4nGetChargeData TO b4nuser
GO
GRANT EXECUTE ON b4nGetChargeData TO ofsuser
GO
GRANT EXECUTE ON b4nGetChargeData TO reportuser
GO
