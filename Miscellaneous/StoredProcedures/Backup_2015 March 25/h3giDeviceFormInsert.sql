
/**********************************************************************************************************************
	S Mooney [h3giDeviceFormInsert] Created 16 Feb 2012
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giDeviceFormInsert]
(
	@formName NVARCHAR(50),
	@image NVARCHAR(250),
	@showInFilter BIT = 1,
	@enabled BIT = 1
)

AS
BEGIN
SET NOCOUNT ON

	INSERT INTO h3giDeviceForm
	(name, image, showInFilter, enabled)
	VALUES
	(@formName, @image, @showInFilter, @enabled)
	
END



GRANT EXECUTE ON h3giDeviceFormInsert TO b4nuser
GO
