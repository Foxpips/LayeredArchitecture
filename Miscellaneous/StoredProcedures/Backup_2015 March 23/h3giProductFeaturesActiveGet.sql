

CREATE PROC [dbo].[h3giProductFeaturesActiveGet]
@peopleSoftId AS VARCHAR(50)


AS
BEGIN

DECLARE @temp TABLE(
formid VARCHAR(50)
)

INSERT INTO @temp
  SELECT link.formId 
  FROM h3giDeviceFormHandsetLink link 
  WHERE link.handsetPeopleSoftId = @peopleSoftId

SELECT formid 
FROM @temp

END

GRANT EXECUTE ON h3giProductFeaturesActiveGet TO b4nuser
GO
