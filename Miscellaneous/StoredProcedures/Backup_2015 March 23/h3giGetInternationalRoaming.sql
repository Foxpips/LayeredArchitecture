-- =============================================
-- Author:		Stephen Quin
-- Create date: 07/04/2009
-- Description:	Gets the international romaing
--				value associated with the
--				orderRef passed as a paramter
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetInternationalRoaming] 
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT	internationalRoaming
	FROM	h3giOrderHeader
	WHERE	orderRef = @orderRef
END

GRANT EXECUTE ON h3giGetInternationalRoaming TO b4nuser
GO
