

/*********************************************************************************************************************
**																					
** Procedure Name	:	Sproc_Name
** Author			:	Simon Markey
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec [threeAdditionalBusinessUpgradeOrderInfoGet] 81727
**********************************************************************************************************************
**				
** Description		:	Gets the address and name of the person who placed an order for use in the out of stock email
**					
**********************************************************************************************************************
**				
** Change Log		:	<Modification date> - <Developer name> - <Description>
**					
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[threeAdditionalBusinessUpgradeOrderInfoGet]
	@orderRef INT
AS
BEGIN
	
DECLARE @parent INT,
@authName VARCHAR(50),
@device VARCHAR(100),
@currCatVersion INT,
@cAdd VARCHAR(255),
@dAdd VARCHAR(255),
@emailAddress VARCHAR(50),
@userEmailAddress VARCHAR(50)

SELECT @currCatVersion = MAX(catalogueVersionId) FROM h3giCatalogueVersion

--Generic Order Information
SELECT @parent = parentId FROM threeOrderUpgradeHeader WHERE orderRef = @orderRef
SELECT @authName = authorisedContact FROM threeOrderUpgradeParentHeader WHERE parentId = @parent
SELECT @cAdd= aptNumber+' '+houseNumber+' '+houseName+' '+street +' '+locality +' '+town  FROM threeOrderUpgradeAddress WHERE parentId = @parent AND addressType = 'Current'
SELECT @dAdd = aptNumber+' '+houseNumber+' '+houseName+' '+street +' '+locality +' '+town  FROM threeOrderUpgradeAddress WHERE parentId = @parent AND addressType = 'Delivery'
SELECT @device = productName FROM h3giProductCatalogue  WHERE catalogueVersionID = @currCatVersion AND catalogueProductID IN(SELECT deviceid FROM threeOrderUpgradeHeader WHERE parentId = @parent)

--Email of the Authorised Contact for the Order
SELECT @emailAddress = emailAddress FROM threeUpgrade WHERE parentBAN IN (SELECT parentBAN FROM threeOrderUpgradeParentHeader WHERE parentId = @parent)

--Email of the Sprint User that Placed the Order
SELECT @userEmailAddress = email from smApplicationUsers where userId in (select userId from threeOrderUpgradeHeader where orderRef = @orderRef)
  

SELECT @authName AS 'authorisedContact',@cAdd AS 'currentAddress',@dAdd AS 'deliveryAddress', @device AS 'device', @emailAddress AS 'emailAddress', @userEmailAddress AS 'userEmailAddress'
END

GRANT EXECUTE ON threeAdditionalBusinessUpgradeOrderInfoGet TO b4nuser
GO
