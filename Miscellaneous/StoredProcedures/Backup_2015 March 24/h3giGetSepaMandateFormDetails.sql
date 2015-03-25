

-- ============================================================
-- Author:		Sorin Oboroceanu
-- Create date: 27/09/2013
-- Description:	Gets all details that are used to generate a SEPA mandate form.
-- ============================================================
CREATE PROCEDURE [dbo].[h3giGetSepaMandateFormDetails]
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT
		hoh.accountName,
		hoh.billingAptNumber AS apartmentNumber,
		hoh.billingHouseNumber AS houseNumber,
		hoh.billingHouseName AS houseName,
		boh.billingAddr2 AS streetName,
		boh.billingAddr3 AS locality,
		boh.billingCity AS city,
		'' AS postCode,
		boh.billingCounty AS countyName,
		boh.billingCountry AS countryName,
		hoh.bic,
		hoh.iban
	FROM b4norderheader boh
	INNER JOIN h3giOrderHeader hoh ON hoh.orderRef = boh.orderRef
	WHERE boh.orderRef = @orderRef
END

GRANT EXECUTE ON h3giGetSepaMandateFormDetails TO b4nuser
GO
