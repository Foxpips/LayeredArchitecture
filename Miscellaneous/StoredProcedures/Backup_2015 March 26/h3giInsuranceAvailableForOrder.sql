

-- ==========================================================================
-- Author:		Stephen Quin
-- Create date: 12/07/13
-- Description:	Determines whether or not insurance is available for a device
--				associated with a specific orderRef
-- ==========================================================================
CREATE PROCEDURE [dbo].[h3giInsuranceAvailableForOrder] 
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @peopleSoftId VARCHAR(10)
    
    SELECT @peopleSoftId = cat.peoplesoftID
    FROM h3giOrderheader head
    INNER JOIN h3giProductCatalogue cat
		ON head.catalogueVersionID = cat.catalogueVersionID
		AND head.phoneProductCode = cat.productFamilyId
	WHERE head.orderref = @orderRef
		
	IF EXISTS (		
		SELECT * FROM h3giInsurancePolicyDevice
		
		INNER JOIN h3giInsurancePolicy ip
		ON ip.Id = h3giInsurancePolicyDevice.InsurancePolicyId
		
		WHERE ip.Deleted = 0 AND PeopleSoftId = @peopleSoftId		
	)
	RETURN 1
	ELSE
	RETURN 0
    
END


GRANT EXECUTE ON h3giInsuranceAvailableForOrder TO b4nuser
GO
