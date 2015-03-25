


CREATE PROCEDURE [dbo].[h3giGetContactNumberHistory]
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @areaCode VARCHAR(10)
    DECLARE @phone VARCHAR(15)
	SELECT @areaCode = ISNULL(daytimeContactAreaCode, '') FROM h3giOrderheader WHERE orderRef = @orderref
	SELECT @phone = ISNULL(daytimeContactNumber, '') FROM h3giOrderheader WHERE orderRef = @orderref
	
	IF (@phone != '')
	BEGIN
		SELECT  b4nHeader.orderref, 
				b4nHeader.deliveryForename + ' ' + b4nHeader.deliverySurname AS customerName,
				dbo.fn_FormatAddress(ISNULL(h3giHeader.billingAptNumber,''),ISNULL(h3giHeader.billingHouseNumber,''),ISNULL(h3giHeader.billingHouseName,''),b4nHeader.billingAddr2,b4nHeader.billingAddr3,ISNULL(b4nHeader.billingCity,''),b4nHeader.billingCounty,	b4nHeader.billingCountry,b4nHeader.billingPostCode) AS billingAddress,				
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
				LEFT OUTER JOIN b4nClassCodes bcc
					ON bcc.b4nClassSysID = 'DecisionCode'
					AND bcc.b4nClassCode = h3giHeader.decisionCode
		WHERE	h3giHeader.daytimeContactAreaCode =  @areaCode
		    AND h3giHeader.daytimeContactNumber = @phone
			AND b4nHeader.orderref != @orderref
		ORDER BY b4nHeader.OrderDate DESC
	END
	
END






GRANT EXECUTE ON h3giGetContactNumberHistory TO b4nuser
GO
