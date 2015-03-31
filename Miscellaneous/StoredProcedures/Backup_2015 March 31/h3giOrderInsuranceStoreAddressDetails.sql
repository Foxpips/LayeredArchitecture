

-- ============================================================
-- Author:		Stephen Quin
-- Create date: 25/07/13
-- Description:	Stores address details for an insurance package
-- ============================================================
CREATE PROCEDURE [dbo].[h3giOrderInsuranceStoreAddressDetails]
	@customerId INT,
	@aptNumber VARCHAR(10),
	@houseNumber VARCHAR(10),
	@houseName VARCHAR(50),
	@street VARCHAR(50),
	@locality VARCHAR(50),
	@town VARCHAR(50),
	@county VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO h3giOrderInsuranceAddress
    (
		customerId,
		aptNumber,
		houseNumber,
		houseName,
		street,
		locality,
		town,
		county
    )
    VALUES
    (
		@customerId,
		@aptNumber,
		@houseNumber,
		@houseName,
		@street,
		@locality,
		@town,
		@county
    )
    
END


GRANT EXECUTE ON h3giOrderInsuranceStoreAddressDetails TO b4nuser
GO
