

CREATE PROCEDURE [dbo].[h3giAlertPrepayOrderWithContractPhone]
AS
SET NOCOUNT ON
select line.OrderRef from b4nOrderLine line where OrderRef in 
(
	select orderref from h3giOrderheader h where h.pricePlanPackageID = 11
) 
and line.ProductID in 
(
	select cat.catalogueProductID from h3giProductCatalogue cat 
	where productType = 'HANDSET'
	and catalogueVersionID = 83
	and PrePay = 0
)
and line.OrderLineID > 2159527





GRANT EXECUTE ON h3giAlertPrepayOrderWithContractPhone TO b4nuser
GO
