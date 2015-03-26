
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threePersonUpdate
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
CREATE PROCEDURE dbo.threePersonUpdate
	@personId int,
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
	@timeInBusinessMM tinyint = 0
AS
BEGIN

UPDATE [dbo].[threePerson]
   SET [personType] = @personType
      ,[title] = @title
      ,[firstName] = @firstName
      ,[middleInitial] = @middleInitial
      ,[lastName] = @lastName
      ,[maritalStatus] = @maritalStatus
      ,[gender] = @gender
      ,[dateOfBirth] = @dateOfBirth
      ,[occupationStatus] = @occupationStatus
      ,[occupationType] = @occupationType
      ,[position] = @position
      ,[email] = @email
      ,[timeInBusinessYY] = @timeInBusinessYY
      ,[timeInBusinessMM] = @timeInBusinessMM
 WHERE personId = @personId


END

GRANT EXECUTE ON threePersonUpdate TO b4nuser
GO
GRANT EXECUTE ON threePersonUpdate TO reportuser
GO
