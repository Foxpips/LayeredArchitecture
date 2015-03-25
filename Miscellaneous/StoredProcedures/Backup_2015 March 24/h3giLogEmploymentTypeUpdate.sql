
-- =============================================
-- Author:		<Author: Simon Markey>
-- Create date: <Create Date: 08/08/2013>
-- Description:	<Description: log for employmentType table updates>
-- =============================================
CREATE PROCEDURE [dbo].[h3giLogEmploymentTypeUpdate]
	@userid INT,
	@action VARCHAR(20),
	@employmentType VARCHAR(100),
	@employmentTypeId VARCHAR(100),
	@date DATETIME
AS
BEGIN

DECLARE @userName VARCHAR(50)
DECLARE @detail VARCHAR(255)

SELECT @userName = nameOfUser FROM smApplicationUsers WHERE userId = @userid

IF(@action = 'delete')
 BEGIN
  SELECT @detail = @userName + ' ' + @action +'d' + ' occupation type: ' + @employmentType 
 END

ELSE
 BEGIN
  SELECT @detail = @userName + ' ' + @action +'ed' + ' occupation type: ' + @employmentType
 END


IF(@employmentTypeId = -1)
BEGIN
SELECT @employmentTypeId = employmentId FROM h3giEmploymentTypes WHERE EmploymentTitle = @employmentType 
END

INSERT INTO h3giEmploymentTypeLog([UserId],[ACTION],[employmentType],[employmentTypeId],[DATE],[Detail])
VALUES(@userid,@action,@employmentType,@employmentTypeId,@date,@detail)

END

GRANT EXECUTE ON h3giLogEmploymentTypeUpdate TO b4nuser
GO
