

/****** Object:  Stored Procedure dbo.b4nAddToBasketAttribute    Script Date: 23/06/2005 13:30:59 ******/




CREATE    procedure dbo.b4nAddToBasketAttribute

	@nBasketId 		INT,
	@nAttributeId 		INT,
	@nAttributeRowId 	INT=null,
	@strAttributeUserValue 	VARCHAR(8000),
	@nProductFamilyID 	INT = 0

AS
	

	/*
	IF(@nProductFamilyID <> 0)
	BEGIN
		SELECT @nAttributeRowId = ISNULL(attributerowid, 0) 
		FROM b4nattributeproductfamily
		WHERE attributeid = @nAttributeId
	END
	*/

	INSERT INTO b4nBasketAttribute (basketId,attributeid,AttributeRowId,AttributeUserValue)
	VALUES (@nBasketId,@nAttributeId,@nAttributeRowId,@strAttributeUserValue)



GRANT EXECUTE ON b4nAddToBasketAttribute TO b4nuser
GO
GRANT EXECUTE ON b4nAddToBasketAttribute TO helpdesk
GO
GRANT EXECUTE ON b4nAddToBasketAttribute TO ofsuser
GO
GRANT EXECUTE ON b4nAddToBasketAttribute TO reportuser
GO
GRANT EXECUTE ON b4nAddToBasketAttribute TO b4nexcel
GO
GRANT EXECUTE ON b4nAddToBasketAttribute TO b4nloader
GO
