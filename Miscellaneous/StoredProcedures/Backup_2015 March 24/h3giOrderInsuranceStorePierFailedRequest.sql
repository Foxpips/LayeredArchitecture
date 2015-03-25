

-- =========================================================
-- Author:		Stephen Quin
-- Create date: 22/08/2013
-- Description:	Stores the details of a failed pier request
-- =========================================================
CREATE PROCEDURE [dbo].[h3giOrderInsuranceStorePierFailedRequest] 
	@orderRef INT,
	@dateSubmitted DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @orderInsuranceId INT
    SELECT @orderInsuranceId = id FROM h3giOrderInsurance WHERE orderRef = @orderRef
    
    INSERT INTO h3giOrderInsurancePierFailedRequest 
    (
		orderInsuranceId, 		
		dateSubmitted
	)
    VALUES 
    (
		@orderInsuranceId,		
		@dateSubmitted
    )
    
END


GRANT EXECUTE ON h3giOrderInsuranceStorePierFailedRequest TO b4nuser
GO
