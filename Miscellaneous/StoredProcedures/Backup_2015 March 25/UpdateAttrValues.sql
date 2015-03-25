

/****** Object:  Stored Procedure dbo.UpdateAttrValues    Script Date: 23/06/2005 13:30:54 ******/


/*********************************************************************************************************************
**																					
** Procedure Name	:	UpdateAttrValues
** Author		:	John Morgan
** Date Created		:	24/11/2004
** Version		:	1.0.1	
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure Updates an AttributeValue for a given attributeid 
**				and productfamilyID		
**					
**********************************************************************************************************************/
 		


CREATE      proc dbo.UpdateAttrValues

	@AttributeValue varchar(50),
	@productFamilyId INT,
	@attributeId INT

as

	UPDATE b4nAttributeProductFamily SET attributeValue = @AttributeValue   
	WHERE (attributeId = @attributeId AND productFamilyId = @productFamilyId)






GRANT EXECUTE ON UpdateAttrValues TO b4nuser
GO
GRANT EXECUTE ON UpdateAttrValues TO helpdesk
GO
GRANT EXECUTE ON UpdateAttrValues TO ofsuser
GO
GRANT EXECUTE ON UpdateAttrValues TO reportuser
GO
GRANT EXECUTE ON UpdateAttrValues TO b4nexcel
GO
GRANT EXECUTE ON UpdateAttrValues TO b4nloader
GO
