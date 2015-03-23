
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threePersonCreate
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	02/10/2007				
**					
**********************************************************************************************************************
**									
** Change Control	:	02/10/2007 - Adam Jasinski - Created
**
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[threePersonCreate]
	@organizationId int,
	@personType varchar(30),
	@title nvarchar(50),
	@firstName nvarchar(40),
	@middleInitial nvarchar(5),
	@lastName nvarchar(40),
	@maritalStatus varchar(30),
	@gender varchar(20),
	@dateOfBirth datetime = NULL,
	@occupationStatus nvarchar(100),
	@occupationType nvarchar(100),
	@position nvarchar(100),
	@email varchar(100),
	@timeInBusinessYY smallint = 0,
	@timeInBusinessMM tinyint = 0,
	@preferredContactMethod nvarchar(50) = NULL,
	@personId int out
AS
BEGIN

	SET @personId = 0;

	INSERT INTO [dbo].[threePerson]
           ([organizationId]
           ,[personType]
           ,[title]
           ,[firstName]
           ,[middleInitial]
           ,[lastName]
           ,[maritalStatus]
           ,[gender]
           ,[dateOfBirth]
           ,[occupationStatus]
           ,[occupationType]
           ,[position]
           ,[email]
           ,[timeInBusinessYY]
           ,[timeInBusinessMM]
		   ,[preferredContactMethod])
     VALUES
            (@organizationId,
			@personType,
			@title,
			@firstName,
			@middleInitial,
			@lastName,
			@maritalStatus,
			@gender,
			@dateOfBirth,
			@occupationStatus,
			@occupationType,
			@position,
			@email,
			@timeInBusinessYY,
			@timeInBusinessMM,
			@preferredContactMethod);

	IF @@ERROR = 0 SET @personId = SCOPE_IDENTITY();


END

GRANT EXECUTE ON threePersonCreate TO b4nuser
GO
GRANT EXECUTE ON threePersonCreate TO reportuser
GO
