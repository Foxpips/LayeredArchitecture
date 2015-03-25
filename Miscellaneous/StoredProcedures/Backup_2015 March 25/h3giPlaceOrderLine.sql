




-- =============================================
-- Author:		Adam Jasinski
-- Create date: 2008/06/24
-- Description:
-- Changes:		Added functionality to check
--				if this order qualifies for
--				a free iPod Shuffle
-- =============================================
CREATE PROCEDURE [dbo].[h3giPlaceOrderLine] 
	@orderRef int,
	@productFamilyId int,
	@productName varchar(4000),
	@price money,
	@orderType int = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @catalogueVersion INT
	SELECT @catalogueVersion = dbo.fn_GetActiveCatalogueVersion();

	DECLARE @tariffProductCode VARCHAR(20);
	DECLARE @devicePeopleSoftId VARCHAR(20);
	
	DECLARE @productType VARCHAR(20);
	DECLARE @channel VARCHAR(20);
	
	SELECT @productType = productType 
	FROM h3giProductCatalogue 
	WHERE catalogueVersionID = @catalogueVersion
	AND productFamilyId = @productFamilyId

	SELECT @orderType = orderType,
			@channel = channelCode
	FROM h3giOrderHeader
	WHERE orderRef = @orderRef;

	INSERT INTO [dbo].[b4nOrderLine]
           ([storeid]
           ,[OrderRef]
           ,[ProductID]
           ,[Quantity]
           ,[Instructions]
           ,[Price]
           ,[createDate]
           ,[modifyDate]
           ,[itemName]
           ,[giftWrappingTypeId]
           ,[giftWrappingDescription]
           ,[giftWrappingCost]
           ,[gen1]
           ,[gen2]
           ,[gen3]
           ,[gen4]
           ,[gen5]
           ,[gen6]
           ,[refunded])
     VALUES
           (1
           ,@orderRef
           ,@productFamilyId
           ,1
           ,''
           ,@price
           ,getdate()
           ,getdate()
           ,@productName
           ,0
           ,''
           ,0.0
           ,''
           ,''
           ,''
           ,''
           ,''
           ,@orderType
           ,0)
           
	--Free Nokia check
	IF (@productType = 'HANDSET' AND @orderType NOT IN (1,2,3))
	BEGIN

		SELECT @tariffProductCode = tariffProductCode
		FROM h3giOrderheader
		WHERE orderref = @orderRef

		SELECT @devicePeopleSoftId = peopleSoftId
		FROM h3giProductCatalogue
		WHERE catalogueVersionID = @catalogueVersion
		AND productFamilyId = @productFamilyId
			
		IF(@devicePeopleSoftId IN ('50721','50722') AND @tariffProductCode IN ('T010111XX24'))
		BEGIN
			INSERT INTO [dbo].[b4nOrderLine] ([storeid],[OrderRef],[ProductID],[Quantity],[Instructions],[Price],[createDate],[modifyDate],[itemName],[giftWrappingTypeId],[giftWrappingDescription],[giftWrappingCost],[gen1],[gen2],[gen3],[gen4],[gen5],[gen6],[refunded])
			VALUES (1,@orderRef,926,1,'',0.00,GETDATE(),GETDATE(),'Unlimited Landline Calls - Freebie',0,'',0.00,'','','','','',@orderType,0)
			
			INSERT INTO [dbo].[b4nOrderLine] ([storeid],[OrderRef],[ProductID],[Quantity],[Instructions],[Price],[createDate],[modifyDate],[itemName],[giftWrappingTypeId],[giftWrappingDescription],[giftWrappingCost],[gen1],[gen2],[gen3],[gen4],[gen5],[gen6],[refunded])
			VALUES (1,@orderRef,933,1,'',0.00,GETDATE(),GETDATE(),'Call Europe - Free',0,'',0.00,'','','','','',@orderType,0)
		END	
		
		IF(@devicePeopleSoftId IN ('50740','50752','50787') AND @tariffProductCode IN ('T010127XX24') AND GETDATE() < '01/01/2014')
		BEGIN
			INSERT INTO [dbo].[b4nOrderLine] ([storeid],[OrderRef],[ProductID],[Quantity],[Instructions],[Price],[createDate],[modifyDate],[itemName],[giftWrappingTypeId],[giftWrappingDescription],[giftWrappingCost],[gen1],[gen2],[gen3],[gen4],[gen5],[gen6],[refunded])
			VALUES (1,@orderRef,926,1,'',0.00,GETDATE(),GETDATE(),'Unlimited Landline Calls - Freebie',0,'',0.00,'','','','','',@orderType,0)
		END	
		
		IF(@devicePeopleSoftId IN ('50757','50797') AND @tariffProductCode IN ('T010124') AND @channel = 'UK000000291')
		BEGIN
			INSERT INTO [dbo].[b4nOrderLine] ([storeid],[OrderRef],[ProductID],[Quantity],[Instructions],[Price],[createDate],[modifyDate],[itemName],[giftWrappingTypeId],[giftWrappingDescription],[giftWrappingCost],[gen1],[gen2],[gen3],[gen4],[gen5],[gen6],[refunded])
			VALUES (1,@orderRef,929,1,'',0.00,GETDATE(),GETDATE(),'Internet Mini - Freebie',0,'',0.00,'','','','','',@orderType,0)
		END	
	END
END





GRANT EXECUTE ON h3giPlaceOrderLine TO b4nuser
GO
