

CREATE PROCEDURE [dbo].[h3giGetCreditSla]

AS
BEGIN
	SELECT idValue FROM config
	WHERE idName = 'retailCreditSlaTime'

	SELECT idValue FROM config
	WHERE idName = 'directCreditSlaTime'
END



GRANT EXECUTE ON h3giGetCreditSla TO b4nuser
GO
