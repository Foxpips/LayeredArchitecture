
CREATE PROCEDURE [dbo].[smGetUserDetails]
@applicationId INT=0,
@userId INT=0
AS
BEGIN



SELECT u.applicationId,
u.userId,
u.roleId,
u.userName,
u.password,
u.createDate,
u.modifyDate,
u.loginDate,
u.lastActivity,
u.gen1,
u.gen2,
u.gen3,
u.gen4,
u.gen5,
u.gen6,
u.gen7,
u.gen8,
u.gen9,
u.gen10,
u.gen11,
u.gen12,
u.gen13,
u.gen14,
u.gen15,
u.nameOfUser,
a.applicationName,
a.applicationTimeout,
r.roleName,
rs.storename,
rt.retailername,
u.team
FROM smapplication a WITH(NOLOCK)
 JOIN smApplicationUsers u ON u.applicationId = a.applicationId
JOIN smRole r ON r.roleId = u.roleId
LEFT JOIN h3giRetailerStore rs ON u.gen2 = rs.storecode
LEFT JOIN h3giRetailer rt ON u.gen1 = rt.retailercode

WHERE a.applicationId = @applicationID
AND u.userId = @userId

END

GRANT EXECUTE ON smGetUserDetails TO b4nuser
GO
GRANT EXECUTE ON smGetUserDetails TO ofsuser
GO
GRANT EXECUTE ON smGetUserDetails TO reportuser
GO
