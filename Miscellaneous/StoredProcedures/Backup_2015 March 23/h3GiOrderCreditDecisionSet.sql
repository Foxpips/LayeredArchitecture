-- =============================================
-- Author:		Attila Pall
-- Create date: 28/08/2007
-- Description:	Saves the values of a credit decision to the order
-- =============================================
CREATE PROCEDURE [dbo].[h3GiOrderCreditDecisionSet] 
	-- Add the parameters for the stored procedure here
	@orderRef int,
	@creditAnalystId int,
	@creditCheckReference varchar(20),
	@decisionCode varchar(20),
	@decisionDescription varchar(20),
	@creditScore int,
	@creditLimit int,
	@shadowCreditLimit int,
	@roaming bit = 0
AS
BEGIN
	UPDATE h3giOrderHeader
	SET	creditAnalystID = @creditAnalystId,
		experianRef = @creditCheckReference,
		decisionCode = @decisionCode,
		decisionTextCode = @decisionDescription,
		score = @creditScore,
		creditLimit = @creditLimit,
		shadowCreditLimit = @shadowCreditLimit,
		internationalRoaming = CASE @roaming WHEN 1 THEN 'Y' ELSE 'N' END
	WHERE OrderRef = @orderRef
END


GRANT EXECUTE ON h3GiOrderCreditDecisionSet TO b4nuser
GO
GRANT EXECUTE ON h3GiOrderCreditDecisionSet TO ofsuser
GO
GRANT EXECUTE ON h3GiOrderCreditDecisionSet TO reportuser
GO
