
-- =============================================
-- Author:		Stephen Quin
-- Create date: 18/10/2010
-- Description:	Updates an already existing
--				deposit that exists against
--				an order
-- =============================================
CREATE PROCEDURE [dbo].[h3giDepositUpdate]
	@orderRef int,   
	@amount float  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE h3giOrderDeposit
    SET depositAmount = @amount
    WHERE orderRef = @orderRef
    
END


GRANT EXECUTE ON h3giDepositUpdate TO b4nuser
GO
