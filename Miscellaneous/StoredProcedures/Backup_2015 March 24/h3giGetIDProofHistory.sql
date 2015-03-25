

CREATE PROCEDURE [dbo].[h3giGetIDProofHistory]
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @proofType INT
    DECLARE @proofIDNumber VARCHAR(50)
    DECLARE @proofCountry VARCHAR(50)
	SELECT @proofType = ISNULL(proofTypeId, '') FROM h3giCustomerProof WHERE orderRef = @orderRef AND type = 'Identity'
	SELECT @proofIDNumber = ISNULL(idNumber, '') FROM h3giCustomerProof WHERE orderRef = @orderRef AND type = 'Identity'
	SELECT @proofCountry = ISNULL(countryName, '') FROM h3giCustomerProof WHERE orderRef = @orderRef AND type = 'Identity'
	
	BEGIN
		SELECT  b4nHeader.orderref, 
				b4nHeader.billingForename + ' ' + b4nHeader.billingSurname AS customerName,
				dbo.fn_FormatAddress(viewAddress.apartmentNumber, viewAddress.houseNumber, viewAddress.houseName, viewAddress.street, viewAddress.locality, viewAddress.city, viewAddress.county, viewAddress.country, viewAddress.postCode) AS billingAddress,
				CASE WHEN b4nHeader.status IN (500,501,502,505,506,600,601,602,603,604,605) THEN codes.b4nClassExplain ELSE codes.b4nClassDesc END AS status, 
				b4nHeader.orderDate,
				CASE h3giHeader.orderType
					WHEN 0 THEN 'Contract'
					WHEN 1 THEN 'Prepay'
					WHEN 2 THEN 'Contract Upgrade'
					WHEN 3 THEN 'Prepay Upgrade'
				END AS prepay,
				ISNULL (bcc.b4nClassDesc, '') AS creditDecision
		FROM	b4nOrderHeader b4nHeader WITH(NOLOCK)
				INNER JOIN b4nClassCodes codes WITH(NOLOCK)
					ON codes.b4nclasscode = CAST(b4nHeader.status AS VARCHAR(10)) 
					AND codes.b4nclasssysid = 'statuscode'	
				INNER JOIN h3giOrderHeader h3giHeader WITH(NOLOCK)
					ON b4nHeader.orderRef = h3giHeader.orderRef
				INNER JOIN viewOrderAddress viewAddress WITH(NOLOCK)
					ON viewAddress.orderRef = b4nHeader.orderRef
					AND viewAddress.addressType = 'Current'
				INNER JOIN h3giCustomerProof proofs WITH(NOLOCK)
					ON b4nHeader.OrderRef = proofs.orderRef
				LEFT OUTER JOIN b4nClassCodes bcc WITH(NOLOCK)
					ON bcc.b4nClassSysID = 'DecisionCode'
					AND bcc.b4nClassCode = h3giHeader.decisionCode				    
		WHERE   proofs.type = 'Identity'
			AND proofs.proofTypeId = @proofType
			AND proofs.idNumber = @proofIDNumber
			AND proofs.countryName = @proofCountry
			AND b4nHeader.OrderRef != @orderRef
		ORDER BY b4nHeader.OrderDate DESC
	END
END
	





GRANT EXECUTE ON h3giGetIDProofHistory TO b4nuser
GO
