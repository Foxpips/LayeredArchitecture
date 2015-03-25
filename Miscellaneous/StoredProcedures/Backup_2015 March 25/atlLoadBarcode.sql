

/****** Object:  Stored Procedure dbo.atlLoadBarcode    Script Date: 23/06/2005 13:30:55 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	atlLoadBarcode
** Author		:	Niall Carroll
** Date Created		:	27/01/2005
** Version		:	1.0.1	
**					
**********************************************************************************************************************
**				
** Description		:	Uses barcode import table to update existing barcodes and insert new  
**				barcodes which do not already exist (validated against productID)
** -------------------------------
** Revision		:	1.0.1 - Removed Cursor and replaced with update and insert statements
**					for imrproved performance - ncarroll - 02 Feb 2005
**********************************************************************************************************************/
CREATE PROCEDURE dbo.atlLoadBarcode AS
BEGIN


/*
DECLARE @Barcode 		varchar(13)
DECLARE @ProductID 		int
DECLARE @nextRevision 	int
DECLARE @IsDel		int

SELECT @nextRevision = idvalue + 1 FROM b4nSysDefaults WHERE idname = 'revisionno'
*/




		UPDATE 	
			APF
		SET 
			APF.attributeValue = B.Barcode
		FROM
			b4nAttributeProductFamily APF (nolock) INNER JOIN atlImportBarcode B (nolock) ON
				APF.productFamilyID = B.ProductID
		WHERE 
			APF.attributeID 		= 56
		AND	B.IsDel			= 0


		INSERT INTO b4nAttributeProductFamily
			(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
		SELECT
			ProductID, 1, 56, Barcode, 0, 0, 0, 0, '', '', GetDate(), GetDate()
		FROM 
			atlImportBarcode
		WHERE
			ProductID NOT IN
			(
				SELECT ProductFamilyID FROM b4nAttributeProductFamily WHERE attributeID 	= 56
			)


/*

DECLARE curBarcode  CURSOR FOR 
SELECT	Barcode,
		ProductID,
		IsDel
FROM 
		atlImportBarcode (nolock)

 OPEN curBarcode
 FETCH NEXT FROM curBarcode 
 INTO  
	@Barcode,
	@ProductID,
	@IsDel




 WHILE (@@FETCH_STATUS = 0)
 BEGIN
	IF @IsDel = 0
	BEGIN
		UPDATE 	
			b4nAttributeProductFamily
		SET 
			attributeValue = @Barcode
		WHERE 
			attributeID = 56
		AND	productFamilyId = @ProductID
	END
	ELSE
	BEGIN
		UPDATE 	
			b4nAttributeProductFamily
		SET 
			attributeValue = @Barcode
		WHERE 
			attributeID = 56
		AND	productFamilyId = @ProductID
	END


	-- If there has been no update for this row, then insert the barcode as new
	IF (@@rowcount = 0 AND @IsDel = 0)
	BEGIN
		INSERT INTO b4nAttributeProductFamily
			(ProductFamilyID, StoreID, attributeID, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, attributeImageName, attributeImageNameSmall, ModifyDate, CreateDate)
		SELECT
			@ProductID, 1, 56, @Barcode, 0, 0, 0, 0, '', '', GetDate(), GetDate()
	END
     
	FETCH NEXT FROM curBarcode 
	INTO  
		@Barcode,
		@ProductID,
		@IsDel
END  -- while

 CLOSE curBarcode 
 DEALLOCATE curBarcode
 */
END


GRANT EXECUTE ON atlLoadBarcode TO b4nuser
GO
GRANT EXECUTE ON atlLoadBarcode TO helpdesk
GO
GRANT EXECUTE ON atlLoadBarcode TO ofsuser
GO
GRANT EXECUTE ON atlLoadBarcode TO reportuser
GO
GRANT EXECUTE ON atlLoadBarcode TO b4nexcel
GO
GRANT EXECUTE ON atlLoadBarcode TO b4nloader
GO
