

/****** Object:  Stored Procedure dbo.atlLoadProduct    Script Date: 23/06/2005 13:30:58 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	atlLoadProduct
** Author		:	Niall Carroll
** Date Created		:	27/01/2005
** Version		:	1.0.1	
**					
** Rev 1.0.1		:	ncarroll - Using category mapping tables instead of using categories 
**				supplied by atlantic, also deleting from b4nProduct where no mapping exist
**********************************************************************************************************************
**				
** Description		:	Update or Create Products, Category Mapping for Products, 
**				Product attributes from the dataload.
**********************************************************************************************************************/

CREATE PROCEDURE dbo.atlLoadProduct AS

DECLARE @RevisionNo 		int

SELECT @RevisionNo = idvalue + 1 FROM b4nSysDefaults WHERE idname = 'revisionno'


/*	ASSUMES ~ indicates a new Line	*/
UPDATE
 	atlImportInfoDet
SET
	Detail = LTRIM(RTRIM(Replace(Detail, '~', '<br>')))


-- Create the Product
INSERT INTO b4nProduct (productID, productFamilyID, revisionNo, deleted, createDate, modifyDate)
SELECT 		   ProductID, ProductID, @RevisionNo, IsDel, GetDate(), GetDate() 

FROM atlImportProduct WHERE ProductID not in 
	(select ProductID FROM b4nProduct)
AND
	CategoryID in (SELECT sourceCategory FROM genCategoryTransform)
	

-- Create the Product Family	
INSERT INTO b4nProductFamily
	(productFamilyID, createDate, modifyDate, attributeCollectionID, storeID)
SELECT
	ProductID, GetDate(), GetDate(), 1,StoreID
FROM  	atlImportProduct WHERE ProductID not in 
	(select productFamilyID FROM b4nProductFamily)
AND
	CategoryID in (SELECT sourceCategory FROM genCategoryTransform)


/*	UPDATE THE BASIC ATTRIBUTES OF EACH PRODUCT (if product already exists)	*/
/*
-- NAME NOT TO BE UPDATED
UPDATE 	APF
SET		attributeValue = ImpP.Name
FROM 	b4nAttributeProductFamily APF inner join atlImportProduct ImpP
		on	APF.productFamilyID = ImpP.ProductID AND APF.attributeID = 2
*/
UPDATE 	APF
SET		attributeValue = ImpP.Price
FROM 	b4nAttributeProductFamily APF inner join atlImportProduct ImpP
		on	APF.productFamilyID = ImpP.ProductID AND APF.attributeID = 19
/*
-- DON'T UPDATE THE DESCRIPTION

UPDATE 	APF
SET		attributeValue = ImpDet.Detail
FROM 	b4nAttributeProductFamily APF inner join atlImportInfoDet ImpDet
		on	APF.productFamilyID = ImpDet.ProductID AND APF.attributeID = 50
*/

-- NAME
INSERT INTO b4nAttributeProductFamily 
	(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
SELECT
	ProductID, StoreID, 2, Name, 0, 0, 0, 0, '', '', GetDate(), GetDate()  FROM atlImportProduct WHERE ProductID not in 
	(select ProductFamilyID FROM b4nAttributeProductFamily WHERE attributeID = 2 )
AND
	CategoryID in (SELECT sourceCategory FROM genCategoryTransform)

-- BASE PRICE
INSERT INTO b4nAttributeProductFamily 
	(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
SELECT
	ProductID, StoreID, 19, Price, 0, 0, 0, 0, '', '', GetDate(), GetDate() FROM atlImportProduct WHERE ProductID not in 
	(select ProductFamilyID FROM b4nAttributeProductFamily WHERE attributeID = 19 )
AND
	CategoryID in (SELECT sourceCategory FROM genCategoryTransform)

/*	IF THE IMAGE NAMING CONVENTION REMAINS THE SAME	*/
-- SMALL IMAGE
INSERT INTO b4nAttributeProductFamily 
	(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)

SELECT ProductID, StoreID, 15, 's' + Cast(ProductID as varchar(10)) + '.jpg', 0,0,0,0,'', '',  GetDate(), GetDate() FROM atlImportProduct WHERE ProductID not in 
	(select ProductFamilyID FROM b4nAttributeProductFamily WHERE attributeID = 15 )
AND
	CategoryID in (SELECT sourceCategory FROM genCategoryTransform)
-- LARGE IMAGE			
INSERT INTO b4nAttributeProductFamily 
	(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)

SELECT ProductID, StoreID, 16, 'p' + Cast(ProductID as varchar(10)) + '.jpg', 0,0,0,0,'', '',  GetDate(), GetDate() FROM atlImportProduct WHERE ProductID not in 
	(select ProductFamilyID FROM b4nAttributeProductFamily WHERE attributeID = 16 )
AND
	CategoryID in (SELECT sourceCategory FROM genCategoryTransform)
/*	LITTLE CONSISTANCY OF HOW TEXT IS CONSTRUCTED, USING LONG DESC	*/
-- Features list
INSERT INTO b4nAttributeProductFamily
	(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
SELECT
	ProductID, 1, 50, Detail, 0, 0, 0, 0, '', '', GetDate(), GetDate()
FROM
	atlImportInfoDet
WHERE
	ProductID NOT IN (SELECT ProductFamilyID FROM b4nAttributeProductFamily WHERE attributeID = 50)


/*	ASSIGN PRODUCTS TO NEW CATEGORIES (and assuming any current category mappings are left untouched) 	*/
-- Assign The products category


-- USING THE Mapping table instead
BEGIN TRAN
	TRUNCATE TABLE b4nCategoryProduct
	
	INSERT INTO b4nCategoryProduct
		(CategoryID, StoreID, ProductID, priority, CreateDate, ModifyDate)
	SELECT
		  gen.destCategory, StoreID, ProductID, 0, GetDate(), GetDate()
	FROM 
		atlImportProduct imp inner join genCategoryTransform gen on Cast(imp.CategoryID as int) = gen.sourceCategory
	/*
	WHERE
		gen.destCategory + '|' + Cast (StoreID as varchar(20)) + '|' + Cast (ProductID as varchar(20))	NOT IN 
	(
		SELECT Cast (CategoryID as varchar(20)) + '|' + Cast (StoreID as varchar(20)) + '|' + Cast (ProductID as varchar(20)) FROM b4nCategoryProduct
	)
	*/
	

	UPDATE 	b4nProduct 
	SET 		deleted = 2 
	WHERE 	ProductID not in 
		(
			SELECT productID from b4nCategoryProduct
		)	
	AND		ProductFamilyID < 100000
	
COMMIT TRAN

	
/*
-- Remove products that have no mapped categories
DELETE FROM b4nProduct WHERE productID in
(
	SELECT productId FROM b4nCategoryProduct WHERE CategoryID not in 
	(
		SELECT destCategory FROM genCategoryTransform
	)
)
*/


GRANT EXECUTE ON atlLoadProduct TO b4nuser
GO
GRANT EXECUTE ON atlLoadProduct TO helpdesk
GO
GRANT EXECUTE ON atlLoadProduct TO ofsuser
GO
GRANT EXECUTE ON atlLoadProduct TO reportuser
GO
GRANT EXECUTE ON atlLoadProduct TO b4nexcel
GO
GRANT EXECUTE ON atlLoadProduct TO b4nloader
GO
