

-- ================================================================================================
-- Author:		Stephen Quin	
-- Create date: 21/01/09
-- Description:	Stores the proof data in the 
--				h3giCustomerProof table
--
-- Change Log:	06/09/2010 - Simon Markey - Takes in additional paramater 'Other Proof of Identity'
-- Change Log:  13/03/2013 - Sorin Oboroceanu - Added new checksum related fields.
-- ================================================================================================
CREATE PROCEDURE [dbo].[h3giStoreCustomerProof] 
	@orderRef INT,
	@type VARCHAR(50),
	@proof VARCHAR(50),
	@uniqueProofDesc VARCHAR(30),
	@countryCode VARCHAR(50),
	@idNumber VARCHAR(50),
	@countryName VARCHAR(50),
	@checksumNumber NVARCHAR(1),
	@checksumCorrect BIT,
	@checksumFailedMoreThanThreeTimes BIT
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

    INSERT INTO h3giCustomerProof
    (
		orderRef,
		proofTypeId,
		type,
		classSysId,
		classCode,
		idNumber,
		countryName,
		uniqueProofDescription,
		checksumNumber,
		checksumCorrect,
		checksumFailedMoreThanThreeTimes
    )
	VALUES
	(
		@orderRef,
		@proofTypeId,
		@type,
		'ProofCountry',
		@countryCode,
		@idNumber,
		@countryName,
		@uniqueProofDesc,
		@checksumNumber,
		@checksumCorrect,
		@checksumFailedMoreThanThreeTimes
	)

END





GRANT EXECUTE ON h3giStoreCustomerProof TO b4nuser
GO
