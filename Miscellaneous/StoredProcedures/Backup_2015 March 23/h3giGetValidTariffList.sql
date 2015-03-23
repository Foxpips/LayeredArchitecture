

CREATE  PROCEDURE [dbo].[h3giGetValidTariffList] AS

select ppp.peoplesoftID, ppp.pricePlanID  from h3gipriceplanpackage ppp 
INNER JOIN h3gicatalogueversion cv
	ON cv.catalogueversionid = ppp.catalogueversionid
where ppp.valid = 'Y' AND cv.activeCatalog = 'Y'


GRANT EXECUTE ON h3giGetValidTariffList TO b4nuser
GO
GRANT EXECUTE ON h3giGetValidTariffList TO ofsuser
GO
GRANT EXECUTE ON h3giGetValidTariffList TO reportuser
GO
