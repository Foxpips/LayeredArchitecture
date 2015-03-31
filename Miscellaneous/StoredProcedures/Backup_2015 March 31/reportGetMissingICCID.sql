CREATE procedure [dbo].[reportGetMissingICCID]
AS
BEGIN
SELECT     hoh.orderref, boh.OrderDate
FROM         h3giOrderheader AS hoh INNER JOIN
                      b4nOrderLine AS bol ON hoh.orderref = bol.OrderRef INNER JOIN
                      b4nOrderHeader AS boh ON hoh.orderref = boh.OrderRef INNER JOIN
                      h3giProductCatalogue AS pc ON hoh.catalogueVersionID = pc.catalogueVersionID AND bol.ProductID = pc.productFamilyId
WHERE     (hoh.ICCID = '') AND (bol.gen6 IN (0,1))
AND pc.productType = 'HANDSET'
AND EXISTS (SELECT * FROM h3gi_gm..gmLineItemHistory gmLineHist
			INNER JOIN h3gi_gm..gmOrderHeader gmHeader
			ON gmLineHist.orderHeaderId = gmHeader.orderHeaderId
			WHERE gmHeader.orderref = hoh.orderref
			AND gmLineHist.statusID = 29)
and orderDate > dateadd(dd,-1,getdate())
ORDER BY hoh.orderref





END
GRANT EXECUTE ON reportGetMissingICCID TO b4nuser
GO
