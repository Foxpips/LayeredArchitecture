


-- =================================================================================
-- Author:		Stephen Quin
-- Create date: 14/01/09
-- Description:	Returns all the proofs associated with a specific proof type
-- Change Control:	09/02/09  -  Stephen Quin  -  Added ORDER BY clause
-- Change Control:	30/09/14  -  Stephen King  -  Added countries select
-- Change Control:	24/10/14  -  Stephen Quin  -  Added new paramater @availableFor
-- =================================================================================
CREATE PROCEDURE [dbo].[h3giGetProofs]
	@proofType VARCHAR(50),
	@availableFor NVARCHAR(20) = NULL
AS
BEGIN
	SET NOCOUNT ON

    SELECT	proofTypeId,
			TYPE,
			proof,
			shouldBeRecent,
			isActive,
			availableFor
	FROM h3giProofType
	WHERE TYPE LIKE @proofType
	AND isActive = 1
	AND (@availableFor IS NULL OR availableFor IN (@availableFor,'All'))
	ORDER BY proof

        	
    SELECT	pc.proofCountryId,  
			pc.proofTypeId,
			pc.classCode,  
			cc.b4nClassDesc,  
			pc.priority  
    FROM	h3giProofCountry pc,  
			b4nClassCodes cc  
    WHERE	pc.classCode = cc.b4nClassCode 
    AND		cc.b4nClassSysID = pc.classSysId 
    AND  	pc.type = @proofType      

END



GRANT EXECUTE ON h3giGetProofs TO b4nuser
GO
