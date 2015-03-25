
CREATE PROC [dbo].[h3giProductFeaturesSet]
@peopleSoftId VARCHAR(50),
@featuresList dbo.h3giAddFeaturesType READONLY  

AS
BEGIN

DELETE FROM h3giDeviceFormHandsetLink 
  WHERE handsetPeopleSoftId = @peopleSoftId

INSERT INTO h3giDeviceFormHandsetLink 
  SELECT formId,@peopleSoftId 
  FROM @featuresList

END

GRANT EXECUTE ON h3giProductFeaturesSet TO b4nuser
GO
