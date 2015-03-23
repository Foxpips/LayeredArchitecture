-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 29/09/2014
-- Description:	Checks whether an orderref corresponds to a Three order.
-- =============================================
CREATE PROCEDURE h3giIsThreeOrder
(
	@OrderRef INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS(SELECT TOP 1 orderRef FROM dbo.b4nOrderHeader WHERE OrderRef = @OrderRef)
		SELECT CAST(1 AS bit)
	ELSE
		SELECT CAST(0 AS bit)
END
