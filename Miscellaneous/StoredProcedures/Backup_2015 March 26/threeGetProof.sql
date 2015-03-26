
/*********************************************************************************************************************  
**                       
** Procedure Name : threeGetProof  
** Author   :    
** Date Created  :   
**       
**********************************************************************************************************************  
**      
** Description  : Retrieves customer proof information  
**       
**********************************************************************************************************************  
**           
** Change Control : 11/03/2012 - Simon Markey - Added case to proofs to return manually entered proof  
**              'uniqueProofDescription' if option selected was 'Other'  
**              otherwise return regular drop down option  
**********************************************************************************************************************/  
  


CREATE PROC [dbo].[threeGetProof]
	@orderRef INT,
	@type VARCHAR(20)

AS
BEGIN
SELECT cp.orderRef,
	cp.proofTypeId,
	cp.type,
	cp.classSysId,
	cp.classCode,
	cp.idNumber,
	cp.countryName,
	CASE pt.proof   
		WHEN 'Other' THEN ISNULL(cp.uniqueProofDescription,'')  
		ELSE ISNULL(pt.proof,'')  
	END AS proof,
	cp.proofTypeId,
	pt.type,
	pt.proof,
	pt.shouldBeRecent,
	pt.isActive
	 FROM threeCustomerProof cp
		INNER JOIN h3giProofType pt
			ON cp.type = pt.type
			AND cp.proofTypeId = pt.proofTypeId
	WHERE cp.orderRef = @orderRef
		AND cp.type = @type
END

GRANT EXECUTE ON threeGetProof TO b4nuser
GO
