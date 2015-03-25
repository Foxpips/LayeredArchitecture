-- =============================================
-- Author:		Attila Pall
-- Create date: 22/10/2007
-- Description:	Saves the values of a credit decision to the order
-- =============================================
CREATE PROCEDURE [dbo].[threeBusinessOrderCreditDecisionSet] 
	-- Add the parameters for the stored procedure here
	@orderRef int,
	@creditAnalystId int,
	@creditCheckReference varchar(20),
	@decisionCode varchar(20),
	@decisionDescription varchar(20),
	@reasonCode varchar(20),
	@reasonDescription varchar(255),
	@creditScore int,
	@creditLimit int,
	@shadowCreditLimit int,
	@maximumUserCount int
AS
BEGIN
	UPDATE threeOrderHeader
	SET	creditAnalystID = @creditAnalystId,
		creditCheckReference = @creditCheckReference,
		decisionCode = @decisionCode,
		decisionDescription = @decisionDescription,
		reasonCode = @reasonCode,
		reasonDescription = @reasonDescription,
		creditScore = @creditScore,
		creditLimit = @creditLimit,
		shadowCreditLimit = @shadowCreditLimit,
		maximumEndUserCount = @maximumUserCount
	WHERE OrderRef = @orderRef
END


GRANT EXECUTE ON threeBusinessOrderCreditDecisionSet TO b4nuser
GO
GRANT EXECUTE ON threeBusinessOrderCreditDecisionSet TO reportuser
GO
