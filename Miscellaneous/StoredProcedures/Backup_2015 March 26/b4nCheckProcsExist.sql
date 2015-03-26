CREATE PROC [dbo].[b4nCheckProcsExist]  
AS  
BEGIN  
	SELECT * 
	FROM sys.procedures procs
	WHERE SCHEMA_ID = 1
	AND procs.is_ms_shipped = 0
	AND procs.name not like 'sp_%'
	END
GRANT EXECUTE ON b4nCheckProcsExist TO b4nuser
GO
