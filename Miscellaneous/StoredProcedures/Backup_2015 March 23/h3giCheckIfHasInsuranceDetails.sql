



-- ============================================================
-- Author:		Stephen King
-- Create date: 20/11/2013
-- Description:	Checks whether the data from peir has been saved
-- ============================================================
CREATE PROCEDURE [dbo].[h3giCheckIfHasInsuranceDetails]
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if exists (select * from  h3giOrderInsurancePierCase pierCase inner join h3giorderinsurance hoi on hoi.orderRef = @orderRef)
		select 1
	else
		select 0
END


GRANT EXECUTE ON h3giCheckIfHasInsuranceDetails TO b4nuser
GO
