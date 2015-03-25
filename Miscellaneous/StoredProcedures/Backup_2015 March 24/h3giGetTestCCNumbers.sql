
-- ===============================================
-- Author:		Stephen Quin
-- Create date: 10/12/2009
-- Description:	Returns the valid test CC Numbers
-- ===============================================
CREATE PROCEDURE [dbo].[h3giGetTestCCNumbers]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT testCCNum
	FROM h3giTestCCNumbers
	WHERE isValid = 1
END


GRANT EXECUTE ON h3giGetTestCCNumbers TO b4nuser
GO
