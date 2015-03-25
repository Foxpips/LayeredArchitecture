
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.h3giOrderFraudDecisionGet
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:					
**					
**********************************************************************************************************************
**									
** Change Control	:	 - Adam Jasinski - Created
**
**					22/10/08	-	Stephen Quin	-	Added a join to the b4nClassCodes table which allows us to 
**														retrieve the decsription from the b4nClassCodes table when the
**														reasonCode is 0
**
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giOrderFraudDecisionGet
	@orderRef int = 0
AS
BEGIN
	SELECT	fraud.decisionId,
			fraud.orderRef,
			fraud.decisionDate,
			fraud.decisionCode,
			fraud.reasonCode,
			CASE fraud.reasonCode 
				WHEN 0 THEN fraud.reasonDescription
				ELSE classCode.b4nClassDesc
			END AS reasonDescription,
			fraud.userId,
			fraud.furtherProof
	FROM	h3giOrderFraudDecision fraud
			LEFT OUTER JOIN b4nClassCodes classCode
				ON fraud.reasonCode = classCode.b4nClassCode
				AND classCode.b4nClassSysId = 'FOPSAcceptReason'
			WHERE fraud.orderRef = @orderRef
END

GRANT EXECUTE ON h3giOrderFraudDecisionGet TO b4nuser
GO
