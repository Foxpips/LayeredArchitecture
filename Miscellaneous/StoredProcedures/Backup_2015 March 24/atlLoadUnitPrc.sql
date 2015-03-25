

/****** Object:  Stored Procedure dbo.atlLoadUnitPrc    Script Date: 23/06/2005 13:30:58 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	atlLoadUnitPrc
** Author		:	Niall Carroll
** Date Created		:	27/01/2005
** Version		:	1.0.0	
**					
**********************************************************************************************************************
**				
** Description		:	Update or Create Unit price attribute of products
**********************************************************************************************************************/

CREATE PROCEDURE dbo.atlLoadUnitPrc AS

DECLARE @Ratio 	real
DECLARE @UnitID 	int
DECLARE @UnitName	varchar(7)
DECLARE @StoreID 	int
DECLARE @ProductID 	int
DECLARE @Price	real

DECLARE curUnitPrc CURSOR FOR
	SELECT
		UP.StoreID,
		UP.ProductID,
		UP.Ratio,
		UP.UnitPriceDesc,
		P.Price
	FROM
		atlImportUnitPrc UP inner join atlImportProduct P 
			on UP.ProductID = P. ProductID AND UP.StoreID = P.StoreID
		

OPEN 	curUnitPrc

FETCH NEXT FROM curUnitPrc INTO
	@StoreID,
	@ProductID,
	@Ratio,
	@UnitName,
	@Price
	
WHILE @@FETCH_STATUS = 0
BEGIN

	SELECT 
		@UnitID = 
		CASE RTRIM(LTRIM(@UnitName))
			WHEN 'KILO' 		THEN 1
			WHEN 'KG' 		THEN 1
			WHEN 'LITRE' 		THEN 2
			--WHEN 'LITER' 		THEN 2
			WHEN 'METRE' 		THEN 3
			--WHEN 'METER' 		THEN 3
			WHEN 'SQ MTR' 	THEN 4
			ELSE 			0
		END

	-- Unit Price Per Measure
	IF EXISTS (SELECT * FROM b4nattributeProductFamily WHERE ProductFamilyID = @ProductID AND attributeID = 220)
	BEGIN
		UPDATE b4nattributeProductFamily SET attributeValue = @Price * @Ratio  WHERE ProductFamilyID = @ProductID AND attributeID = 220
	END
	ELSE
	BEGIN
		INSERT INTO b4nAttributeProductFamily 
			(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
		VALUES
			(@ProductID, @StoreID, 220,  @Price * @Ratio, 0, 0, 0, 0, '', '', GetDate(), GetDate())
	END

	-- Set the Unit Type
	IF EXISTS (SELECT * FROM b4nattributeProductFamily WHERE ProductFamilyID = @ProductID AND attributeID = 1206)
	BEGIN
		UPDATE b4nattributeProductFamily SET attributeValue = @UnitID  WHERE ProductFamilyID = @ProductID AND attributeID = 1206
	END
	ELSE
	BEGIN
		INSERT INTO b4nAttributeProductFamily 
			(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
		VALUES
			(@ProductID, @StoreID, 1206,  @UnitID, 0, 0, 0, 0, '', '', GetDate(), GetDate())
	END

	FETCH NEXT FROM curUnitPrc INTO
		@StoreID,
		@ProductID,
		@Ratio,
		@UnitName,
		@Price
END

CLOSE curUnitPrc
DEALLOCATE curUnitPrc


GRANT EXECUTE ON atlLoadUnitPrc TO b4nuser
GO
GRANT EXECUTE ON atlLoadUnitPrc TO helpdesk
GO
GRANT EXECUTE ON atlLoadUnitPrc TO ofsuser
GO
GRANT EXECUTE ON atlLoadUnitPrc TO reportuser
GO
GRANT EXECUTE ON atlLoadUnitPrc TO b4nexcel
GO
GRANT EXECUTE ON atlLoadUnitPrc TO b4nloader
GO
