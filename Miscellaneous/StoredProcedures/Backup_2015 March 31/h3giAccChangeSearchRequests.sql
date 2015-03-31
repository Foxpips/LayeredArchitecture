
CREATE PROCEDURE [dbo].[h3giAccChangeSearchRequests]
        @customerRefNumber INT = NULL,
        @firstName VARCHAR(50) = NULL,
        @surname VARCHAR(50) = NULL,
        @mobileAreaCode VARCHAR(5) = NULL,
        @mobileNumber VARCHAR(7) = NULL,
        @billingAccountNumber VARCHAR(50) = NULL,
        @requestType VARCHAR(15) = NULL,
        @requestDateTo DATETIME = NULL,
        @requestDateFrom DATETIME = NULL
AS
DECLARE @sql nvarchar(MAX),
	@paramlist  nvarchar(4000)

SELECT @sql = 
'BEGIN
	SELECT ''CSR'' + REPLACE(STR(RequestHeaderId,8),'' '',''0'') AS CustomerRefNum,
		Firstname + '' '' + Surname AS CustomerName, 
		MobileAreaCode + MobileNumber AS CustomerMsisdn, 
		t2.Description As RequestType, 
		RequestDate
	FROM h3giAccChangeRequestHeader as t1
	JOIN h3giAccChangeRequestType as t2
		ON t1.RequestTypeId = t2.RequestTypeId
    WHERE 1 = 1'
    
IF @customerRefNumber IS NOT NULL
   SELECT @sql = @sql +
'      AND t1.RequestHeaderId = @customerRefNumber'

IF @firstName IS NOT NULL
   SELECT @sql = @sql +
'      AND t1.FirstName = @firstName'

IF @surname IS NOT NULL
   SELECT @sql = @sql +
'      AND t1.Surname = @surname'

IF @mobileAreaCode IS NOT NULL
    AND @mobileNumber IS NOT NULL
   SELECT @sql = @sql +
'      AND t1.MobileAreaCode = @mobileAreaCode
       AND t1.MobileNumber = @mobileNumber'

IF @billingAccountNumber IS NOT NULL
   SELECT @sql = @sql +
'      AND t1.BAN = @billingAccountNumber'

IF @requestType IS NOT NULL
    SELECT @sql = @sql +
'      AND t2.RequestTypeCode = @RequestType'
    
IF @requestDateTo IS NOT NULL
   SELECT @sql = @sql +
'      AND t1.RequestDate <= @requestDateTo'

IF @requestDateFrom IS NOT NULL
   SELECT @sql = @sql +
'      AND t1.RequestDate >= @requestDateFrom'

SELECT @sql = @sql + 
'    ORDER BY RequestDate ASC
END'

SELECT @paramlist = '@customerRefNumber INT,
					@firstName VARCHAR(50),
					@surname VARCHAR(50),
					@mobileAreaCode VARCHAR(5),
					@mobileNumber VARCHAR(7),
					@billingAccountNumber VARCHAR(50),
					@requestType VARCHAR(15),
					@requestDateTo DATETIME,
					@requestDateFrom DATETIME'

EXEC sp_executesql @sql, @paramlist, @customerRefNumber,
					@firstName, @surname, @mobileAreaCode,
					@mobileNumber, @billingAccountNumber,
					@requestType, @requestDateTo,
					@requestDateFrom 

GRANT EXECUTE ON h3giAccChangeSearchRequests TO b4nuser
GO
