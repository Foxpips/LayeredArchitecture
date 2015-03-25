
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCheckICCID
** Author			:	Niall Carroll
** Date Created		:	
** Version			:	1.2.0
**					
**********************************************************************************************************************
**				
** Description		:	Validates an ICCID
						-- @Result = 0: ICCID matches record in lookup and not already used
						-- @Result = 1: ICCID already in DB
						-- @Result = 2: ICCID not in lookup table
						-- @Result = 3: ICCID is the wrong payment option
						-- @Result = 4: MSISDN provided was not valid
**					
**********************************************************************************************************************
**									
** Change Control	:	19 Aug 2005 - Checks h3giICCID lookup table to ensure ICCID is preprovisioned
**						20 Feb 2006 - Add check against new prepay field
**						30 Mar 2006 - Allowing for MSISDN to be used instead of the ICCID
**						23 July 2013 - Setting the correct value for @Prepay when order is Contract Upgrade
**********************************************************************************************************************/
CREATE PROC [dbo].[h3giCheckICCID]
(
	@CheckText varchar(30),
	@Prepay bit = 0,
	@OrderRef int = 0,
	@ProductID int = 0
)
AS 
BEGIN
	DECLARE @OrderType INT = 0
	DECLARE @Count 	int
	DECLARE @Result int
	DECLARE @ICCID varchar(30)
	DECLARE @Kitted bit

	IF @OrderRef <> 0
			SELECT 
	  @Kitted = handset.Kitted 
	FROM    dbo.h3giOrderheader AS h3giHeader WITH (nolock)  
	JOIN dbo.h3giProductCatalogue AS handset WITH (nolock)   
	   ON h3giHeader.catalogueVersionID = handset.catalogueVersionID   
	   AND CONVERT(varchar(20), handset.productFamilyId) = h3giHeader.phoneProductCode  
	   AND handset.productType = 'HANDSET' 
	   WHERE OrderRef = 0

	IF @ProductID <> 0
		SELECT top 1 @Kitted = Kitted, @OrderType = Prepay FROM h3giProductCatalogue with(nolock) WHERE catalogueProductID IN
			(SELECT attributeValue FROM b4nAttributeProductFamily with(nolock) WHERE productFamilyId = @ProductID AND attributeID = 303)
		AND ValidStartDate < GetDate() AND GetDate() < ValidEndDate
		ORDER BY catalogueVersionID DESC

	IF @Kitted = 1
	BEGIN 
		IF EXISTS (SELECT ICCID FROM h3giICCID WHERE MSISDN = @CheckText)
		BEGIN
			SELECT @ICCID = ICCID FROM h3giICCID WHERE MSISDN = @CheckText
		END
		ELSE
		BEGIN
			SET @Result = 4
			GOTO RESULT
		END	
	END
	ELSE
	BEGIN
		SET @ICCID = @CheckText
	END


	SELECT @Count = count(ICCID) FROM h3giOrderHeader with(nolock) 
	where (ICCID = @ICCID)

	SELECT @count = @count + count(ICCID) FROM threeOrderItem with(nolock) 
	where (ICCID = @ICCID)

	SET @Result = 0

	-- Already Used
	If @Count > 0 
	BEGIN 
		SET @Result = 1
		GOTO RESULT
	END
	-- Not found
	If NOT EXISTS (SELECT ICCID FROM h3giICCID with(nolock) WHERE ICCID = @ICCID OR ICCID + 'F' = @ICCID)
	BEGIN 
		SET @Result = 2
		GOTO RESULT
	END

	IF @OrderType = 0 OR @OrderType = 2
		-- Contract, Contract Upgrade, Business Upgrade
		SET @Prepay = 0
	ELSE
		-- Prepay, Prepay Upgrade, Accessory
		SET @Prepay = 1

	-- Wrong payment type
	If NOT EXISTS 
		(SELECT ICCID FROM h3giICCID with(nolock) WHERE (ICCID = @ICCID OR ICCID + 'F' = @ICCID) AND [PrePay] = @Prepay)
	BEGIN 
		SET @Result = 3
		GOTO RESULT
	END

	RESULT:
	SELECT @Result as Result
END
GRANT EXECUTE ON h3giCheckICCID TO b4nuser
GO
