


-- ========================================================
-- Author:		Stephen Quin
-- Create date: 21/08/2013
-- Description:	Stores the case details returned from Pier
-- ========================================================
CREATE PROCEDURE [dbo].[h3giOrderInsuranceStorePierCase]
	@orderRef INT,
	@pierCaseId INT,
	@createdDate DATETIME,
	@daysInterm	INT,
	@renewalDate DATETIME,
	@inceptionDate DATETIME,
	@dayOfDebit varchar(20) = NULL,
    @dateOfCollection DATETIME = NULL,
    @mandateRef varchar(100) = NULL,
	@clientId INT
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @orderInsuranceId INT
	
	SELECT @orderInsuranceId = id
	FROM	h3giOrderInsurance
	WHERE orderRef = @orderRef

    INSERT INTO h3giOrderInsurancePierCase 
	(	
		orderInsuranceId,
		pierCaseId,
		createdDate,
		daysInterm,
		renewalDate,
		inceptionDate,
		dayOfDebit,
		dateOfCollection,
		mandateRef,
		clientId
	)
    VALUES
    (
		@orderInsuranceId,
		@pierCaseId,
		@createdDate,
		@daysInterm,
		@renewalDate,
		@inceptionDate,
		@dayOfDebit,
		@dateOfCollection,
		@mandateRef,
		@clientId
    )
    
END



GRANT EXECUTE ON h3giOrderInsuranceStorePierCase TO b4nuser
GO
