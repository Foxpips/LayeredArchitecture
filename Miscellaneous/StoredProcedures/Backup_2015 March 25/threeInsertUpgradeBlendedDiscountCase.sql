
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 07/05/2013
-- Description:	Inserts a record into threeUpgradeBlendedDiscountCase table.
-- =============================================
CREATE PROCEDURE [dbo].[threeInsertUpgradeBlendedDiscountCase]
(
	@id					INT OUT,
	@companyName		NVARCHAR(100),
	@parentBan			NVARCHAR(10),
	@createdDate		DATETIME,
	@decisionDate		DATETIME,
	@userSubmitted		VARCHAR(50),
	@userProcessed		VARCHAR(50),
	@status				INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[threeUpgradeBlendedDiscountCase]
           ([companyName]
           ,[parentBan]
		   ,[createdDate]
		   ,[decisionDate]
		   ,[userSubmitted]
		   ,[userProcessed]
		   ,[status]
			)
     VALUES
           (
			@companyName,
			@parentBan,
			@createdDate,
			@decisionDate,
			@userSubmitted,
			@userProcessed,
			@status
           )
    SELECT @id = SCOPE_IDENTITY()
END

GRANT EXECUTE ON threeInsertUpgradeBlendedDiscountCase TO b4nuser
GO
