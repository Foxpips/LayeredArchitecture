

-- =============================================
-- Author:		Stephen Quin
-- Create date: 22/02/10
-- Description:	Deactivates a handset across all
--				channels for a specific order
--				type
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueDeactivateProductAcrossAllChannels]
	@peopleSoftId VARCHAR(50),
	@orderType INT,
	@productType VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @NewTranCreated INT
	DECLARE @validEndDate DATETIME
	DECLARE @catalogueProductId INT
    
	IF @@TRANCOUNT = 0  --if not in a transaction context yet    
	BEGIN    
	 SET @NewTranCreated = 1    
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
	 BEGIN TRANSACTION  --then create a new transaction    
	END    

	SET @validEndDate = '31 dec 2007'
	
	UPDATE	h3giProductCatalogue
	SET		validEndDate = @validEndDate
	FROM h3giProductCatalogue catalogue
    INNER JOIN h3giProductAttributeValue attribute
		ON catalogue.catalogueProductID = attribute.catalogueProductId
		AND attribute.attributeId = 2
	WHERE	catalogue.peopleSoftId = @peopleSoftId
	AND		catalogue.prepay = @orderType
	AND		attribute.attributeValue = @productType
	AND		catalogue.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()

	IF @@ERROR <> 0 GOTO ERROR_HANDLER;  
	
	SELECT	@catalogueProductId = catalogue.catalogueProductId
	FROM	h3giProductCatalogue catalogue
    INNER JOIN h3giProductAttributeValue attribute
		ON catalogue.catalogueProductID = attribute.catalogueProductId
		AND attribute.attributeId = 2
	WHERE	peopleSoftId = @peopleSoftId
	AND		prepay = @orderType
	AND		attribute.attributeValue = @productType
	AND		catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	
	DELETE FROM	h3giRetailerHandset
	WHERE	catalogueProductId = @catalogueProductId
	AND		catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	
	IF @@ERROR <> 0 GOTO ERROR_HANDLER;  
	
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0    
		COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure    
    
	RETURN 0    
      
	ERROR_HANDLER:    
		IF @NewTranCreated=1 AND @@TRANCOUNT > 0     		
			ROLLBACK TRANSACTION  --rollback all changes      

		RAISERROR('h3giCatalogueDeactivateProductAcrossAllChannels: FATAL ERROR', 16,1)  
END


GRANT EXECUTE ON h3giCatalogueDeactivateProductAcrossAllChannels TO b4nuser
GO
