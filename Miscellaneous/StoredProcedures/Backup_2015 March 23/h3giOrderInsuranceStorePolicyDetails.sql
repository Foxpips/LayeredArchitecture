


-- ===============================================================
-- Author:		Stephen Quin
-- Create date: 25/07/13
-- Description:	Stores the policy details for an insurance package
-- ===============================================================
CREATE PROCEDURE [dbo].[h3giOrderInsuranceStorePolicyDetails] 
	@orderRef INT,
	@insuranceId INT,
	@customerId INT,
	@paymentMethod VARCHAR(10),
	@paymentType VARCHAR(15),
	@paymentFreqId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    INSERT INTO h3giOrderInsurance
    (
		orderRef,
		insuranceId,
		customerId,
		paymentMethod,
		paymentType,
		paymentFreqId
    )
    VALUES
    (
		@orderRef,
		@insuranceId,
		@customerId,
		@paymentMethod,
		@paymentType,
		@paymentFreqId
    )  
END



GRANT EXECUTE ON h3giOrderInsuranceStorePolicyDetails TO b4nuser
GO
