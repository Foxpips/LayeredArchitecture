

-- ===============================================
-- Author:		Gearóid Healy
-- Create date: 22/03/2012
-- Description: inserts a new row each time an attempt is made to update xml content
--				will invalidate the sql cache dependency if status is true
-- ===============================================
CREATE PROCEDURE [dbo].[h3giXmlContentDictionaryLogInsert]
	@UpdateStatus BIT,
	@UpdateNotes NVARCHAR(255)
AS
BEGIN

	DECLARE @CurrentDate DATETIME
	SELECT @CurrentDate = GETDATE()
	
	INSERT INTO [h3giXmlContentDictionaryLog] (updateTime, updateStatus, updateNotes)
	VALUES (@CurrentDate, @UpdateStatus, @UpdateNotes)


END


GRANT EXECUTE ON h3giXmlContentDictionaryLogInsert TO b4nuser
GO
