
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 17-Jan-2013
-- Description:	Updates a certain e-mail template.
-- =============================================
CREATE PROCEDURE [dbo].[h3giUpdateEmailTemplate]
(
	@emailId int,
	@emailDescription varchar(1024),
	@emailFrom varchar(1024),
	@emailCC varchar(1024),
	@emailBCC varchar(1024),
	@emailSubject varchar(1024),
	@emailContent ntext,
	@ModifiedDate datetime,
	@ModifiedBy nvarchar(255)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;   
	
	UPDATE 	h3giEmailTemplate
	SET 	emailDescription = @emailDescription,
			emailFrom = @emailFrom,
			emailCC = @emailCC,
			emailBCC = @emailBCC,
			emailSubject = @emailSubject,
			emailContent = @emailContent,
			ModifiedDate = @ModifiedDate,
			ModifiedBy = @ModifiedBy
	WHERE 	emailId = @emailId
END


GRANT EXECUTE ON h3giUpdateEmailTemplate TO b4nuser
GO
