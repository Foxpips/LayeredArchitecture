CREATE PROCEDURE b4nOrderTrackingGetPreviousOrderProducts
(
	@OrderRef INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 	60 AS dbid,
			h.storeid AS storeid,
			l.orderlineid AS orderlineid,
			l.orderref AS orderref,
			l.productid AS productid,
			l.itemname AS prd_desc,
			l.quantity AS quantity,
			0 AS unitid,
			l.instructions AS instructions,
			l.price AS price,
			'Item Accepted' AS current_status,
			l.modifydate AS current_status_date,
			'Item Accepted' AS class_desc
	FROM 	b4nOrderline l WITH(NOLOCK)
	INNER JOIN b4nOrderHeader h WITH(NOLOCK) ON l.orderref = h.orderref 
	INNER JOIN h3giOrderheader hoh WITH(NOLOCK) ON h.OrderRef = hoh.orderref
	INNER JOIN h3giProductCatalogue cat WITH(NOLOCK) ON cat.catalogueVersionID = hoh.catalogueVersionID	AND cat.productFamilyId = l.ProductID
	WHERE h.orderref = @Orderref
	AND cat.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT','GIFT')
END
GRANT EXECUTE ON b4nOrderTrackingGetPreviousOrderProducts TO b4nuser
GO
