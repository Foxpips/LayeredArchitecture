




-- =======================================================================
-- Author:		Stephen Quin
-- Create date: 24/09/08
-- Description:	Checks any orders placed in the last 6 months to see if 
--				the same address was used as the address associated with 
--				the orderRef passed as a parameter
-- Changes:		28/02/2012 - Stephen Quin - Accessory orders now included
-- =======================================================================
CREATE PROCEDURE [dbo].[h3giFraudGetAddressHistory] 
	@orderRef INT,
	@addressType VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--First check if the current order has non-empty address
	IF EXISTS (SELECT * FROM viewOrderAddress
			WHERE orderRef = @orderRef
			AND city <> ''
			AND addressType = @addressType)
	BEGIN

--		DECLARE @currentSingleLine varchar(8000)
--	
--		SELECT @currentSingleLine = singleLine
--		FROM viewOrderAddress
--		WHERE orderRef = @orderRef
--		AND addressType = @addressType;
		DECLARE @currentStreet varchar(200)
		DECLARE @currentCity varchar(200)

		SELECT  @currentStreet = street, @currentCity = city
		FROM viewOrderAddress
		WHERE orderRef = @orderRef
		AND addressType = @addressType;
		
	

	--add address details to the table variable
		SELECT	viewAddress.* INTO #candidatesLast6M 
		FROM	b4nOrderHeader b4nHeader WITH(NOLOCK)
				INNER JOIN h3giOrderHeader h3giHeader WITH(NOLOCK)
					ON	b4nHeader.orderRef = h3giHeader.orderRef
				INNER JOIN viewOrderAddress viewAddress WITH(NOLOCK)
					ON b4nHeader.orderRef = viewAddress.orderRef
		WHERE	b4nHeader.orderDate BETWEEN DATEADD(mm,-6,GETDATE())  AND GETDATE()
				AND viewAddress.addressType = @addressType
		AND h3giHeader.orderType IN (0,1,4)		
		AND viewAddress.street = @currentStreet
		AND viewAddress.city = @currentCity
		AND viewAddress.orderRef <> @orderRef

		--select any addess details that are the same as 
		--the current order as these may be fraudulent
		SELECT	lm.*,
				b4nHeader.billingForename + ' ' + (CASE WHEN(LEN(h3giHeader.initials)>0) THEN h3giHeader.initials ELSE '' END) + b4nHeader.billingSurname AS customerName,
				b4nHeader.Status AS statusCode,
				CASE statusCode.b4nClassDesc
					WHEN 'being Fulfilled' THEN 'Being Fulfilled'
					WHEN 'ordered' THEN 'Ordered'
					WHEN 'cancelled' THEN 'Cancelled'
					WHEN 'pending' THEN 'Pending'
					WHEN 'referred' THEN 'Referred'
					WHEN 'declinedCallBack' THEN 'Declined Callback'
					WHEN 'declined' THEN 'Declined'
					WHEN 'approved' THEN 'Approved'
					WHEN 'AwaitingDeposit' THEN 'Awaiting Deposit'
					WHEN 'DepositRejected' THEN 'Deposit Rejected'
					WHEN 'DepositPaid' THEN 'Deposit Paid'
					WHEN 'DepositOnHold' THEN 'Deposit On Hold' 
					WHEN 'FopsAwaiting' THEN 'FOPS Pending Investigation'
					WHEN 'FopsCancelled' THEN 'FOPS Cancelled'
					WHEN 'FopsUnderReview' THEN 'FOPS Under Review'
					WHEN 'FopsDeclined' THEN 'FOPS Decline'
					WHEN 'FopsApproved' THEN 'FOPS Accept'
					ELSE statusCode.b4nClassDesc
				END AS status,
				b4nHeader.orderDate,
				h3giHeader.orderType AS orderTypeCode,
				orderType.title AS orderType,
				ISNULL (bcc.b4nClassDesc, '') AS CreditDecision
		FROM	#candidatesLast6M lm
				INNER JOIN b4nOrderHeader b4nHeader WITH(NOLOCK)
				ON 	b4nHeader.orderref = lm.orderref
				INNER JOIN h3giOrderHeader h3giHeader WITH(NOLOCK)
					ON	b4nHeader.orderRef = h3giHeader.orderRef
				INNER JOIN b4nClassCodes statusCode WITH(NOLOCK)
					ON b4nHeader.status = statusCode.b4nClassCode
					AND statusCode.b4nClassSysID = 'StatusCode'
				INNER JOIN h3giOrderType orderType WITH(NOLOCK)
					ON h3giHeader.orderType = orderType.orderTypeId
				LEFT OUTER JOIN b4nClassCodes bcc WITH(NOLOCK)
					ON bcc.b4nClassSysID = 'DecisionCode'
					AND bcc.b4nClassCode = h3giHeader.decisionCode				
		ORDER BY h3giHeader.orderref desc
		--OPTION (FORCE ORDER);	--the optimizer is going crazy without forcing the order

		DROP TABLE #candidatesLast6M;

	END
END










GRANT EXECUTE ON h3giFraudGetAddressHistory TO b4nuser
GO
