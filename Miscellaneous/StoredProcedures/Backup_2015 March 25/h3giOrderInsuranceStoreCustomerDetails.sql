

-- ==============================================================
-- Author:		Stephen Quin
-- Create date: 25/07/13
-- Description:	Stores customer details for an insurance package
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giOrderInsuranceStoreCustomerDetails]
	@title VARCHAR(50),
	@forename VARCHAR(50),
	@surname VARCHAR(50),
	@email VARCHAR(50),
	@primaryContactAreaCode VARCHAR(4),
	@primaryContactMain VARCHAR(10),
	@mobileNumberAreaCode VARCHAR(4),
	@mobileNumberMain VARCHAR(10),
	@customerId INT = 0 OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO h3giOrderInsuranceCustomer 
    (
		title, 
		forename, 
		surname, 
		email, 
		primaryContactAreaCode, 
		primaryContactMain, 
		mobileNumberAreaCode, 
		mobileNumberMain
	)
    VALUES
    (
		@title,
		@forename,
		@surname,
		@email,
		@primaryContactAreaCode,
		@primaryContactMain,
		@mobileNumberAreaCode,
		@mobileNumberMain
    )
    
    SET @customerId = SCOPE_IDENTITY();
    
END


GRANT EXECUTE ON h3giOrderInsuranceStoreCustomerDetails TO b4nuser
GO
