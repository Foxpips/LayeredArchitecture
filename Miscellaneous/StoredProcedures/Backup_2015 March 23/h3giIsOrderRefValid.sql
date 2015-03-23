
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[h3giIsOrderRefValid]
(
	@OrderRef INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT orderref FROM h3giOrderheader WHERE orderref = @OrderRef)
	BEGIN
		SELECT 1;
	END
	ELSE
	BEGIN
		SELECT 0;
	END
END


GRANT EXECUTE ON h3giIsOrderRefValid TO b4nuser
GO
