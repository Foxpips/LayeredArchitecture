

-- ============================================================
-- Author:		Sorin Oboroceanu
-- Create date: 07/10/2013
-- Description:	Gets all details that are used to generate a SEPA mandate form for a business order.
-- ============================================================
CREATE PROCEDURE [dbo].[h3giGetSepaMandateFormDetailsBusiness]
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT
		threeOrderHeader.accountHolderName AS accountName,
		threeOrganizationAddress.flatname AS apartmentNumber,
		threeOrganizationAddress.buildingNumber AS houseNumber,
		threeOrganizationAddress.buildingName AS houseName,
		threeOrganizationAddress.streetName AS streetName,
		threeOrganizationAddress.locality AS locality,
		threeOrganizationAddress.town AS city,
		'' AS postCode,
		threeOrganizationAddress.county AS countyName,
		'Ireland' AS countryName,
		threeOrderHeader.bic,
		threeOrderHeader.iban
	FROM b4norderheader
	INNER JOIN threeOrderHeader ON threeOrderHeader.orderRef = b4norderheader.orderRef
	INNER JOIN threeOrganizationAddress ON threeOrganizationAddress.organizationId = threeOrderHeader.organizationId
	WHERE b4norderheader.orderRef = @orderRef AND threeOrganizationAddress.addressType = 'BillingBusiness'
END

GRANT EXECUTE ON h3giGetSepaMandateFormDetailsBusiness TO b4nuser
GO
