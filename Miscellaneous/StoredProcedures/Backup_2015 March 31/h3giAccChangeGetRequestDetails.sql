

CREATE PROCEDURE [dbo].[h3giAccChangeGetRequestDetails]
@refNumber INT
AS
BEGIN
    SELECT 
	t1.RequestHeaderId,
    t1.RequestTypeId,
    t1.Title,
    t1.Firstname,
    t1.Surname,
    t1.BAN,
    t1.MobileAreaCode,
    t1.MobileNumber,
    t1.AltAreaCode,
    t1.AltNumber,
    t1.AccountType,
    t1.SalesAssoiciateId,
    t1.ChannelCode,
    t1.StoreCode,
    t1.RetailerCode,
    t1.RequestDate,
    t1.Status,
    t1.Notes,
    t1.CSRAgentId,
    t2.RequestTypeId,
    t2.RequestTypeCode,
    t2.Description,
    t2.Enabled,
    t2.RetailerNotes,
    t3.b4nClassSysID,
    t3.b4nClassCode,
    t3.b4nClassDesc,
    t3.b4nValid,
    t3.b4nClassExplain,
    sm.nameOfUser FROM h3giAccChangeRequestHeader AS t1  
    JOIN h3giAccChangeRequestType AS t2  
    ON t1.RequestTypeId = t2.RequestTypeId  
    JOIN b4nClassCodes AS t3  
    ON t1.Status = t3.b4nClassCode  
    LEFT OUTER JOIN smApplicationUsers sm
    ON t1.CSRAgentId = sm.userId
    WHERE RequestHeaderId = @refNumber  
    
	SELECT Name, ISNULL(VarCharMaxVal, IntVal) AS Value
	FROM h3giAccChangeRequestFields AS t3
	JOIN h3giAccChangeFieldType AS t4
	ON t3.FieldTypeId = t4.FieldTypeId
	WHERE RequestHeaderId = @refNumber
	AND Name != 'hasSepa'
END



GRANT EXECUTE ON h3giAccChangeGetRequestDetails TO b4nuser
GO
