

-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 15-July-2013
-- Description:	Gets all the insurance packages that are available for a certain order.
-- =============================================
CREATE PROCEDURE [dbo].[h3giInsuranceGetPackagesForOrder]
(
	@orderRef	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT ip.Id, ip.Name, ip.MonthlyPrice, ip.AnnualPrice, ip.Description
	FROM h3giOrderheader h

	INNER JOIN h3giProductCatalogue pc
	ON pc.catalogueVersionID = h.catalogueVersionID AND pc.productFamilyId = h.phoneProductCode

	INNER JOIN h3giInsurancePolicyDevice
	ON h3giInsurancePolicyDevice.PeopleSoftId = pc.peoplesoftID

	INNER JOIN h3giInsurancePolicy ip
	ON ip.Id = h3giInsurancePolicyDevice.InsurancePolicyId

	WHERE ip.Deleted = 0 AND h.orderref = @orderRef
END


GRANT EXECUTE ON h3giInsuranceGetPackagesForOrder TO b4nuser
GO
