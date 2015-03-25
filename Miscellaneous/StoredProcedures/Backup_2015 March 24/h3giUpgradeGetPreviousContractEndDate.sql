
CREATE PROCEDURE [dbo].[h3giUpgradeGetPreviousContractEndDate]
	@orderref INT	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select hu.contractEndDate from h3giOrderheader hoh
	left outer join h3giUpgrade hu
		on hoh.UpgradeID = hu.UpgradeId
	where hoh.orderref = @orderref
    
END



GRANT EXECUTE ON h3giUpgradeGetPreviousContractEndDate TO b4nuser
GO
