-- =============================================
-- Author:	Simon Markey	
-- Create date: 2014 Feb 10
-- Description:	Script out all sproc permissions
-- =============================================
CREATE PROCEDURE [dbo].b4nScriptProcPermissions
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
SELECT
	p.state_desc AS permission_state_desc,
	p.permission_name,
	'ON',
	o.NAME AS object_name,
	'TO',
	dp.NAME AS principal_name    
    FROM sys.procedures o
        INNER JOIN sys.database_permissions p 
			ON o.OBJECT_ID= p.major_id
        LEFT OUTER JOIN sys.database_principals dp
			ON p.grantee_principal_id = dp.principal_id
		order by object_name desc
END
