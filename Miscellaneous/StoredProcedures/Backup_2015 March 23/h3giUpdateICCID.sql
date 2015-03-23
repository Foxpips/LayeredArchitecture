
-- ==============================================================
-- Author:		Sorin Oboroceanu
-- Create date: 18/07/2014
-- Description:	Updated the ICCID of an order.
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giUpdateICCID]
(
  @OrderRef INT,
  @ICCID 	VARCHAR(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;    
    
	UPDATE  h3giOrderHeader
	SET ICCID = @ICCID 
	WHERE orderRef = @OrderRef
END
GRANT EXECUTE ON h3giUpdateICCID TO b4nuser
GO
