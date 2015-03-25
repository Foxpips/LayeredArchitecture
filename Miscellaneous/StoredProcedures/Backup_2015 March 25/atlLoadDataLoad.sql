

/****** Object:  Stored Procedure dbo.atlLoadDataLoad    Script Date: 23/06/2005 13:30:57 ******/
/*********************************************************************************************************************																				
** Procedure Name	:	atlLoadDataLoad
** Author		:	Niall Carroll
** Date Created		:	07/04/2005
** Version		:	1.0.0	
**					
**********************************************************************************************************************
** Description		:	Replaces all other dataload SP'. Parses dataload tables and updates / inserts the 
**				dataload info for categories/products/pricing. Barcode info is now ignored.
**				SKU's are now the default matching criteria. 
**********************************************************************************************************************
** Affects		:	Inserts: b4nProduct, b4nProductFamily, b4nAttributeProductFamily, b4nCategoryProduct
**			:	Updates: b4nAttributeProductFamily, b4nCategoryProduct, b4nsysDefaults
**********************************************************************************************************************/
CREATE PROCEDURE dbo.atlLoadDataLoad AS

---------------------------------------------------------
-- PRE-WORK
---------------------------------------------------------
UPDATE
 	atlImportInfoDet
SET
	Detail = LTRIM(RTRIM(Replace(Detail, '~', '<br>')))


EXEC 	atlFormatProductDescCase


-------------------------------
-- Variables for cursor
-------------------------------
DECLARE @storeID 	INT
DECLARE @SKU 	INT
DECLARE @Cat 	INT
DECLARE @Name	VARCHAR(255)
DECLARE @Price	DECIMAL(9,2)
DECLARE @IsDel	INT
DECLARE @ProductID	INT
DECLARE @Ratio	DECIMAL(9,2)
DECLARE @UnitDesc	VARCHAR(20)
DECLARE @Desc	VARCHAR(500)

-- Populated in Cursor internally
DECLARE @NewProductID INT
DECLARE @UnitCode	INT


-------------------------------
-- SET UP PRODUCT IMPORT CURSOR
-------------------------------
DECLARE curImp CURSOR FOR
SELECT
	imp.StoreID, 
	imp.ProductID as SKU, 
	Cast (CategoryID as INT) as Cat, 
	Name, 
	Price, 
	imp.IsDel, 
	apf.ProductFamilyID,
	impUP.Ratio,
	impUP.UnitPriceDesc,
	impDet.Detail
FROM 
	atlImportProduct imp 
		left outer join 
	atlImportUnitPrc impUP on imp.ProductID = impUP.ProductID
		left outer join 
 	atlImportInfoDet impDet on imp.ProductID = impDet.ProductID
		left outer join 
	b4nAttributeProductFamily apf on imp.ProductID = apf.attributeValue and apf.attributeID = 3

-- Open the cursor and fetch away
OPEN curImp
FETCH NEXT FROM curImp
INTO 
 @storeID, @SKU, @Cat, @Name, @Price, @IsDel, @ProductID, @Ratio, @UnitDesc, @Desc

WHILE @@Fetch_Status = 0
BEGIN 
	SELECT 	@UnitCode = 
		CASE RTRIM(LTRIM(@UnitDesc))
			WHEN 'KILO' 	THEN 1
			WHEN 'KG' 	THEN 1
			WHEN 'LITRE' 	THEN 2
			WHEN 'METRE' 	THEN 3
			WHEN 'SQ MTR' 	THEN 4
			ELSE 		0
		END

--	SELECT  @storeID,  @SKU, @Cat, @Name, @Price, @IsDel, @ProductID, @Ratio, @UnitDesc, @UnitCode, @Desc

	-- Check by SKU....
	IF EXISTS (SELECT attributeValue FROM b4nAttributeProductFamily WHERE attributeValue = @SKU AND attributeID = 3)
	BEGIN 
		PRINT 'UPDATE' + ' - ' + Cast(@SKU as varchar(10)) + ' - ' + Cast(@ProductID as varchar(20))
		/*********************************************************************************
		* UPDATE EXISTING PRODUCT INFORMATION
		*********************************************************************************/

		/**********************************************************
		* UPDATE Attributes
		**********************************************************/
		-- PRICE
		UPDATE 	b4nAttributeProductFamily
		SET	attributeValue = @Price
		WHERE	b4nAttributeProductFamily.attributeID = 19
		AND	ProductFamilyID = @ProductID 

		-- UPPM
		UPDATE 	b4nattributeProductFamily 
		SET 	attributeValue = @Price * @Ratio  
		WHERE 	ProductFamilyID = @ProductID 
		AND 	attributeID = 220

		-- UNIT TYPE
		UPDATE 	b4nattributeProductFamily 
		SET 	attributeValue = @UnitCode  
		WHERE 	ProductFamilyID = @ProductID 
		AND 	attributeID = 1206
	
		/**********************************************************
		* UPDATE Category info
		**********************************************************/
		IF EXISTS (SELECT sourceCategory FROM genCategoryTransform WHERE sourceCategory = @Cat)
		BEGIN 
			IF NOT (EXISTS (SELECT productID from b4nCategoryProduct WHERE productID = @ProductID))
			BEGIN
					INSERT INTO b4nCategoryProduct
						(CategoryID, StoreID, ProductID, priority, CreateDate, ModifyDate)
					SELECT
						gen.destCategory, @StoreID, @ProductID, 0, GetDate(), GetDate()
					FROM
						genCategoryTransform gen WHERE gen.sourceCategory = @Cat
			END
		END

		-- SELECT * FROM genCategoryTransform
		-- SELECT * FROM b4nCategoryProduct
	END
	ELSE
	BEGIN 
		--SELECT 'INSERT', @SKU
		/*********************************************************************************
		* INSERT NEW PRODUCT INFORMATION
		*********************************************************************************/
		UPDATE 	b4nSysDefaults
		SET		idValue = idValue + 1
		WHERE	idName in ('ProductID','ProductFamilyID')

		SELECT @NewProductID = idValue FROM b4nSysDefaults WHERE idName = 'ProductFamilyID'

		PRINT 'INSERT' + ' - ' + Cast(@SKU as varchar(10)) + ' - ' + Cast(@NewProductID as varchar(10))

		-- INSERT NEW PRODUCT / FAMILY INFORMATION
		-- Product
		INSERT INTO b4nProduct 
			(productID, productFamilyID, revisionNo, deleted, createDate, modifyDate)
		SELECT 
			@NewProductID, @NewProductID, 1, @IsDel,  GetDate(),  GetDate() 
		-- Product Family
		INSERT INTO b4nProductFamily
			(productFamilyID, createDate, modifyDate, attributeCollectionID, storeID)
		SELECT
			@NewProductID, GetDate(), GetDate(), 1, @storeID
		
		/**********************************************************
		* Insert Attributes
		**********************************************************/
		-- SKU
		INSERT INTO b4nAttributeProductFamily 
			(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
		SELECT
			@NewProductID, @storeID, 3, @SKU, 0, 0, 0, 0, '', '', GetDate(), GetDate()  
		-- NAME
		INSERT INTO b4nAttributeProductFamily 
			(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
		SELECT
			@NewProductID, @storeID, 2, @Name, 0, 0, 0, 0, '', '', GetDate(), GetDate()  
		-- BASE PRICE
		INSERT INTO b4nAttributeProductFamily 
			(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
		SELECT
			@NewProductID, @storeID, 19, @Price, 0, 0, 0, 0, '', '', GetDate(), GetDate() 
		-- SMALL IMAGE
		INSERT INTO b4nAttributeProductFamily 
			(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
		SELECT @NewProductID, @storeID, 15, 's' + Cast(@SKU as varchar(10)) + '.jpg', 0,0,0,0,'', '',  GetDate(), GetDate()	
		-- LARGE IMAGE
		INSERT INTO b4nAttributeProductFamily 
			(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
		SELECT @NewProductID, @storeID, 16, 'p' + Cast(@SKU as varchar(10)) + '.jpg', 0,0,0,0,'', '',  GetDate(), GetDate()
		-- DESC
		INSERT INTO b4nAttributeProductFamily
			(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
		SELECT
			@NewProductID, @storeID, 50, @Desc, 0, 0, 0, 0, '', '', GetDate(), GetDate()
		/**********************************************************
		* Insert Attributes (UNIT PRICE INFO)
		**********************************************************/
		-- UPPM
		INSERT INTO b4nAttributeProductFamily 
			(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
		VALUES
			(@NewProductID, @StoreID, 220,  @Price * @Ratio, 0, 0, 0, 0, '', '', GetDate(), GetDate())
		
		-- UNIT TYPE
		INSERT INTO b4nAttributeProductFamily 
			(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
		VALUES
			(@NewProductID, @StoreID, 1206,  @UnitCode, 0, 0, 0, 0, '', '', GetDate(), GetDate())

		/**********************************************************
		* INSERT Category info
		**********************************************************/
		IF EXISTS (SELECT sourceCategory FROM genCategoryTransform WHERE sourceCategory = @Cat)
		BEGIN 
			INSERT INTO b4nCategoryProduct
				(CategoryID, StoreID, ProductID, priority, CreateDate, ModifyDate)
			SELECT
				gen.destCategory, @StoreID, @NewProductID, 0, GetDate(), GetDate()
			FROM
				genCategoryTransform gen WHERE gen.sourceCategory = @Cat
		END
		
	END

	FETCH NEXT FROM curImp
	INTO 
	 @storeID, @SKU, @Cat, @Name, @Price, @IsDel, @ProductID, @Ratio, @UnitDesc, @Desc

END

CLOSE curImp
DEALLOCATE curImp


GRANT EXECUTE ON atlLoadDataLoad TO b4nuser
GO
GRANT EXECUTE ON atlLoadDataLoad TO helpdesk
GO
GRANT EXECUTE ON atlLoadDataLoad TO ofsuser
GO
GRANT EXECUTE ON atlLoadDataLoad TO reportuser
GO
GRANT EXECUTE ON atlLoadDataLoad TO b4nexcel
GO
GRANT EXECUTE ON atlLoadDataLoad TO b4nloader
GO
