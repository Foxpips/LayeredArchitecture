
-- =============================================
-- Author:		Stephen Quin
-- Create date: 29/06/2011
-- Description:	Creates an entry in the Linked
--				Orders table
-- =============================================
CREATE PROCEDURE [dbo].[h3giAddLinkedOrder]
	@linkedOrderRef INT,
	@orderRef INT,
	@newLinkedOrderRef INT = 0 OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
	
		INSERT INTO h3giLinkedOrders (linkedOrderRef, orderRef)
		VALUES (@linkedOrderRef, @orderRef)
		
		IF(@linkedOrderRef <= 0)
		BEGIN
			UPDATE h3giLinkedOrders
			SET linkedOrderRef = linkedId
			WHERE orderRef = @orderRef
		END
			
		SELECT @newLinkedOrderRef = linkedOrderRef
		FROM h3giLinkedOrders 
		WHERE orderRef = @orderRef
		
	END TRY
	
	BEGIN CATCH
	
		RETURN -1
		
	END CATCH
END


GRANT EXECUTE ON h3giAddLinkedOrder TO b4nuser
GO
