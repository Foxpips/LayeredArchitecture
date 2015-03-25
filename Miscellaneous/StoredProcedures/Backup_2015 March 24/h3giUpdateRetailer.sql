     /*********************************************************************************************************************  
**                       
** Procedure Name : h3giUpdateRetailer  
** Author  : Peter Murphy  
** Date Created  : 22/09/06  
**       
**********************************************************************************************************************  
**      
** Description  : This stored procedure updates a retailer  
**       
**********************************************************************************************************************  
**           
** Change Control : 1.0.0 - 22/09/06 - Initial version  
**    1.1.0 - 23/02/07 - Adam Jasinski - @channelCode is a variable now;  
**	  05/06/2009 - added @RetailerName so they can change the namne - johno
**********************************************************************************************************************/  
  
  
CREATE PROCEDURE dbo.h3giUpdateRetailer  
  
@RetailerCode varchar(20),  
@RetailerName varchar(50),
@GroupID int,  
@Internal varchar(3),  
@DistCode varchar(20)  
  
as  
  
DECLARE @ErrorCode int  
DECLARE @ErrorCount int  
DECLARE @RecFound int  
DECLARE @channelCode varchar(20)  
  
SET @ErrorCount = 0  
  
--Get the retailer channel  
SELECT @channelCode = channelCode FROM h3giRetailer  
WHERE retailerCode = @RetailerCode  
  
BEGIN TRAN  
--Update the retailer record  
update 
	h3giRetailer 
set 
	DistributorCode = @DistCode, 
	retailerName = @RetailerName
where 
	retailerCode = @RetailerCode  
  
SET @ErrorCode = @@ERROR  
IF @ErrorCode > 0   
BEGIN   
 set @ErrorCount = @ErrorCount + 1  
END  
  
  
--Get rid of current SMSGroup and Internal records  
delete from h3giSMSGroupDetail  
where groupid = @GroupID  
and retailercode = @RetailerCode  
and channelCode = @channelCode  
  
SET @ErrorCode = @@ERROR  
IF @ErrorCode > 0   
BEGIN   
 set @ErrorCount = @ErrorCount + 1  
END  
  
delete from h3giInternalRetailerCodes where retailerCode = @RetailerCode  
  
SET @ErrorCode = @@ERROR  
IF @ErrorCode > 0   
BEGIN   
 set @ErrorCount = @ErrorCount + 1  
END  
--------------------------------------------------  
  
  
IF (@Internal = 'No')  
BEGIN  
 --Add an SMSGroupDetail record  
 INSERT INTO h3giSMSGroupDetail (groupid, retailerCode, channelCode)  
 values(@GroupID, @RetailerCode, @channelCode)  
  
 SET @ErrorCode = @@ERROR  
 IF @ErrorCode > 0   
 BEGIN   
  set @ErrorCount = @ErrorCount + 1  
 END  
END  
ELSE  
BEGIN  
 --Add and InternalRetailerCodes record  
 INSERT INTO h3giInternalRetailerCodes (retailerCode)  
 values(@RetailerCode)  
  
 SET @ErrorCode = @@ERROR  
 IF @ErrorCode > 0  
 BEGIN  
  set @ErrorCount = @ErrorCount + 1  
 END  
END  
  
  
If @ErrorCount > 0  
BEGIN   
 ROLLBACK TRAN  
 return 1  
END  
ELSE  
BEGIN  
 COMMIT TRAN  
 return 0  
END  
  
  
  
GRANT EXECUTE ON h3giUpdateRetailer TO b4nuser
GO
GRANT EXECUTE ON h3giUpdateRetailer TO reportuser
GO
