
-- =============================================
-- Author:		Stephen Quin
-- Create date: 20/10/2010
-- Description:	Extracts the response and error
--				data that was returned from 
--				Experian for a particular order
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetExperianResponseData]
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT TOP 1 CAST(VALUE AS XML).value('(GEODS/REQUEST/@EXP_ExperianRef)[1]','NVARCHAR(20)') AS experianRef,
	CAST(VALUE AS XML).value('(GEODS/REQUEST/DECI/DECISION_CODE)[1]','NVARCHAR(2)') AS decisionCode,
	CAST(VALUE AS XML).value('(GEODS/REQUEST/DECI/CREDIT_LIMIT)[1]','NVARCHAR(5)') AS creditLimit,
	CAST(VALUE AS XML).value('(GEODS/REQUEST/DECI/SHADOW_LIMIT)[1]','NVARCHAR(5)') AS shadowLimit,
	CAST(VALUE AS XML).value('(GEODS/REQUEST/DECI/DEPOSIT)[1]','NVARCHAR(6)') AS deposit,
	CAST(VALUE AS XML).value('(GEODS/REQUEST/DECI/ROAMING)[1]','NCHAR(1)') AS roaming
FROM   h3giAutomatedCreditCheckLog ccLog WITH (NOLOCK)
WHERE ccLog.type = 'Response'
AND ccLog.orderRef = @orderRef
ORDER BY eventDate ASC

SELECT TOP 1 value
FROM h3giAutomatedCreditCheckLog
WHERE type = 'Error'
AND orderRef = @orderRef

END


GRANT EXECUTE ON h3giGetExperianResponseData TO b4nuser
GO
