



-- ==============================================================
-- Author:		Stephen Quin
-- Create date: 16/08/2013
-- Description:	Gets the insurance info that will be sent to Pier
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giInsuranceGetPierInfo]
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 SELECT 
	--customer details
	LTRIM(ISNULL(cc.b4nClassDesc,'') + ' ' + cust.forename + ' ' + cust.surname) AS fullName,	
	cust.email,
	cust.primaryContactAreaCode + cust.primaryContactMain AS primaryContactNumber,
	cust.mobileNumberAreaCode + cust.mobileNumberMain AS mobileNumber,
	addr.aptNumber,
	addr.houseNumber,
	addr.houseName,
	addr.street,
	addr.locality,
	addr.town,
	addr.county,	
	--payment details
	pay.accNumber AS accountNumber,		
	pay.sortCode AS sortCode,
	pay.accName AS accountName,
	pay.bic AS BIC,
	pay.iban AS IBAN,
	ins.paymentMethod,
	ins.paymentType,	
	policy.Name AS policyName,
	policy.AnnualPrice AS annualCost,
	policy.MonthlyPrice AS monthlyCost,	
	ins.paymentFreqId As PaymentFreId,
	insPayType.paymentMethodType As PaymentMethodType,
	insPayType.paymentMethodId As PaymentMethodId,
	--device details	
	att.attributeValue AS deviceType,
	cat.peoplesoftID,
	iccid.MSISDN AS mobileDeviceNumber,
	h3gi.IMEI
	FROM h3giOrderInsuranceCustomer cust
	INNER JOIN h3giOrderInsuranceAddress addr
		ON cust.customerId = addr.customerId
	INNER JOIN h3giOrderInsurance ins
		ON cust.customerId = ins.customerId
	INNER JOIN h3giOrderheader h3gi
		ON h3gi.orderref = ins.orderRef
	INNER JOIN h3giProductCatalogue cat
		ON h3gi.phoneProductCode = cat.productFamilyId
		AND h3gi.catalogueVersionID = cat.catalogueVersionID
	INNER JOIN h3giProductAttributeValue att
		ON cat.catalogueProductID = att.catalogueProductId
		AND att.attributeId = 2
	INNER JOIN h3giInsurancePolicy policy
		ON ins.insuranceId = policy.Id
	INNER JOIN h3giICCID iccid
		ON iccid.ICCID = h3gi.ICCID	
	Inner JOIN h3giPierPaymentMethodInfo insPayType 
		ON ins.paymentFreqId = insPayType.paymentPeriodID
	LEFT OUTER JOIN h3giOrderInsurancePayment pay
		ON cust.customerId = pay.customerId
	LEFT OUTER JOIN b4nClassCodes cc
		ON cc.b4nClassCode = cust.title
		AND cc.b4nClassDesc = 'CustomerTitle'
	WHERE ins.orderRef = @orderRef
	
END





GRANT EXECUTE ON h3giInsuranceGetPierInfo TO b4nuser
GO
