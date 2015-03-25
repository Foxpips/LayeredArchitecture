
CREATE PROC [dbo].[b4nClassCodesIsExists]
(
	@b4nClassSysID NVARCHAR(50),
	@b4nClassCode NVARCHAR(2)
)

AS


BEGIN

IF EXISTS
	(
	SELECT * 
	FROM b4nClassCodes codes
	WHERE codes.b4nClassSysID = @b4nClassSysID
	AND codes.b4nClassCode = @b4nClassCode
	)
	 RETURN 1
ELSE
	RETURN 0	 


END



GRANT EXECUTE ON b4nClassCodesIsExists TO b4nuser
GO
