
CREATE PROC [dbo].[h3giFeaturesRemove]
@featuresList dbo.h3giAddFeaturesType READONLY  

AS
BEGIN

UPDATE h3giDeviceForm
  SET enabled = 0
  WHERE formId IN (SELECT formid FROM @featuresList)

END

GRANT EXECUTE ON h3giFeaturesRemove TO b4nuser
GO
