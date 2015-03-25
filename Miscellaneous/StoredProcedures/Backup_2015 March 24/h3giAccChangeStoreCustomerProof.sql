


-- =============================================
-- Author:		Stephen Mooney 
-- Create date: 04/04/11
-- Description:	Stores the proof data in the 
--				h3giAccChangeCustomerProof table
-- S Mooney : 22 Oct 2012 : Added @typeAlternative
-- =============================================
CREATE PROCEDURE [dbo].[h3giAccChangeStoreCustomerProof] 
	@orderRef INT,
	@type VARCHAR(50),
	@proof VARCHAR(50),
	@countryCode VARCHAR(50),
	@idNumber VARCHAR(50),
	@countryName VARCHAR(50),
	@typeAlternative VARCHAR(30) = ''
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

IF(@proofTypeId is null)
BEGIN
	SELECT @proofTypeId =-1
	SELECT @idNumber = -1
END

IF(@proofTypeId = '')BEGIN
SELECT @proofTypeId ='N/A'
SELECT @idNumber = '0'
END

    INSERT INTO h3giAccChangeCustomerProof
	VALUES
	(
		@orderRef,
		@proofTypeId,
		@type,
		'ProofCountry',
		@countryCode,
		@idNumber,
		@countryName,
		@typeAlternative
	)
	
	update h3giAccChangeCustomerProof
	set proofTypeId = ''
	where proofTypeId = -1

END


GRANT EXECUTE ON h3giAccChangeStoreCustomerProof TO b4nuser
GO
