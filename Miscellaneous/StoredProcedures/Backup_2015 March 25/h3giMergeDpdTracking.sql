
CREATE PROC [dbo].[h3giMergeDpdTracking]
AS
BEGIN
	MERGE h3giDpdTracking  AS dest
	USING h3giDpdTrackingTemp AS temp
	ON (dest.orderRef = temp.orderRef)
	WHEN MATCHED 
		THEN UPDATE 
		SET dest.dpdRef = temp.dpdRef, dest.timeStamp = temp.timeStamp, dest.surname = temp.surname
	WHEN NOT MATCHED
		THEN INSERT (orderRef, dpdRef, timeStamp, surname)
		VALUES (temp.orderRef, temp.dpdRef, temp.timeStamp, surname);
	
	DELETE FROM h3giDpdTrackingTemp
END
