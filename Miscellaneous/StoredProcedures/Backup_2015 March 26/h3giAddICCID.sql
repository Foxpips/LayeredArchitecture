/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAddICCID
** Author			:	Niall Carroll
** Date Created		:	
** Version			:	
**					
**********************************************************************************************************************
**				
** Description		:	Adds an ICCID to the lookup table
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giAddICCID]
@ICCID 	varchar(25),
@MSISDN varchar(50),
@File	varchar(50),
@Prepay int = 0

AS


DECLARE @ICCIDCount int

SELECT @ICCIDCount = Count(*) FROM h3giICCID WITH(NOLOCK) WHERE ICCID = @ICCID

IF @ICCIDCount = 0
BEGIN 
	INSERT INTO h3giICCID (ICCID, MSISDN, FileName, DateAdded, Prepay) 
	VALUES (@ICCID, @MSISDN, @File, GetDate(), @Prepay)
END
SELECT @ICCIDCount


GRANT EXECUTE ON h3giAddICCID TO b4nuser
GO
GRANT EXECUTE ON h3giAddICCID TO ofsuser
GO
GRANT EXECUTE ON h3giAddICCID TO reportuser
GO
