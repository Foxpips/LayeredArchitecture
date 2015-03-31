
CREATE PROC [dbo].[h3giFeaturesAdd]
@name VARCHAR(50),
@imageName VARCHAR(50)
AS
BEGIN

INSERT INTO h3giDeviceForm
VALUES(@name,@imageName,1,1)

END

GRANT EXECUTE ON h3giFeaturesAdd TO b4nuser
GO
