
/**********************************************************************************************************************    
**             
** Change Control : 20/09/2011 - NM - added response message for better audit tracking
*********************************************************************************************************************/    


CREATE PROCEDURE [dbo].[h3giAddThreeDSecureAudit]
	@channel VARCHAR(20),
	@cardType VARCHAR(20),
	@status VARCHAR(20),
	@responseMessage NVARCHAR(MAX)='',
	@emailAddress NVARCHAR(MAX) ='',
	@orderRef INT =0,
	@transactionid NVARCHAR(MAX)='',
	@authStatus VARCHAR(20) = NULL
AS
BEGIN
	INSERT INTO h3giThreeDSecureAudit 
	(channel, cardType, status, TIMESTAMP,authenticationStatus,responseMessage,emailAddress,orderRef,transactionId)
	VALUES 
	(@channel, @cardType, @status, GETDATE(), @authStatus, @responseMessage,@emailAddress,@orderRef,@transactionId)
END



GRANT EXECUTE ON h3giAddThreeDSecureAudit TO b4nuser
GO
