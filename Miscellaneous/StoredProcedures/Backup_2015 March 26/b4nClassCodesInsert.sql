

CREATE PROCEDURE [dbo].[b4nClassCodesInsert]
(
	@b4nClassSysID varchar(50),
	@b4nClassCode varchar(50),
	@b4nClassDesc varchar(250) = NULL,
	@b4nValid char(1) = NULL,
	@b4nClassExplain varchar(1000) = NULL
)
AS
	SET NOCOUNT ON

	INSERT INTO [b4nClassCodes]
	(
		[b4nClassSysID],
		[b4nClassCode],
		[b4nClassDesc],
		[b4nValid],
		[b4nClassExplain]
	)
	VALUES
	(
		@b4nClassSysID,
		@b4nClassCode,
		@b4nClassDesc,
		@b4nValid,
		@b4nClassExplain
	)

	RETURN @@Error


GRANT EXECUTE ON b4nClassCodesInsert TO b4nuser
GO
