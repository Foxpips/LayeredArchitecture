
-- =============================================
-- Author:		Stephen Quin
-- Create date: 28/11/2012
-- Description:	Gets cc transaction info needed
--				for rebates and voids
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetCCTransactionInfo] 
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--SHADOW CHARGE
	SELECT	h3gi.orderRef,
			CASE ISNULL(link.linkedOrderRef,-1) 
				WHEN -1 THEN 0
				ELSE 1
			END AS isLinked,
			h3gi.channelCode,
			b4n.GoodsPrice,
			b4n.deliveryCharge,
			CASE ISNULL(shadow.transactionId,-1)
				WHEN -1 THEN 0
				ELSE 1
			END AS hasShadow,
			ISNULL(shadow.chargeAmount,0) AS shadowAmount,
			ISNULL(shadow.account,'') AS shadowAccount,
			ISNULL(shadow.passRef,'') AS shadowPassRef,
			ISNULL(shadow.OrderRef,'') AS shadowOrderId,
			CASE ISNULL(cc.OrderRef,'')
				WHEN '' THEN 0
				ELSE 1
			END AS shadowSettled		
	FROM	h3giOrderheader h3gi WITH(NOLOCK)
	INNER JOIN b4nOrderHeader b4n WITH(NOLOCK)
		ON h3gi.orderref = b4n.OrderRef
	LEFT OUTER JOIN h3giLinkedOrders link WITH(NOLOCK)
		ON h3gi.orderref = link.orderRef
	LEFT OUTER JOIN b4nccTransactionLog shadow WITH(NOLOCK)     
		ON shadow.b4nOrderRef = h3gi.OrderRef 
		AND shadow.ResultCode = 0  
		AND shadow.transactionItemType = 0     
		AND shadow.TransactionType = 'SHADOW'
	LEFT OUTER JOIN b4nccTransactionLog cc WITH(NOLOCK)       
		ON cc.b4nOrderRef = h3gi.OrderRef 
		AND cc.ResultCode = 0  
		AND cc.transactionItemType = 0     
		AND cc.TransactionType IN ('FULL', 'SETTLE') 
		AND shadow.OrderRef = cc.OrderRef
	WHERE h3gi.orderref = @orderRef

	--FULL/SETTLE CHARGE
	SELECT	h3gi.orderRef,
			CASE ISNULL(link.linkedOrderRef,-1) 
				WHEN -1 THEN 0
				ELSE 1
			END AS isLinked,
			h3gi.channelCode,
			b4n.GoodsPrice,
			b4n.deliveryCharge,
			CASE ISNULL(cc.transactionId,-1)
				WHEN -1 THEN 0
				ELSE 1
			END AS hasCharge,
			ISNULL(cc.chargeAmount,0) AS chargeAmount,
			ISNULL(cc.account,'') AS chargeAccount,
			ISNULL(cc.passRef,'') AS chargePassRef,		
			ISNULL(cc.TransactionType,'') AS chargeType		
	FROM	h3giOrderheader h3gi WITH(NOLOCK)
	INNER JOIN b4nOrderHeader b4n WITH(NOLOCK)
		ON h3gi.orderref = b4n.OrderRef
	LEFT OUTER JOIN h3giLinkedOrders link WITH(NOLOCK)
		ON h3gi.orderref = link.orderRef
	LEFT OUTER JOIN b4nccTransactionLog cc WITH(NOLOCK)      
		ON cc.b4nOrderRef = h3gi.OrderRef 
		AND cc.ResultCode = 0  
		AND cc.transactionItemType = 0     
		AND cc.TransactionType IN ('FULL', 'SETTLE') 
	WHERE h3gi.orderref = @orderRef

	
	--DEPOSIT SHADOW CHARGE
	SELECT	h3gi.orderRef,
			h3gi.channelCode,
			CASE ISNULL(deposit.depositId,-1)
				WHEN -1 THEN 0
				ELSE 1
			END AS hasDeposit,   
			ISNULL(deposit.depositAmount,0) AS depositAmount,	
			CASE ISNULL(shadow.transactionId,-1)
				WHEN -1 THEN 0
				ELSE 1
			END AS hasDepositShadow,
			ISNULL(shadow.chargeAmount,0) AS depositShadowAmount,		
			ISNULL(shadow.passRef,'') AS depositShadowPassRef,				
			ISNULL(shadow.OrderRef,'') AS depositShadowOrderId,
			CASE ISNULL(cc.OrderRef,'')
				WHEN '' THEN 0
				ELSE 1
			END AS depositShadowSettled
	FROM h3giOrderheader h3gi WITH(NOLOCK)
	LEFT OUTER JOIN b4nccTransactionLog shadow WITH(NOLOCK)    
		ON shadow.b4nOrderRef = h3gi.OrderRef 
		AND shadow.ResultCode = 0  
		AND shadow.transactionItemType = 1    
		AND shadow.TransactionType = 'SHADOW'
	LEFT OUTER JOIN b4nccTransactionLog cc WITH(NOLOCK)    
		ON cc.b4nOrderRef = h3gi.OrderRef 
		AND cc.ResultCode = 0  
		AND cc.transactionItemType = 1
		AND cc.TransactionType IN ('FULL', 'SETTLE') 
		AND shadow.OrderRef = cc.OrderRef
	LEFT OUTER JOIN h3giOrderDeposit deposit WITH(NOLOCK)
		ON h3gi.orderRef = deposit.orderRef
	WHERE h3gi.orderref = @orderRef


	--DEPOSIT FULL/SETTLE CHARGE
	SELECT	h3gi.orderRef,
			h3gi.channelCode,
			CASE ISNULL(deposit.depositId,-1)
				WHEN -1 THEN 0
				ELSE 1
			END AS hasDeposit,   
			ISNULL(deposit.depositAmount,0) AS depositAmount,
			ISNULL(deposit.depositPaid,0) AS depositPaid,		
			CASE ISNULL(cc.transactionId,-1)
				WHEN -1 THEN 0
				ELSE 1
			END AS hasDepositCharge,
			ISNULL(cc.chargeAmount,0) AS depositChargeAmount,		
			ISNULL(cc.passRef,'') AS depositChargePassRef,		
			ISNULL(cc.TransactionType,'') AS depositChargeType		
	FROM h3giOrderheader h3gi WITH(NOLOCK)
	LEFT OUTER JOIN b4nccTransactionLog cc WITH(NOLOCK)     
		ON cc.b4nOrderRef = h3gi.OrderRef 
		AND cc.ResultCode = 0  
		AND cc.transactionItemType = 1
		AND TransactionType IN ('FULL', 'SETTLE') 
	LEFT OUTER JOIN h3giOrderDeposit deposit WITH(NOLOCK)
		ON h3gi.orderRef = deposit.orderRef
	WHERE h3gi.orderref = @orderRef


END


GRANT EXECUTE ON h3giGetCCTransactionInfo TO b4nuser
GO
