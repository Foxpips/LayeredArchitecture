

/****** Object:  Stored Procedure dbo.atlFormatProductDescCase    Script Date: 23/06/2005 13:30:55 ******/
CREATE PROCEDURE dbo.atlFormatProductDescCase AS

SET NOCOUNT ON

DECLARE @charLoc 	int
DECLARE @Length 	int
DECLARE @strTemp	varchar(255)
DECLARE @upNext	int

-- CURSOR VARS
DECLARE @pfID 	int
DECLARE @sID		int
DECLARE @Value  	varchar(255)

DECLARE PNames CURSOR FAST_FORWARD FOR
	SELECT 	productID, [Name]
	FROM 		atlImportProduct 

OPEN PNames

FETCH NEXT FROM PNames INTO @pfID, @Value

WHILE @@FETCH_STATUS = 0
BEGIN 
	SET @strTemp	= UPPER(SubString(@Value, 1, 1))
	SET @charLoc	= 1
	SET @Length 	= Len(@Value)
	SET @upNext	= -1
/*
	ASCII new word delim' Codes
	' ' 	= 32
	',' 	= 44
	'.' 	= 46
	CR	= 13
	Tab	= 9
	';' 	= 59
	'/' 	= 47
	'\' 	= 92
*/
	WHILE @charLoc != @Length
	BEGIN
		IF ASCII(SubString(@Value, @charLoc, 1)) NOT IN (32, 46, 13, 9, 44, 59, 47, 92)
		BEGIN 
			SET @strTemp = @strTemp + LOWER(SubString(@Value, @charLoc + 1, 1))
		END
		ELSE
		BEGIN
			SET @strTemp = @strTemp + UPPER(SubString(@Value, @charLoc + 1, 1))
		END

		SET @charLoc = @charLoc + 1

		-- PRINT SubString(@Value, @charLoc, 1)
		
	END

	-- PRINT @strTemp

	UPDATE 	atlImportProduct
	SET		[Name]		= @strTemp
	WHERE	productID 	= @pfID 

	FETCH NEXT FROM PNames INTO @pfID, @Value

END


CLOSE PNames
DEALLOCATE PNames


-- select top 100 from productFamilyID where
-- select * from b4nAttributeProductFamily where attributeID = 2


GRANT EXECUTE ON atlFormatProductDescCase TO b4nuser
GO
GRANT EXECUTE ON atlFormatProductDescCase TO helpdesk
GO
GRANT EXECUTE ON atlFormatProductDescCase TO ofsuser
GO
GRANT EXECUTE ON atlFormatProductDescCase TO reportuser
GO
GRANT EXECUTE ON atlFormatProductDescCase TO b4nexcel
GO
GRANT EXECUTE ON atlFormatProductDescCase TO b4nloader
GO
