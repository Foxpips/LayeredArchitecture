-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 11-Apr-2013
-- Description:	Inserts a record into threeOrderUpgradeHeader table.
-- Modifed 06/06/2013 -- Simon : Added new salesAssociatedId/Name
-- Modifed 06/06/2013 -- Simon : Added new prevContractLength
-- Modifed 06/12/2013 -- SKing : Added incomingBand
-- =============================================
CREATE PROCEDURE [dbo].[threeInsertOrderUpgradeHeader]
(
	@orderRef			INT OUT,
	@upgradeId			INT,	
	@channelCode		VARCHAR(20),
	@parentId			INT,
	@childTariffId		INT,
	@deviceId			INT,
	@catalogueVersionId INT,
	@totalOoc			MONEY,
	@totalMrc			MONEY,
	@contractStartDate	DATETIME,
	@IMEI				VARCHAR(50),
	@userId				INT,
	@storeCode			VARCHAR(20),
	@retailerCode		VARCHAR(20),
	@contractDuration	INT,
	@outgoingBand		VARCHAR(3),
	@incomingBand		VARCHAR(3),
	@salesAssociateName	VARCHAR(255) = '',
	@salesAssociateId	INT = NULL
)
AS
BEGIN 
	SET @orderRef = 0;
    
	DECLARE @orderStatus INT,  	
	@orderDate DATETIME
	
	SELECT @orderStatus = dbo.fnDeterminePostPlacementStatus(2, @channelCode, 0);
	
	--Hack for "No Handset"!
	DECLARE @noHandsetId INT
	SELECT @noHandsetId = catalogueProductId FROM h3giProductCatalogue WHERE peoplesoftID = '10000'   
	
	--Hack for "previousContractLength"!
	DECLARE @prevContractLength INT
	SELECT @prevContractLength = datediff(m,upgrade.contractStartDate,@contractStartDate) 
	FROM threeUpgrade upgrade 
	WHERE upgrade.upgradeId = @upgradeId
	
	IF (@deviceId = @noHandsetId AND @channelCode IN ('UK000000291','UK000000294'))
	BEGIN		
		SET @orderStatus = 309
	END    
	
	SET @orderDate = GETDATE();
		  
	INSERT INTO [dbo].[b4nOrderHeader]  
	(OrderID, StoreID, ZoneID, CustomerID, OrderDate, Status, GoodsPrice)  
	VALUES  
	(1, 1, 1, 0, @orderDate, @orderStatus, 0.0);
	
	SET @orderRef = SCOPE_IDENTITY(); 
	  
	INSERT INTO [h3gi].[dbo].[threeOrderUpgradeHeader]
			   ([orderref]
			   ,[upgradeId]
			   ,[orderDate]
			   ,[status]
			   ,[channelCode]
			   ,[parentId]
			   ,[childTariffId]
			   ,[deviceId]
			   ,[catalogueVersionId]
			   ,[totalOOC]
			   ,[totalMRC]
			   ,[contractStartDate]
			   ,[IMEI]
			   ,[userId]
			   ,[storeCode]
			   ,[retailerCode]
			   ,[contractDuration]
			   ,[outgoingBand]
			   ,[salesAssociateName]
			   ,[salesAssociateId]
			   ,[previousContractLength]
			   ,[incomingBand] )
		 VALUES(
				@orderRef,
				@upgradeId,
				@orderDate,
				@orderStatus,
				@channelCode,
				@parentId,
				@childTariffId,
				@deviceId,
				@catalogueVersionId,
				@totalOoc,
				@totalMrc,
				@contractStartDate,
				@IMEI,
				@userId,				
				@storeCode,
				@retailerCode,
				@contractDuration,
				@outgoingBand,
				@salesAssociateName,
				@salesAssociateId,
				@prevContractLength,
				@incomingBand
		 ) 
		 
		IF (@deviceId = @noHandsetId AND @channelCode IN ('UK000000291','UK000000294'))
		BEGIN		
			INSERT INTO gmOrdersDispatched
			VALUES (@orderRef, 2)
		END    
	END 

GRANT EXECUTE ON threeInsertOrderUpgradeHeader TO b4nuser
GO
