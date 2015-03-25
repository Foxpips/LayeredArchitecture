

-- =============================================
-- Author:		Stephen Mooney	
-- Create date: 03/03/11
-- Description:	Stores the proof data in the 
--				[h3giUpdateCustomerProof] table
-- =============================================
CREATE PROCEDURE [dbo].[h3giUpdateCustomerProof] 
	@orderRef INT,
	@type VARCHAR(50),
	@proof VARCHAR(50),
	@countryCode VARCHAR(50),
	@idNumber VARCHAR(50),
	@countryName VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE	@proofTypeId INT
	
	SELECT @proofTypeId = proofTypeId
	FROM h3giProofType
	WHERE type = @type
	AND proof = @proof

    UPDATE h3giCustomerProof
    SET proofTypeId = @proofTypeId,
		classSysId = 'ProofCountry',
		classCode = @countryCode,
		idNumber = @idNumber,
		countryName = @countryName
    WHERE orderRef = @orderRef
    AND type = @type
END


GRANT EXECUTE ON h3giUpdateCustomerProof TO b4nuser
GO
