
/** h3giAccChangeGetRequestQueue **/
/** Created: Stephen Mooney **/
/** Edit: Stephen Mooney, 12 April 11, Add lock column, Add DealerCode column **/

CREATE PROCEDURE [dbo].[h3giAccChangeGetRequestQueue]
@status varchar(50)
AS
BEGIN
	SELECT 'CSR' + REPLACE(STR(RequestHeaderId,8),' ','0') AS CustomerRefNum,
	    t1.RetailerCode AS DealerCode,
		Firstname + ' ' + Surname AS CustomerName, 
		MobileAreaCode + MobileNumber AS CustomerMsisdn, 
		t2.Description As RequestType, 
		RequestDate,
		CASE WHEN RequestDate < DATEADD(HH,-1,GETDATE())
			THEN 1
			ELSE 0
		END AS ExceedingSLA,
		CASE WHEN hl.LockID IS NOT NULL
			THEN 1
			ELSE 0
		END AS Lock
	FROM h3giAccChangeRequestHeader as t1
	JOIN h3giAccChangeRequestType as t2
		ON t1.RequestTypeId = t2.RequestTypeId
	LEFT OUTER JOIN h3giLock hl
		ON RequestHeaderId = hl.OrderID
		AND hl.TypeID = 3
    WHERE t1.Status = @status
    ORDER BY RequestDate ASC
END



GRANT EXECUTE ON h3giAccChangeGetRequestQueue TO b4nuser
GO
