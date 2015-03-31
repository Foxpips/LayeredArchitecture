
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 15-Jan-2013
-- Description:	Gets a certain e-mail template by id.
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetEmailTemplateById]
(
	@emailId INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;   
	
	SELECT *
	FROM h3giEmailTemplate
	WHERE emailId = @emailId
END


GRANT EXECUTE ON h3giGetEmailTemplateById TO b4nuser
GO
