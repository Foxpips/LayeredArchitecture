
-- =============================================
-- Author:		Stephen Quin
-- Create date: 22/01/09
-- Description:	Returns a proofTypeId for a 
--				specific proof
--
-- Change Log:	11/07/2012
-- Author:		Simon Markey
-- Description:	Returns proofTypeId based on orderref
--				instead of proof name
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetProofTypeId] 
	@orderRef VARCHAR(50),
	@type VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT proofTypeId
	FROM h3giCustomerProof
	WHERE orderref = @orderRef
	AND	type = @type

END



GRANT EXECUTE ON h3giGetProofTypeId TO b4nuser
GO
