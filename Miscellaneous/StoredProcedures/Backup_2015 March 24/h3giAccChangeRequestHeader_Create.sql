

CREATE PROCEDURE [dbo].[h3giAccChangeRequestHeader_Create] 
@requestType VARCHAR(50),
@title VARCHAR(50),
@firstname VARCHAR(50),
@surname VARCHAR(50),
@ban VARCHAR(50),
@mobileAreaCode VARCHAR(5),
@mobileNumber VARCHAR(7),
@altAreaCode VARCHAR(5),
@altNumber VARCHAR(10),
@accountType VARCHAR(50),
@salesAssociateId VARCHAR(50),
@channelCode VARCHAR(50),
@storeCode VARCHAR(50),
@retailerCode VARCHAR(50),
@requestHeaderId INT OUTPUT,
@CSRAgentId INT
AS
BEGIN

	DECLARE @requestTypeId INT

    SELECT @requestTypeId = RequestTypeId
        FROM [dbo].[h3giAccChangeRequestType]
    WHERE RequestTypeCode = @requestType
        
	INSERT INTO [dbo].[h3giAccChangeRequestHeader]
			(RequestTypeId
			,Title
			,Firstname
			,Surname
			,BAN
			,MobileAreaCode
			,MobileNumber
			,AltAreaCode
			,AltNumber
			,AccountType
			,SalesAssoiciateId
			,ChannelCode
            ,StoreCode
            ,RetailerCode
			,RequestDate
			,Status
			,CSRAgentId)
		VALUES
			(@requestTypeId
			,@title
			,@firstname
			,@surname
			,@ban
			,@mobileAreaCode
			,@mobileNumber
			,@altAreaCode
			,@altNumber
			,@accountType
			,@SalesAssociateId
            ,@channelCode
            ,@storeCode
            ,@retailerCode
			,GETDATE()
			,'801'
			,@CSRAgentId)
END

SET @requestHeaderId = @@IDENTITY

GRANT EXECUTE ON h3giAccChangeRequestHeader_Create TO b4nuser
GO
