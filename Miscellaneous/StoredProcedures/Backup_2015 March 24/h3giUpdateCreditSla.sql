

CREATE PROCEDURE [dbo].[h3giUpdateCreditSla]
	@retail VARCHAR(5),
	@noneRetail VARCHAR(5)
AS
BEGIN
	UPDATE config
	SET idValue = @retail
	WHERE idName = 'retailCreditSlaTime'

	UPDATE config
	SET idValue = @noneRetail
	WHERE idName = 'directCreditSlaTime'
END



GRANT EXECUTE ON h3giUpdateCreditSla TO b4nuser
GO
