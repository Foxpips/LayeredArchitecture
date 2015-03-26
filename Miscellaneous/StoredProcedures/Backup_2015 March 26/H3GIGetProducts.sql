

/*********************************************************************************************************************
**																					
** Procedure Name	:	H3GIGetProducts
** Author			:	Niall Carroll
** Date Created		:	
** Version			:	1.2.0
**					
**********************************************************************************************************************
**				
** Description		:	Returns a list of products
**					
**********************************************************************************************************************
**									
** Change Control	:	08 April 06 - NC - Added column FullName which indicates the contract type
**********************************************************************************************************************/

CREATE  PROCEDURE dbo.H3GIGetProducts 

@Type varchar(20) = ''

AS

SELECT 	pf.ProductFamilyID as productID, 
	ProductType, 
	productname, 
	ValidStartDate, 
	ValidEndDate,  
	productChargeCode,
	productBasePrice,
	productRecurringPrice,
	peoplesoftID,
	productBillingID,
	salesOrderHidden,
	multiplicityRule,
	CASE prepay
		WHEN 0 THEN productname + '-Contract'
		WHEN 1 THEN productname + '-Prepay'
		WHEN 2 THEN productName + '-Upgrade'
	END as FullName
	
FROM 	h3giProductCatalogue pc
inner join b4nattributeproductfamily pf on pc.catalogueProductID = pf.attributevalue AND attributeID = 303
WHERE	(@Type = '' OR @Type = ProductType)





GRANT EXECUTE ON H3GIGetProducts TO b4nuser
GO
GRANT EXECUTE ON H3GIGetProducts TO ofsuser
GO
GRANT EXECUTE ON H3GIGetProducts TO reportuser
GO
