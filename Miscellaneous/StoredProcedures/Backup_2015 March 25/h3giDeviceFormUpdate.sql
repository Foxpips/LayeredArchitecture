
/**********************************************************************************************************************
	S Mooney [h3giDeviceFormUpdate] Created 16 Feb 2012
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giDeviceFormUpdate]
(
	@formId INT,
	@formName NVARCHAR(50),
	@image NVARCHAR(250),
	@showInFilter BIT = 1,
	@enabled BIT = 1
)

AS
BEGIN
SET NOCOUNT ON

	UPDATE h3giDeviceForm
	SET name = @formName, image = @image, showInFilter = @showInFilter, enabled = @enabled
	WHERE formId = @formId
	
END



GRANT EXECUTE ON h3giDeviceFormUpdate TO b4nuser
GO
