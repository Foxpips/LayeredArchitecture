CREATE PROCEDURE b4nOrderTrackingGetPreviousOrder
(
	@OrderRef INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	h.orderref AS orderref,
			h.orderdate AS orderdate,
			os.customerDescription AS current_status,
			(GETDATE()) AS current_status_date,
			os.customerDescription AS class_desc,
			NULL AS courierTrackingID,
			NULL AS CourierTrackingLink,
			h.Status AS status,
			ISNULL(dpd.dpdRef,'') as dpdRef
	FROM h3gi..b4nOrderHeader h WITH (NOLOCK)
	INNER JOIN h3gi..h3giOrderTrackingStatus os WITH(NOLOCK) ON h.status = os.statusValue
	LEFT OUTER JOIN h3gi..h3giDpdTracking dpd on h.orderref = dpd.orderRef
	WHERE h.orderref = @orderref
END
GRANT EXECUTE ON b4nOrderTrackingGetPreviousOrder TO b4nuser
GO
