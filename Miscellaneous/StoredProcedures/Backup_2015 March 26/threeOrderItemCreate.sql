
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threeOrderItemCreate
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:					
**					
**********************************************************************************************************************
**									
** Change Control	:	 - Adam Jasinski - Created
**
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[threeOrderItemCreate]
			@orderRef int,
			@isParent bit,
			@endUserName nvarchar(80),
			@discountAmount money,
			@discountChargeCode varchar(25),
			@intentionToPort bit,
			@cafCompleted bit,
			@mobileProvider varchar(30) = '',
			@currentMobileNumberArea varchar(3) = '',
			@currentMobileNumberMain varchar(7) = '',
			@currentPackageType varchar(10) = '',
			@currentAccountNumber varchar(20) = '',
			@alternativeDateForPorting datetime = NULL,
			@IMEI varchar(15) = '',
			@ICCID varchar(20) = '',
			@internationalRoaming bit = 0,
			@premiumRateCalling bit = 0,
			@internationalCalling bit = 0,
			@orderItemId int out
AS
BEGIN

	SET @orderItemId = 0;

	DECLARE @parentItemId int;
	SET @parentItemId = NULL;
	
	IF @isParent = 0
	BEGIN
		SELECT @parentItemId  = itemId 
		FROM [dbo].[threeOrderHeader] orderHeader
		INNER JOIN [dbo].[threeOrderItem] orderItem
		ON orderHeader.orderRef = orderItem.orderRef
		WHERE orderHeader.orderRef = @orderRef
		AND orderItem.parentItemId IS NULL;

		IF @parentItemId IS NULL RAISERROR('Cannot find the parent item', 10, 1);
	END;


	INSERT INTO [dbo].[threeOrderItem]
           (
			[orderRef]
           ,[parentItemId]
           ,[endUserName]
           ,[discountAmount]
           ,[discountChargeCode]
           ,[intentionToPort]
           ,[cafCompleted]
           ,[mobileProvider]
           ,[currentMobileNumberArea]
			,[currentMobileNumberMain]
           ,[currentPackageType]
			,currentAccountNumber
           ,[alternativeDateForPorting]
           ,[IMEI]
           ,[ICCID]
			,[internationalRoaming]
			,[premiumRateCalling]
			,[internationalCalling]
	 )
     VALUES
           (
            @orderRef
           ,@parentItemId
           ,@endUserName
           ,@discountAmount
           ,@discountChargeCode
           ,@intentionToPort
           ,@cafCompleted
           ,@mobileProvider
           ,@currentMobileNumberArea
			,@currentMobileNumberMain
           ,@currentPackageType
			,@currentAccountNumber
           ,@alternativeDateForPorting
           ,@IMEI
           ,@ICCID
			,@internationalRoaming
			,@premiumRateCalling
			,@internationalCalling
);

	IF @@ERROR = 0 SET @orderItemId = SCOPE_IDENTITY();
END


GRANT EXECUTE ON threeOrderItemCreate TO b4nuser
GO
GRANT EXECUTE ON threeOrderItemCreate TO reportuser
GO
