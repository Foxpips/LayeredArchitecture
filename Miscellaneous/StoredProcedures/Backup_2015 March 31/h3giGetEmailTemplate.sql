
CREATE PROCEDURE h3giGetEmailTemplate 
	@emailTypeCode varchar(50)
AS
BEGIN
	SELECT * FROM h3giEmailTemplate
	WHERE emailTypeCodeId = @emailTypeCode
END

GRANT EXECUTE ON h3giGetEmailTemplate TO b4nuser
GO
GRANT EXECUTE ON h3giGetEmailTemplate TO ofsuser
GO
GRANT EXECUTE ON h3giGetEmailTemplate TO reportuser
GO
