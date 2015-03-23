
CREATE PROC [dbo].[h3giProductFeaturesGet]

AS
BEGIN

DECLARE @temp TABLE(
name VARCHAR(50),
formid VARCHAR(50)
)

INSERT INTO @temp 
  SELECT name,formId 
  FROM h3giDeviceForm 
  WHERE enabled = 1


SELECT name,formid 
FROM @temp

END

GRANT EXECUTE ON h3giProductFeaturesGet TO b4nuser
GO
