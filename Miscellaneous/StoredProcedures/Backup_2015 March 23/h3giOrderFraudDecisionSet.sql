
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giOrderFraudDecisionSet.a
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
**********************************************************************************************************************/
CREATE PROCEDURE h3giOrderFraudDecisionSet
	@orderRef int,
	@decisionCode int,
	@reasonCode varchar(20),
	@reasonDescription nvarchar(300),
	@userId int,
	@furtherProof nvarchar(300) = NULL
AS
BEGIN
	IF EXISTS (SELECT * FROM [h3giOrderFraudDecision] WHERE orderRef = @orderRef)
	BEGIN
		UPDATE [h3giOrderFraudDecision]
		 SET [decisionDate] = getdate(),
			[decisionCode] = @decisionCode,
            [reasonCode] = @reasonCode,
			[reasonDescription] = @reasonDescription,
			[userId] = @userId,
			[furtherProof] = @furtherProof
		WHERE orderRef = @orderRef;
	END
	ELSE
	BEGIN
	INSERT INTO [dbo].[h3giOrderFraudDecision]
           ([orderRef]
           ,[decisionDate]
           ,[decisionCode]
           ,[reasonCode]
           ,[reasonDescription]
           ,[userId]
           ,[furtherProof])
     VALUES
           (@orderRef
           ,getdate()
           ,@decisionCode
           ,@reasonCode
           ,@reasonDescription
           ,@userId
           ,@furtherProof);
	END
END

GRANT EXECUTE ON h3giOrderFraudDecisionSet TO b4nuser
GO
