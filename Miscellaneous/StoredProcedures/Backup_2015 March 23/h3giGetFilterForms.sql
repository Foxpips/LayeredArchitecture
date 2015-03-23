
CREATE PROCEDURE [dbo].[h3giGetFilterForms]

AS
BEGIN

	SET NOCOUNT ON

	SELECT formId, name, image FROM h3giDeviceForm
	WHERE enabled = 1
		AND showInFilter = 1
	
END




GRANT EXECUTE ON h3giGetFilterForms TO b4nuser
GO
