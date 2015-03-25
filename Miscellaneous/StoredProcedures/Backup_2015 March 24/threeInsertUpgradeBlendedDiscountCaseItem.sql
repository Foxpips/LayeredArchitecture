
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 03/05/2013
-- Description:	Inserts a record into threeUpgradeBlendedDiscountCaseItem table.
-- =============================================
CREATE PROCEDURE [dbo].[threeInsertUpgradeBlendedDiscountCaseItem]
(
	@id					INT OUT,
	@caseId				INT,
	@endUserBan			NVARCHAR(10),
	@incomingBand		NVARCHAR(10),
	@potentialNewBand	VARCHAR(10)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[threeUpgradeBlendedDiscountCaseItem]
           ([caseId]
		   ,[endUserBan]
           ,[incomingBand]
           ,[potentialNewBand]
			)
     VALUES
           (
			@caseId,
			@endUserBan,
			@incomingBand,
			@potentialNewBand
           )
    SELECT @id = SCOPE_IDENTITY()
END

GRANT EXECUTE ON threeInsertUpgradeBlendedDiscountCaseItem TO b4nuser
GO
