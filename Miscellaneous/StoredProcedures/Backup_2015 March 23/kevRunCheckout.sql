

/****** Object:  Stored Procedure dbo.kevRunCheckout    Script Date: 23/06/2005 13:35:27 ******/

CREATE Proc kevRunCheckout
AS

Begin 


/*START OF DIAGNOSTIC CODE*/
Delete from b4nbasketattribute
Where basketid in (select basketid from b4nbasket where customerid = 160061)

Delete from b4nbasket 
Where customerid = 160061

Insert into b4nbasket(customerid,storeid,productid,quantity,createDate,modifyDate,giftWrappingTypeId)
Select 160061,1,846,1.0,getdate(),getdate(),''

Insert into b4nbasketattribute(basketid,attributeid,attributerowid,attributeUserValue)
Select basketid,4,137055,'' from b4nbasket where customerid = 160061

DECLARE kevCursor INSENSITIVE CURSOR 
FOR
SELECT * FROM kevstable

-- Open OrderLineCursor
OPEN kevCursor

-- Cursor Variables
Declare	@nOrderID 		INT
Declare	@nStoreID 		INT
Declare	@nCustomerID 		INT
Declare @nStatus 		INT
Declare	@billingForeName 	VARCHAR(100)
Declare	@billingSurName 	VARCHAR(100)  
Declare @billingHouseName 	VARCHAR(100) 	 
Declare @billingAddr1 		VARCHAR(255)	 
Declare @billingAddr2  		VARCHAR(255) 	 
Declare @billingAddr3  		VARCHAR(100) 	 
Declare @billingCountry  	VARCHAR(100) 	 
Declare @billingCounty  	VARCHAR(100) 	 
Declare @billingPostCode 	VARCHAR(16) 	 
Declare @billingTelephone 	VARCHAR(100) 	 
Declare @billingMobile  	VARCHAR(100) 	 
Declare @billingCountryID 	INT
Declare @billingSubCountryID 	INT
Declare @deliveryForeName  	VARCHAR(100) 	 
Declare @deliverySurName   	VARCHAR(100) 	 
Declare @deliveryHouseName 	VARCHAR(100) 	 
Declare @deliveryAddr1  	VARCHAR(255) 	 
Declare @deliveryAddr2  	VARCHAR(255) 	 
Declare @deliveryAddr3  	VARCHAR(100) 	 
Declare @deliveryCountry  	VARCHAR(100) 	 
Declare @deliveryCounty  	VARCHAR(100) 	 
Declare @deliveryPostcode  	VARCHAR(16) 	 
Declare @deliveryTelephone  	VARCHAR(100) 	 
Declare @deliveryMobile  	VARCHAR(100) 	 
Declare @deliverySubCountryID 	INT
Declare @deliveryCountryID 	INT
Declare @deliveryDetail  	VARCHAR(50) 	 
Declare @deliverySlotID 	INT
Declare @dDeliveryDate 		DATETIME 	 
Declare @deliveryNote 		varchar(200) 		 
Declare @deliveryGiftNote 	varchar(200) 		 
Declare @nGoodsPrice 		REAL
Declare @nDeliveryCharge 	REAL
Declare @strEmail 		VARCHAR(255) 	 
Declare @strLoyalty  		VARCHAR(20) 	 
Declare @ccNumber 		VARCHAR(255) 	 
Declare @ccExpiryDate 		DATETIME 	 
Declare @ccTypeID 		INT
Declare @ccIssueNumber 		CHAR(10) 	 
Declare @strSecurityCode 	VARCHAR(10) 	 
Declare @nSubPolicy 		SMALLINT
Declare @nCustomerDiscount 	FLOAT
Declare @strDiscountDescription VARCHAR(4000) 	 
Declare @strVoucherCode		VARCHAR(50) 	  
Declare @nZoneId		INT
Declare @delDocketType   	VARCHAR(10) 	 
Declare @referer   		VARCHAR(2) 	 
Declare @discount 		REAL
Declare @voucherCode 		VARCHAR(10) 	 
Declare @nAreaStoreId 		INT
Declare @strClientInfo 		VARCHAR(255)
Declare @storeLocationId 	INT
Declare @Affiliate		varchar(255)	 
Declare @linkType		INT


-- Fetch First Row from OrderLine Cursor				
FETCH NEXT FROM kevCursor INTO @nOrderID,
	@nStoreID 		,	@nCustomerID 		,	@nStatus 		,	@billingForeName 	,
	@billingSurName 	,	@billingHouseName 	,	@billingAddr1 		,	@billingAddr2  		,
	@billingAddr3  		,	@billingCountry  	,	@billingCounty  	,	@billingPostCode  	,
	@billingTelephone  	,	@billingMobile  	,	@billingCountryID 	,	@billingSubCountryID 	,
	@deliveryForeName   	,	@deliverySurName   	,	@deliveryHouseName  	,	@deliveryAddr1  	,
	@deliveryAddr2  	,	@deliveryAddr3  	,	@deliveryCountry  	,	@deliveryCounty  	,
	@deliveryPostcode  	,	@deliveryTelephone  	,	@deliveryMobile  	,	@deliverySubCountryID 	,
	@deliveryCountryID 	,	@deliveryDetail  	,	@deliverySlotID 	,	@dDeliveryDate 		,
	@deliveryNote 		,	@deliveryGiftNote 	,	@nGoodsPrice 		,	@nDeliveryCharge 	,
	@strEmail 		,	@strLoyalty  		,	@ccNumber 		,	@ccExpiryDate		,
	@ccTypeID 		,	@ccIssueNumber 		,	@strSecurityCode	,	@nSubPolicy		,
	@nCustomerDiscount	,	@strDiscountDescription ,	@strVoucherCode		,	@nZoneId		,	
	@delDocketType  	,	@referer   		,	@discount 		,	@voucherCode 		,	
	@nAreaStoreId 		,	@strClientInfo		,	@storeLocationId	,	@Affiliate		,	
	@linkType
		
CLOSE kevCursor
DEALLOCATE kevCursor

End






GRANT EXECUTE ON kevRunCheckout TO b4nuser
GO
GRANT EXECUTE ON kevRunCheckout TO helpdesk
GO
GRANT EXECUTE ON kevRunCheckout TO ofsuser
GO
GRANT EXECUTE ON kevRunCheckout TO reportuser
GO
GRANT EXECUTE ON kevRunCheckout TO b4nexcel
GO
GRANT EXECUTE ON kevRunCheckout TO b4nloader
GO
