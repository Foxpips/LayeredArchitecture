
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 15-Jan-2013
-- Description:	Gets all the e-mail templates.
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetEmailTemplates]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;   
	
	SELECT emailid, emailDescription
	FROM h3giEmailTemplate
	WHERE emailFormat = 1
	AND emailTypeCodeId NOT IN ('PREPAY_ADDONS','BLANK_ADDRESS')
END


GRANT EXECUTE ON h3giGetEmailTemplates TO b4nuser
GO
