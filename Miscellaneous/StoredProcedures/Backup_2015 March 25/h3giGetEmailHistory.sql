


CREATE PROCEDURE [dbo].[h3giGetEmailHistory]
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @email VARCHAR(100)
	SELECT @email = ISNULL(Email, '') FROM b4norderheader WHERE orderref = @orderref

	SELECT  b4nHeader.orderref, 
			b4nHeader.deliveryForename + ' ' + b4nHeader.deliverySurname AS customerName,
			dbo.fn_FormatAddress(viewAddress.apartmentNumber, viewAddress.houseNumber, viewAddress.houseName, viewAddress.street, viewAddress.locality, viewAddress.city, viewAddress.county, viewAddress.country, viewAddress.postCode) AS billingAddress,
			CASE WHEN b4nHeader.status IN (500,501,502,505,506,600,601,602,603,604,605) THEN codes.b4nClassExplain ELSE codes.b4nClassDesc END AS status, 
			b4nHeader.orderDate,
			CASE h3giHeader.orderType
				WHEN 0 THEN 'Contract'
				WHEN 1 THEN 'Prepay'
				WHEN 2 THEN 'Contract Upgrade'
				WHEN 3 THEN 'Prepay Upgrade'
				WHEN 4 THEN 'Accessory'
			END AS prepay,
			ISNULL (bcc.b4nClassDesc, '') AS creditDecision
	FROM	b4nOrderHeader b4nHeader
			INNER JOIN b4nClassCodes codes 
				ON codes.b4nclasscode = CAST(b4nHeader.status AS VARCHAR(10)) 
				AND codes.b4nclasssysid = 'statuscode'
			INNER JOIN h3giOrderHeader h3giHeader 
				ON b4nHeader.orderRef = h3giHeader.orderRef
			INNER JOIN viewOrderAddress viewAddress 
				ON viewAddress.orderRef = b4nHeader.orderRef
				AND viewAddress.addressType = 'Current'
			LEFT OUTER JOIN b4nClassCodes bcc
				ON bcc.b4nClassSysID = 'DecisionCode'
				AND bcc.b4nClassCode = h3giHeader.decisionCode
	WHERE	b4nHeader.Email =  @email AND b4nHeader.Email <> ''
		AND b4nHeader.orderref != @orderref
	ORDER BY b4nHeader.OrderDate DESC
END





GRANT EXECUTE ON h3giGetEmailHistory TO b4nuser
GO
