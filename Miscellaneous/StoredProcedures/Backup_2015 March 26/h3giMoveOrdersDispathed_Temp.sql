

-- =========================================================================================
-- Author:		Stephen Quin
-- Create date: 05/07/2012
-- Description:	Moves orders from gmOrdersDispatched_temp into the gmOrdersDispatched_error 
--				table. That way we should never lose any orders in the case of an error and 
--				orders can be easily moved out of this table and back into the
--				gmOrdersDispatched table for retry
-- Changes:		30/05/2013	-	Stephen Quin	-	added new parameter @isBusiness and better
--													error handling
-- =========================================================================================
CREATE PROCEDURE [dbo].[h3giMoveOrdersDispathed_Temp]
	@prepay INT,
	@isBusiness BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRANSACTION move_delete
	
	BEGIN TRY	
	
		IF @isBusiness = 0
		BEGIN
		
			INSERT INTO gmOrdersDispatched_error
			SELECT gmt.orderRef, gmt.prepay, GETDATE()
			FROM gmOrdersDispatched_Temp gmt WITH(TABLOCK) 
			INNER JOIN h3giOrderheader h3gi WITH(NOLOCK)
				ON gmt.orderref = h3gi.orderref
			WHERE gmt.prepay = @prepay
			
			DELETE gmt 
			FROM	gmOrdersDispatched_Temp gmt
			INNER JOIN h3giOrderheader head WITH(NOLOCK)
				ON gmt.orderref = head.orderref
			WHERE gmt.prepay = @prepay
			
		END
		ELSE
		BEGIN
			INSERT INTO gmOrdersDispatched_error
			SELECT gmt.orderRef, gmt.prepay, GETDATE()
			FROM gmOrdersDispatched_Temp gmt WITH(TABLOCK) 
			INNER JOIN threeOrderUpgradeHeader upg WITH(NOLOCK)
				ON gmt.orderref = upg.orderref
			WHERE gmt.prepay = @prepay
			
			DELETE gmt
			FROM gmOrdersDispatched_Temp gmt
			INNER JOIN threeOrderUpgradeHeader head WITH(NOLOCK)
				ON gmt.orderref = head.orderRef
			WHERE gmt.prepay = @prepay
				
		END
		
		COMMIT TRANSACTION move_delete		
    END TRY
    BEGIN CATCH
		DECLARE	@ErrorNumber    INT,
		@ErrorMessage   NVARCHAR(4000),
		@ErrorProcedure NVARCHAR(4000),
		@ErrorLine      INT
		
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorMessage = ERROR_MESSAGE()
		SET @ErrorProcedure = ERROR_PROCEDURE()
		SET @ErrorLine = ERROR_LINE()

		RAISERROR ('An error occurred within a user transaction. 
		  Error Number        : %d
		  Error Message       : %s  
		  Affected Procedure  : %s
		  Affected Line Number: %d'
		  , 16, 1
		  , @ErrorNumber, @ErrorMessage, @ErrorProcedure,@ErrorLine)

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION move_delete
    END CATCH
    
END


GRANT EXECUTE ON h3giMoveOrdersDispathed_Temp TO b4nuser
GO
