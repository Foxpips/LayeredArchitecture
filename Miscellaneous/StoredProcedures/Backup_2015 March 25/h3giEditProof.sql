

  
-- =============================================  
-- Author:  John O'Sullivan  
-- Create date: 19/01/09  
-- Description: Edits a proof  
  
-- Change Control  
-- =============================================  
  
CREATE PROCEDURE [dbo].[h3giEditProof]  
 @existingProofTypeId INT,  
 @newProofTypeId INT,  
 @type VARCHAR(50),  
 @proof VARCHAR(50),  
 @proofCountries NTEXT,  
 @shouldBeRecent BIT,
 @availableFor NVARCHAR(20)
AS  
BEGIN  
 SET NOCOUNT ON  
 --right - we allow users to change the proofTypeId. However this is a FK on the h3giProofCountry table  
 --so - first thing I do is remove all proof countries associated with this proof type (if any)  
 --then update the proof type table (changing the pk for the record if required)  
 --then I recreate the list of proof countries associated with this proof  
 BEGIN TRAN  
   
 DECLARE @error INT  
   
 IF(@type = 'Identity')  
 BEGIN  
  DELETE FROM   
   h3giProofCountry  
  WHERE  
   proofTypeId = @existingProofTypeId AND  
   TYPE = @type  
     
  IF(@@ERROR != 0)  
  BEGIN  
   SET @error = -1  
   GOTO HANDLE_ERROR  
  END  
 END  
    
 UPDATE  
  h3giProofType  
 SET  
  proofTypeId = @newProofTypeId,  
  proof = @proof,  
  shouldBeRecent = @shouldBeRecent,
  availableFor = @availableFor
 WHERE  
  proofTypeId = @existingProofTypeId AND  
  TYPE = @type  
   
 IF(@@ERROR != 0)  
 BEGIN  
  SET @error = -2  
  GOTO HANDLE_ERROR  
 END  
   
 IF(@type = 'Identity')  
 BEGIN  
  DECLARE @XMLHandler INT  
  EXEC sp_xml_preparedocument @XMLHandler OUTPUT, @proofCountries  
    
  IF(@@ERROR != 0)  
  BEGIN  
   SET @error = -3  
   GOTO HANDLE_ERROR  
  END  
     
  INSERT INTO  
   h3giProofCountry (proofTypeId, TYPE, classSysId, classCode, priority)  
  SELECT  
   @newProofTypeId AS proofTypeId,  
   @type AS TYPE,  
   'ProofCountry' AS classSysId,  
   Code AS classCode,  
   Priority AS priority  
  FROM  
   OPENXML(@XMLHandler, '/Countries/Country')  
  WITH   
  (  
   ProofCountryId INT,  
   Priority INT,  
   VALUE VARCHAR(50),  
   Code VARCHAR(50)  
  )  
    
  IF(@@ERROR != 0)  
  BEGIN  
   SET @error = -4  
   GOTO HANDLE_ERROR  
  END  
    
  EXEC sp_xml_removedocument @XMLHandler  
    
  IF(@@ERROR != 0)  
  BEGIN  
   SET @error = -5  
   GOTO HANDLE_ERROR  
  END 
  
  IF(@existingProofTypeId != @newProofTypeId)
  BEGIN
	UPDATE
		dbo.h3giCustomerProof
	SET
		proofTypeId = @newProofTypeId
	WHERE
		proofTypeId = @existingProofTypeId
  END

 END  
   
 COMMIT TRAN  
 RETURN 0  
   
HANDLE_ERROR:  
 ROLLBACK TRAN  
 RETURN @error  
END 



GRANT EXECUTE ON h3giEditProof TO b4nuser
GO
