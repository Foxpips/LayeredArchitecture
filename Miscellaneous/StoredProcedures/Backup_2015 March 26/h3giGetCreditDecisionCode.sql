

CREATE PROCEDURE [dbo].[h3giGetCreditDecisionCode]
(
	@orderRef INT
)

AS

BEGIN
	SELECT decisionCode
	FROM h3giOrderheader WITH(NOLOCK)
	WHERE orderref = @orderRef
END





GRANT EXECUTE ON h3giGetCreditDecisionCode TO b4nuser
GO
