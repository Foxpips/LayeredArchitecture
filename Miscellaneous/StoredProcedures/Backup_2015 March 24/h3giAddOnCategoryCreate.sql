
CREATE PROCEDURE dbo.h3giAddOnCategoryCreate 
	@name varchar(20),
	@addOnCategoryId INT OUTPUT
AS
BEGIN
	SELECT TOP 1 @addOnCategoryId = addOnCategoryId FROM h3giAddOnCategory
	WHERE title = @name

	IF @addOnCategoryId IS NULL
	BEGIN
		INSERT INTO h3giAddOnCategory(title, description)
		VALUES (@name, @name + ' Add Ons')
		
		SET @addOnCategoryId = SCOPE_IDENTITY()
	END
END

GRANT EXECUTE ON h3giAddOnCategoryCreate TO b4nuser
GO
GRANT EXECUTE ON h3giAddOnCategoryCreate TO ofsuser
GO
GRANT EXECUTE ON h3giAddOnCategoryCreate TO reportuser
GO
