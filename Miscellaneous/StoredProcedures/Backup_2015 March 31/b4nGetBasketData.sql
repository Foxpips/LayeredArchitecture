

/****** Object:  Stored Procedure dbo.b4nGetBasketData    Script Date: 23/06/2005 13:31:14 ******/








/*********************************************************************************************************************
**																					
** Procedure Name	:	b4nGetBasketData
** Author		:	Kevin Roche	
** Date Created		:	22/04/2005
** Version		:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure returns basket data and price plan information
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						

CREATE                 procedure dbo.b4nGetBasketData

	@nCustomerId 	INT,
	@nStoreId 	INT=1,
	@viewType 	VARCHAR(50),
	@MaxProducts 	INT = 0

AS


	SET NOCOUNT ON

 	DECLARE @viewTypeId INT

	SET @viewTypeId = (SELECT viewTypeId FROM b4nViewType WHERE viewType = @viewType)
	SET ROWCOUNT @maxproducts

	
	CREATE TABLE [#TempResults] 
	(
		[row]				[int],
		[storeid] 			[int] ,
		[customerid] 			[int],
		[basketId] 			[int],
		[baBasketId] 			[int],
		[productfamilyid] 		[int],
		[productId] 			[int] ,
		[giftWrappingTypeId] 		[int],
		[attributeId] 			[int],
		[basketattributeid] 		[int],
		[attributeTypeId] 		[int],
		[attributerowid] 		[int],
		[basketattributerowid] 		[int],
		[productData] 			[int],
		[multivalue] 			[smallint],
		[quantity] 			[real],
		[attributeAffectsRRPPriceBy] 	[real],
		[attributeAffectsBasePriceBy] 	[real],
		[UPPM]				[real],
		[attributeSource] 		[varchar] (1),
		[attributeName] 		[varchar] (50),
		[attributeValue] 		[varchar] (8000),
		[attributeuservalue] 		[varchar] (8000),
		[attributeimagename] 		[varchar] (100),
		[attributeimagenamesmall] 	[varchar] (100),
		[displayvalue] 			[varchar] (500),
		[dropdowndescription] 		[varchar] (100),
		[basketdescription] 		[varchar] (100),
		[labeldescription] 		[varchar] (100),
		[textClassSize] 		[varchar] (1) ,
		[colspan] 			[varchar] (1),
		[rowspan] 			[varchar] (1),
		[modifydate] 			[datetime]
	) 

	SET ROWCOUNT 0

	-- Get List of Basket Items
	INSERT INTO #TempResults
	SELECT  1 as row,
		b.storeid,
		b.customerid,
		b.basketId,
		ba.basketid as baBasketId,
		isnull(f.productfamilyid,0) AS productfamilyid,
		b.productId,
		isnull(b.giftWrappingTypeId,0) as giftWrappingTypeId,
		a.attributeId,
		ba.attributeid AS basketattributeid,
		a.attributeTypeId,
		f.attributerowid,
		ba.attributerowid AS basketattributerowid,
		1 as productData,
		a.multiValue,
		b.quantity,
		f.attributeAffectsRRPPriceBy,
		ISNULL(f.attributeAffectsBasePriceBy,0) as attributeAffectsBasePriceBy,
		isnull(f.UPPM,0) as UPPM,
		a.attributeSource,
		a.attributeName,
		f.attributeValue,
		ba.attributeuservalue,  
		f.attributeimagename,
		f.attributeimagenamesmall,
		(SELECT TOP 1 bs.displayvalue FROM b4nattributebase bs WITH(NOLOCK) WHERE bs.attributeid = a.attributeid AND bs.attributevalue = f.attributevalue) AS displayvalue,
		a.dropdowndescription,
		a.basketdescription,
		a.labeldescription,
		'0' as textClassSize,
		'0' as colspan,
		'0' as rowspan,
		b.modifydate

	FROM 	b4nBasket 			b WITH(NOLOCK), 
		b4nproduct 			p1 WITH(NOLOCK),
		b4nproductfamily 		pf WITH(NOLOCK),
		b4nAttributeInCollection 	c WITH(NOLOCK) , 
		b4nAttribute 			a WITH(NOLOCK), 		
		b4nbasketattribute 		ba WITH(NOLOCK),
		b4nAttributeProductFamily 	f with(nolock)

	WHERE 	b.CustomerId 			= @nCustomerId
		AND b.StoreId 			= @nStoreId
		AND  ba.basketid 		= b.basketid
		AND p1.productid 		= b.productid
		AND p1.deleted 			= 0
		AND pf.productfamilyid 		= p1.productfamilyid
		AND f.productfamilyID 		= pf.productfamilyid
		AND f.attributeID		= a.attributeID
		AND f.attributerowid 		= ba.attributerowid 
		AND a.attributeid 		= f.attributeid
		AND c.attributecollectionid 	= pf.attributecollectionid
		AND c.attributeID 		= a.attributeID
		AND a.attributeSource 		= 'C'

	-- get system attributes
	INSERT INTO #TempResults
	SELECT  1 as row,
		b.storeid,
		b.customerid,
		b.basketId,
		0 AS baBasketId,
		0 AS productfamilyid,  
		b.productId,
		ISNULL(b.giftWrappingTypeId,0) AS giftWrappingTypeId,
		a.attributeId,
		0 AS basketattributeid,
		a.attributeTypeId,
		0 AS attributerowid,
		0 AS basketattributerowid,
		1 AS productData,
		a.multiValue,
		b.quantity,
		0 as attributeAffectsRRPPriceBy,
		0 AS attributeAffectsBasePriceBy,
		0 as UPPM,
		a.attributeSource,
		a.attributeName,
		'' AS attributeValue,
		'' AS attributeuservalue, 
		'' AS attributeimagename,
		'' AS attributeimagenamesmall,
		'' AS displayvalue,
		a.dropdowndescription,
		a.basketdescription,
		a.labeldescription,
		cd.textClassSize,
		cd.colspan,
		cd.rowspan,
		b.modifydate

	FROM 	b4nBasket 		b WITH(NOLOCK), 
		b4nProduct 		p WITH(NOLOCK),
		b4nProductFamily 	pf WITH(NOLOCK),
		b4nCollectionDisplay 	cd WITH(NOLOCK), 
		b4nViewType 		v WITH(NOLOCK),
		b4nAttribute		 a WITH(NOLOCK)
	WHERE 	b.customerid 		= @nCustomerId
		AND b.storeid 		= @nStoreId
		AND p.productid 	= b.productid
		AND pf.productfamilyid 	= p.productfamilyid
		AND v.viewTypeId 	= @viewTypeId
		AND cd.viewTypeId 	= v.viewtypeid
		AND cd.contentType 	= 'A'
		AND a.attributeid  	= cd.content
  		AND a.attributeSource 	= 'S'
		AND p.productfamilyid 	= pf.productfamilyid
		AND p.deleted 		= 0

	-- get attribute user values
	INSERT INTO #TempResults
	SELECT  1 as row,
		b.storeid,
		b.customerid,
		b.basketId, 
		ba.basketid AS baBasketId,
		0 AS productfamilyid, 
		b.productId,
		ISNULL(b.giftWrappingTypeId,0) AS giftWrappingTypeId,
		a.attributeId,
		ba.attributeid AS basketattributeid,
		a.attributeTypeId,
		0 AS attributerowid,
		ba.attributerowid AS basketattributerowid,
		1 AS productData,
		a.multiValue,
		b.quantity,
		0 AS attributeAffectsRRPPriceBy,
		0 AS attributeAffectsBasePriceBy,
		0 as UPPM,
		a.attributeSource,
		a.attributeName,
		'' AS attributeValue,
		ba.attributeuservalue,
		'' AS attributeimagename,
		'' AS attributeimagenamesmall,
		'' AS displayvalue,
		a.dropdowndescription,
		a.basketdescription,
		a.labeldescription,
		'0' AS textClassSize,
		'0' AS colspan,
		'0' as rowspan,
		b.modifydate

	FROM 	b4nAttributeType 	t WITH(NOLOCK), 
		b4nAttribute 		a WITH(NOLOCK),
		b4nbasketattribute 	ba WITH(NOLOCK),
		b4nAttributeBase 	bs WITH(NOLOCK),  
		b4nBasket 		b WITH(NOLOCK), 
		b4nproduct 		p1 WITH(NOLOCK)
	WHERE b.customerid 		= @nCustomerId
		AND b.storeid 		= @nStoreId
		AND p1.productid 	= b.productid
		AND p1.deleted 		= 0
		AND  ba.basketid 	= b.basketid   
		AND a.attributeid 	= ba.attributeid
		AND t.attributeTypeID 	= a.attributeTypeID
		AND ISNULL(ba.attributeuservalue,'') != ''
		AND ISNULL(ba.attributeuservalue,'') != ''

	-- get attributes not in basket but in product
	INSERT INTO #TempResults
	SELECT  1 as row,
		b.storeid,
		b.customerid,
		b.basketId,  
		0 AS baBasketId,
		ISNULL(f.productfamilyid,0) AS productfamilyid, 
		b.productId,
		ISNULL(b.giftWrappingTypeId,0) AS giftWrappingTypeId,
		a.attributeId,
		0 AS basketattributeid,
		a.attributeTypeId,
		f.attributerowid,
		0 AS basketattributerowid,
		1 AS productData,
		a.multiValue,
		b.quantity,
		f.attributeAffectsRRPPriceBy,
		ISNULL(f.attributeAffectsBasePriceBy,0) AS attributeAffectsBasePriceBy,
		isnull(f.UPPM, 0) as UPPM,
		a.attributeSource,
		a.attributeName,
		f.attributeValue,
		'' AS attributeuservalue,
		f.attributeimagename,
		f.attributeimagenamesmall,
		(SELECT TOP 1 bs.displayvalue FROM b4nattributebase bs WITH(NOLOCK) WHERE bs.attributeid = a.attributeid and bs.attributevalue = f.attributevalue) AS displayvalue,
		a.dropdowndescription,
		a.basketdescription,
		a.labeldescription,
		'0' AS textClassSize,
		'0' AS colspan,
		'0' AS rowspan,
		b.modifydate


	FROM 	b4nBasket 			b WITH(NOLOCK), 
		b4nproduct 			p1 WITH(NOLOCK), 
		b4nproductfamily 		pf WITH(NOLOCK),
		b4nAttributeProductFamily 	f WITH(NOLOCK),
		b4nAttributeInCollection 	c WITH(NOLOCK), 
		b4nAttribute 			a WITH(NOLOCK)
	WHERE 	b.customerid 			= @nCustomerID
			AND b.storeid 		= @nStoreId
			AND p1.productid 	= b.productid
			AND p1.deleted 		= 0
			AND pf.productfamilyid 	= p1.productfamilyid
			AND f.productfamilyID 	= pf.productfamilyid
			AND f.attributeid 	= a.attributeid
			AND c.attributecollectionid = pf.attributecollectionid
			AND a.attributeID 	= c.attributeID
			AND a.attributeSource 	= 'C'
			AND a.attributeid NOT IN(SELECT attributeid FROM b4nbasketattribute WITH(NOLOCK) WHERE basketid = b.basketid)


	-- Convert GiftVoucherPrice (100) to Base PRICE attribute(19)

	UPDATE #TempResults
	SET 	attributeid 	= 19,
		productfamilyid = 100000,
		baBasketID	= 0,
		basketattributerowid = 0,
		attributerowid  = (SELECT attributerowid FROM b4nattributeproductfamily WHERE productfamilyid = 100000 AND attributeid = 100),
		displayvalue 	= attributeuservalue,
		attributetypeid = 16,
		basketattributeid = 0,
		attributeName 	= 'Base PRICE',
		attributevalue  = attributeuservalue
	WHERE attributeid = 100
	and productid = 100000

	UPDATE #TempResults
	SET 	attributeid 	= 19,
		productfamilyid = 100001,
		baBasketID	= 0,
		basketattributerowid = 0,
		attributerowid  = (SELECT attributerowid FROM b4nattributeproductfamily WHERE productfamilyid = 100001 AND attributeid = 100),
		displayvalue 	= attributeuservalue,
		attributetypeid = 16,
		basketattributeid = 0,
		attributeName 	= 'Base PRICE',
		attributevalue  = attributeuservalue
	WHERE attributeid = 100
	and productid = 100001

	UPDATE #TempResults
	SET 	attributeid 	= 19,
		productfamilyid = 100002,
		baBasketID	= 0,
		basketattributerowid = 0,
		attributerowid  = (SELECT attributerowid FROM b4nattributeproductfamily WHERE productfamilyid = 100002 AND attributeid = 100),
		displayvalue 	= attributeuservalue,
		attributetypeid = 16,
		basketattributeid = 0,
		attributeName 	= 'Base PRICE',
		attributevalue  = attributeuservalue
	WHERE attributeid = 100
	and productid = 100002

	SELECT DISTINCT * FROM #TempResults
	ORDER BY basketid DESC

	DROP TABLE #TempResults




GRANT EXECUTE ON b4nGetBasketData TO b4nuser
GO
GRANT EXECUTE ON b4nGetBasketData TO helpdesk
GO
GRANT EXECUTE ON b4nGetBasketData TO ofsuser
GO
GRANT EXECUTE ON b4nGetBasketData TO reportuser
GO
GRANT EXECUTE ON b4nGetBasketData TO b4nexcel
GO
GRANT EXECUTE ON b4nGetBasketData TO b4nloader
GO
