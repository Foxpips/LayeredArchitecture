



-- ======================================================
-- Author:		Stephen Quin
-- Create date: 03/11/2010
-- Description:	Replaces the old h3giGetCreditCardHistory
--				stored proc. The old version was too slow
--				and did a lot of unnecessary error handling
--				and creation of table variables
--
-- Change Control 22/02/2012: Simon Markey
--					Added check for Accessory orders
--					to allow them to display in histroy
--
--				  01/03/2012: Simon Markey
--				  Changed to order by order ref in desc order
-- ======================================================
CREATE PROCEDURE [dbo].[h3giGetCreditCardHistory]
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @ccNumber VARCHAR(100)
    DECLARE @aptNumber VARCHAR(50)
    DECLARE @houseNumber VARCHAR(50)
    DECLARE @houseName VARCHAR(50)
    
	SELECT @ccNumber = ISNULL(ccNumber,'') FROM b4norderheader WHERE orderref = @orderref
	
	IF (@ccNumber != '')
	BEGIN
		SELECT  b4nHeader.orderref, 
				b4nHeader.deliveryForename + ' ' + b4nHeader.deliverySurname AS customerName,
				dbo.fn_FormatAddress(
					ISNULL(dbo.fnSingleSplitter2000(b4nHeader.deliveryAddr1,'<!!-!!>',1),''),
					ISNULL(dbo.fnSingleSplitter2000(b4nHeader.deliveryAddr1,'<!!-!!>',2),''),
					ISNULL(dbo.fnSingleSplitter2000(b4nHeader.deliveryAddr1,'<!!-!!>',3),''),
					b4nHeader.deliveryAddr2,
					b4nHeader.deliveryAddr3,
					ISNULL(b4nHeader.deliveryCity,''),
					b4nHeader.deliveryCounty,
					b4nHeader.deliveryCountry,
					ISNULL(b4nHeader.deliveryPostCode,'')) AS billingAddress,				
				CASE WHEN b4nHeader.status IN (500,501,502,505,506,600,601,602,603,604,605) THEN codes.b4nClassExplain ELSE codes.b4nClassDesc END AS status, 
				b4nHeader.orderDate,
				CASE h3giHeader.orderType
					WHEN 0 THEN 'Contract'
					WHEN 1 THEN 'Prepay'
					WHEN 2 THEN 'Contract Upgrade'
					WHEN 3 THEN 'Prepay Upgrade'
					WHEN 4 THEN 'Accessory'
				END AS prepay,
				ISNULL (bcc.b4nClassDesc, '') AS CreditDecision
		FROM	b4nOrderHeader b4nHeader
				INNER JOIN b4nClassCodes codes 
					ON codes.b4nclasscode = CAST(b4nHeader.status AS VARCHAR(10)) 
					AND codes.b4nclasssysid = 'statuscode'
				INNER JOIN h3giOrderHeader h3giHeader 
					ON b4nHeader.orderRef = h3giHeader.orderRef				
				INNER JOIN h3giProductCatalogue catalogue 
					ON h3giHeader.catalogueVersionID = catalogue.catalogueVersionID 					
				INNER JOIN b4nOrderLine line 
					ON b4nHeader.orderref = line.orderref
					AND catalogue.productFamilyID = line.productID
				LEFT OUTER JOIN b4nClassCodes bcc
					ON bcc.b4nClassSysID = 'DecisionCode'
					AND bcc.b4nClassCode = h3giHeader.decisionCode
		WHERE	b4nHeader.ccNumber =  @ccNumber
			AND b4nHeader.orderref != @orderref
			 AND (catalogue.productType = 'HANDSET' OR catalogue.productType = 'ACCESSORY')
		ORDER BY b4nHeader.OrderRef DESC
	END
	
END






GRANT EXECUTE ON h3giGetCreditCardHistory TO b4nuser
GO
