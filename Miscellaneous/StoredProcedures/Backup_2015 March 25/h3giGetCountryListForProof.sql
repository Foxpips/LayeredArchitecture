
-- ===================================================================================
-- Author:		Stephen Quin
-- Create date: 13/01/09
-- Description:	Gets a list of countries for a specific proof
-- Changes:		12/02/09  -  Stephen Quin  -  Now returns priority and proofCountryId
-- ===================================================================================
CREATE PROCEDURE [dbo].[h3giGetCountryListForProof] 
	@type VARCHAR(50),
	@proofTypeId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT countries.b4nClassDesc AS countryName,
		   countries.b4nClassCode AS countryCode,
		   proofCountry.priority,
		   proofCountry.proofCountryId
	FROM b4nClassCodes countries
	INNER JOIN h3giProofCountry proofCountry
		ON countries.b4nClassCode = proofCountry.classCode
		AND countries.b4nClassSysId = 'ProofCountry'
	INNER JOIN h3giProofType proofType
		ON proofCountry.proofTypeId = proofType.proofTypeId
		AND proofType.type = @type	
	WHERE proofType.proofTypeId = @proofTypeId
END

GRANT EXECUTE ON h3giGetCountryListForProof TO b4nuser
GO
