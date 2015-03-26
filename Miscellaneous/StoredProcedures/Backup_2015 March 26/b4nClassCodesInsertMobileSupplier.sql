
-- =============================================
-- Author:		Stephen Quin
-- Create date: 28/11/2011
-- Description:	Adds a new mobile supplies to
--				the class codes table
-- =============================================
CREATE PROCEDURE [dbo].[b4nClassCodesInsertMobileSupplier]
	@mobileSupplierCode VARCHAR(2),
	@mobileSupplierName VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM b4nClassCodes WHERE b4nClassSysID = 'ExistingMobileSupplier' AND b4nClassCode = @mobileSupplierCode)
    BEGIN
				
		DECLARE @codeCounter INT
		DECLARE @codeCountVar VARCHAR(3)
		DECLARE @newCode VARCHAR(10)
		
		SET @codeCounter = 1

		SELECT TOP 1 @newCode = b4nClassCode 
		FROM b4nClassCodes 
		WHERE b4nClassSysID = 'ExistingMobileSupplier' 
		AND b4nClassCode LIKE '%' + @mobileSupplierCode + 'XX%' 
		ORDER BY b4nClassCode DESC
		
		IF @newCode IS NOT NULL
		BEGIN
			SELECT @codeCountVar = SUBSTRING(@newCode,PATINDEX('%XX%',@newCode)+2,LEN(@newCode))
			SET @codeCounter = CAST(@codeCountVar AS INT) + 1
		END
		
		SET @newCode = @mobileSupplierCode + 'XX' + CAST(@codeCounter AS VARCHAR(3))
		
		INSERT INTO b4nClassCodes 
		VALUES ('ExistingMobileSupplier', @newCode, @mobileSupplierName, 'Y', '')

    END
    ELSE
    BEGIN
		
		INSERT INTO b4nClassCodes
		VALUES ('ExistingMobileSupplier', @mobileSupplierCode, @mobileSupplierName, 'Y', '')
		
    END
    
END


GRANT EXECUTE ON b4nClassCodesInsertMobileSupplier TO b4nuser
GO
