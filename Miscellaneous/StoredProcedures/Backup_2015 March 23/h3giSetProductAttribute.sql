
/********************************************************************************
Changes:		20/11/2012	-	Stephen Quin	-	Modified transaction creation
													and error handling
*********************************************************************************/

CREATE PROCEDURE [dbo].[h3giSetProductAttribute] 
	@attributeName VARCHAR(50),
	@attributeValue VARCHAR(8000),
	@productfamilyid INT,
	@storeId INT, 
	@affectsBasePriceBy REAL,
	@affectsRrpPriceBy REAL	
AS
BEGIN
	DECLARE @newTran BIT
	SET @newTran = 0

	IF @@TRANCOUNT = 0 	--if not in a transaction context yet
	BEGIN
		SET @newTran = 1
		BEGIN TRANSACTION SetAttribute
	END

	BEGIN TRY
		DECLARE @attributeId INT
		SET @attributeId = dbo.fn_GetAttributeByName(@attributeName)

		IF NOT EXISTS (SELECT * FROM b4nAttributeProductFamily WHERE productFamilyId = @productFamilyId AND attributeId = @attributeId)
		BEGIN
			INSERT INTO dbo.b4nAttributeProductFamily
			(productFamilyId, storeId, attributeId, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, 
						  attributeImageName, attributeImageNameSmall, modifyDate, createDate)
			VALUES(@productfamilyid,
				@storeId,
				@attributeId,
				@attributeValue,
				0,
				@affectsBasePriceBy,
				@affectsRrpPriceBy,
				0,
				'',
				'',
				GETDATE(),
				GETDATE())
		END
		ELSE
		BEGIN
			UPDATE dbo.b4nAttributeProductFamily
			SET attributeValue = @attributeValue
			WHERE productFamilyId = @productFamilyId
				AND attributeId = @attributeId
		END
		
		IF @@TRANCOUNT > 0 AND @newTran = 1
		BEGIN
			COMMIT TRANSACTION SetAttribute
		END
			RETURN 0
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 AND @newTran = 1
		BEGIN
			ROLLBACK TRANSACTION SetAttribute
		END
		RETURN -1
	END CATCH
		
END





GRANT EXECUTE ON h3giSetProductAttribute TO b4nuser
GO
GRANT EXECUTE ON h3giSetProductAttribute TO ofsuser
GO
GRANT EXECUTE ON h3giSetProductAttribute TO reportuser
GO
