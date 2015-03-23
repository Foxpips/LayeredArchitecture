


-- =============================================  
-- Author:  John O'Sullivan  
-- Create date: 19/01/09  
-- Description: Adds a proof  
  
-- Change Control  
-- =============================================  
  
CREATE PROCEDURE [dbo].[h3giAddProof]  
 @newProofTypeId  INT,  
 @type VARCHAR(50),  
 @proof VARCHAR(50),  
 @proofCountries NTEXT,  
 @shouldBeRecent BIT,
 @availableFor NVARCHAR(20)
AS  
BEGIN  
 SET NOCOUNT ON  
 BEGIN TRAN  
   
 DECLARE @error INT  
   
 INSERT INTO  
  h3giProofType (proofTypeId, TYPE, proof, shouldBeRecent, isActive, availableFor)   
 VALUES  
  (@newProofTypeId, @type, @proof, @shouldBeRecent, 1, @availableFor)  
   
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
 
 END  
   
 COMMIT TRAN  
 RETURN 0  
   
HANDLE_ERROR:  
 ROLLBACK TRAN  
 RETURN @error  
END 



GRANT EXECUTE ON h3giAddProof TO b4nuser
GO
