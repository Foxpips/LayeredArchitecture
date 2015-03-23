

-- ===========================================================================
-- Author:		Stephen Mooney	
-- Create date: 05/01/11
-- Description:	Stores the proof data in the 
--				threeCustomerProof table
--              Duplicate of h3giStoreCustomerProof
--
-- Change Log:	06/09/2012 - Simon Markey - Takes in additional paramater 
--						     'Other Proof of Identity'
-- ==========================================================================
CREATE PROCEDURE [dbo].[threeStoreCustomerProof] 
	@orderRef INT,
	@type VARCHAR(50),
	@proof VARCHAR(50),
	@uniqueProofDesc VARCHAR(50),
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

    INSERT INTO threeCustomerProof
	VALUES
	(
		@orderRef,
		@proofTypeId,
		@type,
		'ProofCountry',
		@countryCode,
		@idNumber,
		@countryName,
		@uniqueProofDesc
	)

END

GRANT EXECUTE ON threeStoreCustomerProof TO b4nuser
GO
