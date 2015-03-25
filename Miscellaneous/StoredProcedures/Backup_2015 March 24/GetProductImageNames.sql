

/****** Object:  Stored Procedure dbo.GetProductImageNames    Script Date: 23/06/2005 13:30:49 ******/



/*********************************************************************************************************************
**																					
** Procedure Name	:	GetProductImageNames
** Author		:	John Morgan
** Date Created		:	24/11/2004
** Version		:	1.0.1	
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure gets back a list off all image names. 
**						
**					
**********************************************************************************************************************/
 		



CREATE      proc dbo.GetProductImageNames

as

	DECLARE @Attrib1 INT
	DECLARE @Attrib2 INT

	SET @Attrib1 = 15
	SET @Attrib2 = 16

	SELECT productFamilyId, attributeId, attributeValue 
	FROM b4nAttributeProductFamily with (nolock)
	WHERE (attributeId = @Attrib1 OR attributeId = @Attrib2)









GRANT EXECUTE ON GetProductImageNames TO b4nuser
GO
GRANT EXECUTE ON GetProductImageNames TO helpdesk
GO
GRANT EXECUTE ON GetProductImageNames TO ofsuser
GO
GRANT EXECUTE ON GetProductImageNames TO reportuser
GO
GRANT EXECUTE ON GetProductImageNames TO b4nexcel
GO
GRANT EXECUTE ON GetProductImageNames TO b4nloader
GO
