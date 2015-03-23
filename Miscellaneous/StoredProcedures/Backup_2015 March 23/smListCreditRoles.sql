


CREATE PROCEDURE [dbo].[smListCreditRoles]

AS
BEGIN

SELECT a.applicationId,r.roleId,r.roleName,r.createDate,r.modifyDate
FROM smApplicationRoles a WITH(NOLOCK) 
	JOIN smRole r WITH(NOLOCK)
	ON a.roleId = r.roleId
WHERE a.applicationId = 1
AND r.roleName IN ('Credit/Fraud Analyst','Business Credit Analyst','IP Administrator')

END



GRANT EXECUTE ON smListCreditRoles TO b4nuser
GO
