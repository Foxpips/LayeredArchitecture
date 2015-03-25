



-- ============================================================
-- Author:		Stephen King
-- Create date: 19/11/2013
-- Description:	Gets all details that are used to generate a insurance form.
-- ============================================================
CREATE PROCEDURE [dbo].[h3giGetInsuranceFormDetails]
	@orderRefs h3giIds readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--The customer details should be the same for all so we just need to get one result
SELECT TOP 1
		--Customer data
		hoic.forename As firstName,
		hoic.surname As lastName,
		hoia.aptNumber AS apartmentNumber,
		hoia.houseNumber AS houseNumber,
		hoia.houseName AS houseName,
		hoia.street AS streetName,
		hoia.locality AS locality,
		hoia.town AS city,
		'' AS postCode,
		hoia.county AS countyName,
		'' AS countryName,
		--Bank data
		case when hoi.paymentType = 'InStore' then 'false'
							 ELSE 'true'
		end AS HasBankDetails,
		hoip.accName As accountName,
		hoip.bic As bic,
		hoip.iban As iban,
		hoipc.mandateRef As  MandateRef,
		hoipc.inceptionDate AS InceptionDate,

		hoipc.dayOfDebit As DayOfDebit,
		hoipc.dateOfCollection As DateOfCollection,

		--Case Data
		hoipc.pierCaseId AS CaseId,
		hoipc.clientId AS CustomerId,
		hpomi.displayNoun AS PaymentType,
		hpomi.paymentFrequency AS CollectionFreq,
		case when hoi.paymentMethod = 'Annual' then 'false'
							 ELSE 'true'
		end AS IsRecurring,
		case when hoi.paymentMethod = 'Annual' then hip.AnnualPrice
							 ELSE hip.MonthlyPrice
		end AS Price
		
	FROM h3giOrderHeader hoh
	INNER JOIN @orderRefs paramOrderRef ON hoh.OrderRef = paramOrderRef.Id
	INNER JOIN h3giOrderInsurance hoi ON hoi.orderRef = hoh.orderref
	INNER JOIN h3giOrderInsuranceCustomer hoic ON hoic.customerId = hoi.customerId
	LEFT OUTER JOIN h3giOrderInsurancePayment hoip ON hoip.customerId = hoi.customerId
	INNER JOIN h3giOrderInsuranceAddress hoia ON hoia.customerId = hoi.customerId
	INNER JOIN h3giOrderInsurancePierCase hoipc ON hoipc.orderInsuranceId = hoi.id
	INNER JOIN h3giInsurancePolicy hip ON hip.Id = hoi.insuranceId and hip.Deleted = 0
	INNER JOIN h3giPierPaymentMethodInfo hpomi ON hpomi.paymentPeriodID = hoi.paymentFreqId	 
	  
	  select 
		hoh.IMEI as IMEI,
		hiccid.MSISDN as PhoneNumber,
		bapf1.attributeValue As Manufacturer,
		bapf2.attributeValue As Model
	  from
	  h3giOrderHeader hoh
	  	INNER JOIN @orderRefs paramOrderRef ON hoh.OrderRef = paramOrderRef.Id
	  	INNER JOIN b4nOrderLine bol on bol.OrderRef = hoh.orderref
		INNER JOIN h3giICCID hiccid on hiccid.ICCID = hoh.ICCID
		INNER JOIN h3giProductCatalogue hpc on hpc.catalogueProductID = bol.ProductID 
		INNER JOIN b4nAttributeProductFamily  bapf1 on hpc.productFamilyId = bapf1.productFamilyId and bapf1.attributeId = dbo.fn_GetAttributeByName('Manufacturer')  
		INNER JOIN b4nAttributeProductFamily  bapf2 on hpc.productFamilyId = bapf2.productFamilyId and bapf2.attributeId = dbo.fn_GetAttributeByName('Model')
	  where
	  hpc.productType = 'HANDSET'
		and hpc.catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
END


GRANT EXECUTE ON h3giGetInsuranceFormDetails TO b4nuser
GO
