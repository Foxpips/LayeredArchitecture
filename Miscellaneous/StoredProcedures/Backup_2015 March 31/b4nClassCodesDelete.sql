

CREATE PROCEDURE [dbo].[b4nClassCodesDelete]
(
	@b4nClassSysID varchar(50),
	@b4nClassCode varchar(50)
)
AS
	SET NOCOUNT ON

	DELETE 
	FROM   [b4nClassCodes]
	WHERE  
		[b4nClassSysID] = @b4nClassSysID AND
		[b4nClassCode] = @b4nClassCode

	RETURN @@Error


GRANT EXECUTE ON b4nClassCodesDelete TO b4nuser
GO
