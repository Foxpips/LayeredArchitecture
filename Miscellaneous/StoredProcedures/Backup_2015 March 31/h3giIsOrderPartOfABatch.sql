
-- ==============================================================
-- Author:		Sorin Oboroceanu
-- Create date: 22/07/2014
-- Description:	
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giIsOrderPartOfABatch]
(
	@OrderRef	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	IF EXISTS (SELECT TOP 1 orderRef FROM h3giBatchOrder WHERE orderRef = @OrderRef)
		SELECT CAST(1 AS BIT)
	ELSE
		SELECT CAST(0 AS BIT)
END
GRANT EXECUTE ON h3giIsOrderPartOfABatch TO b4nuser
GO
