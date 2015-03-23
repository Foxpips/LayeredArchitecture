
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 26-July-2013
-- Description:	Gets the customer details for certain order.
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetOrderCustomerDetails]
(
	@OrderRef	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS(SELECT TOP 1 * FROM h3giRegistration WHERE orderref = @OrderRef)
	BEGIN	
		SELECT  
		cc.b4nClassCode as title,  
		firstname AS forename,  
		surname,  
		email AS Email,    
		homeLandlineAreaCode AS homePhoneAreaCode,  
		homeLandlineNumber AS homePhoneNumber,  
		daytimeContactAreaCode,  
		daytimeContactNumber,
		
		'' AS currentAptNumber,  
		addrHouseNumber AS currentHouseNumber,  
		addrHouseName AS currentHouseName,  
		addrStreetName   AS currentStreet,  
		addrLocality   AS currrentLocality,  
		addrTownCity   AS currentCity,  
		0 AS currentCountyCode,
		addrCounty AS currentCountyValue,
		addrCountry   AS currentCountry
	  
		FROM h3giRegistration

		INNER JOIN b4nClassCodes cc
		ON cc.b4nClassSysID = 'CustomerTitle' AND cc.b4nClassDesc = h3giRegistration.title

		WHERE orderref = @OrderRef
	END
	ELSE
	BEGIN
		SELECT  
		h3g.title,  
		B4N.BillingForeName AS forename,  
		B4N.BillingSurName AS surname,  
		B4N.Email,    
		h3g.homePhoneAreaCode,  
		h3g.homePhoneNumber,  
		h3g.daytimeContactAreaCode,  
		h3g.daytimeContactNumber,
		
		h3g.billingAptNumber AS currentAptNumber,  
		h3g.billingHouseNumber AS currentHouseNumber,  
		h3g.billingHouseName AS currentHouseName,  
		B4N.billingAddr2   AS currentStreet,  
		B4N.billingAddr3   AS currrentLocality,  
		B4N.billingCity   AS currentCity,  
		B4N.billingSubCountryID AS currentCountyCode,
		'' AS currentCountyValue,
		B4n.billingCountry   AS currentCountry
	  
		FROM b4nOrderHeader B4N   

		INNER JOIN h3giOrderHeader H3G 
		ON B4N.OrderRef = H3G.OrderRef

		WHERE H3G.orderref = @OrderRef		
	END
END

GRANT EXECUTE ON h3giGetOrderCustomerDetails TO b4nuser
GO
