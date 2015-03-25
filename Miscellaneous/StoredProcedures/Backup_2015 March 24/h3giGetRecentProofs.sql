

-- ==============================================
-- Author:		Stephen Quin
-- Create date: 19/01/09
-- Description:	Returns all proofTypeIds for all
--				active proofs associated with the 
--				type parameter
-- ==============================================
CREATE PROCEDURE [dbo].[h3giGetRecentProofs] 
	@type VARChar(50),
	@availableFor NVARCHAR(20) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT proofTypeId, proof
	FROM h3giProofType
	WHERE shouldBeRecent = 1
		AND isActive = 1
		AND type = @type
		AND (@availableFor IS NULL OR availableFor IN (@availableFor,'All'))
END





GRANT EXECUTE ON h3giGetRecentProofs TO b4nuser
GO
