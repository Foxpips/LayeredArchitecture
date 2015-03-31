

CREATE  PROCEDURE [dbo].[smListActiveCreditUsers]

AS
BEGIN

DECLARE @creditRole INT
SELECT @creditRole = roleID FROM smRole
WHERE roleName IN ('Credit/Fraud Analyst')

DECLARE @bcreditRole INT
SELECT @bcreditRole = roleID FROM smRole
WHERE roleName IN ('Business Credit Analyst')

DECLARE @ipAdministratorRole INT
SELECT @ipAdministratorRole = roleID FROM smRole
WHERE roleName IN ('IP Administrator')

SELECT	users.userId AS userId,
		users.userName AS login,
		users.nameOfUser AS nameOfUser,
		role.roleName AS securityRole,
		users.createDate AS createDate,
		users.loginDate AS lastLoginDate

FROM smApplicationUsers users
JOIN smRole role
	ON role.roleId = users.roleId
WHERE users.active = 'Y'
AND users.applicationId = 1
AND users.roleId IN (@creditRole, @bcreditRole, @ipAdministratorRole)
ORDER BY users.userName

END


GRANT EXECUTE ON smListActiveCreditUsers TO b4nuser
GO
