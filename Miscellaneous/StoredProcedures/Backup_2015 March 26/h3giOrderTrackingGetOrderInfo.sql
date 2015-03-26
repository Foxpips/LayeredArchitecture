-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 30/09/2014
-- Description:	
-- =============================================
CREATE PROCEDURE h3giOrderTrackingGetOrderInfo
(
	@OrderRef INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	h.orderref,
			h.orderdate,
			os.customerDescription AS current_status,
			(GETDATE()) AS current_status_date,
			os.customerDescription AS class_desc,
			NULL AS courierTrackingID,
			NULL AS CourierTrackingLink,
			h.Status AS status,
			h.billingsurname
	FROM b4nOrderHeader h WITH (NOLOCK)
	INNER JOIN h3giOrderTrackingStatus os WITH(NOLOCK) ON h.status = os.statusValue
	WHERE h.orderref = @orderref
END
GRANT EXECUTE ON h3giOrderTrackingGetOrderInfo TO b4nuser
GO
