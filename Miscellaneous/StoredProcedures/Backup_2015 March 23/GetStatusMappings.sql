

/****** Object:  Stored Procedure dbo.GetStatusMappings    Script Date: 23/06/2005 13:30:50 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.GetStatusMappings
** Author		:	Ciaran Hurst	
** Date Created		:	10/05/2005
** Parameters		:	
** Return Values		:	
**Tested 			
**On all permutations	:	No
** Version		:	1.0.0
** Description		:	brings back the status mappings. checks the table for the mappings
				if the only entry in this table is 'ALL' then has to go to the classcodes table to pull 
				back the statuses.
**Change Control	:	10/05/2005 - updated the sp header to agree with company standards 
**********************************************************************************************************************/ 
CREATE PROCEDURE dbo.GetStatusMappings
	 @source VARCHAR(20)
AS
SET NOCOUNT ON


--check to see if the query only returns 
SELECT 
	DISTINCT(Filter) 
FROM 
	H3GISearchFilterMap
WHERE 
	source=@source  and IsValid ='Y'






GRANT EXECUTE ON GetStatusMappings TO b4nuser
GO
GRANT EXECUTE ON GetStatusMappings TO helpdesk
GO
GRANT EXECUTE ON GetStatusMappings TO ofsuser
GO
GRANT EXECUTE ON GetStatusMappings TO reportuser
GO
GRANT EXECUTE ON GetStatusMappings TO b4nexcel
GO
GRANT EXECUTE ON GetStatusMappings TO b4nloader
GO
