


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCreateRetailer
** Author		:	Peter Murphy
** Date Created		:	24/02/06
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure creates a retailer
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - 24/02/06 - Initial version
**				1.0.1 - 10/04/06 - Peter Murphy - Added option for Internal Yes/No
**				1.0.2 - 14/08/06 - Peter Murphy - Take handsets from top retailer, not web
**				1.0.3 - 22/09/06 - Peter Murphy - Add distributor code to h3giretailer
**				1.1.0 - 23/02/07 - Adam Jasinski - Add @channelCode parameter; 
								   Changed MAX(catalogueversionId) to dbo.fn_GetActiveCatalogueVersion()
**				1.1.1 - 20/03/07 - Adam Jasinski - Amended retailerCode length in temporary tables		
**						10/01/11 - Stephen Quin - Added check for affinity groups
**********************************************************************************************************************/


CREATE PROCEDURE [dbo].[h3giCreateRetailer]

@RetailerCode VARCHAR(20),
@RetailerName VARCHAR(50),
@GroupID INT,
@Internal VARCHAR(3),
@DistCode VARCHAR(20),
@channelCode VARCHAR(20)

AS

DECLARE @ErrorCode INT
DECLARE @ErrorCount INT
DECLARE @RecFound INT

SET @ErrorCount = 0


SELECT @RecFound = COUNT(*) FROM h3giRetailer WHERE h3giRetailer.retailerName = @RetailerName
IF @RecFound > 0
BEGIN
	RETURN 2
END

SELECT @RecFound = COUNT(*) FROM h3giRetailer WHERE h3giRetailer.retailerCode = @RetailerCode
IF @RecFound > 0
BEGIN
	RETURN 3
END


BEGIN TRAN
--Create the actual retailer record
INSERT INTO h3giRetailer (retailerCode, channelCode, retailerName, DistributorCode)
VALUES(@RetailerCode ,@channelCode, @RetailerName, @DistCode)

SET @ErrorCode = @@ERROR
IF @ErrorCode > 0 
BEGIN 
	SET @ErrorCount = @ErrorCount + 1
END


--Create new handsets for the retailer
CREATE TABLE #HandsetTable (HandsetCount INT, retailerCode VARCHAR(20))
DECLARE @TempRetailer VARCHAR(20)
SET @TempRetailer = ''

INSERT INTO #HandsetTable
SELECT COUNT(*) AS HandsetCount, retailercode FROM h3giretailerhandset 
WHERE catalogueversionid = dbo.fn_GetActiveCatalogueVersion()
AND channelcode = @channelCode
GROUP BY retailercode

SELECT @TempRetailer = retailerCode FROM #HandsetTable
		WHERE retailerCode IN 
			(SELECT TOP 1 retailerCode FROM #HandsetTable ORDER BY HandsetCount DESC)

DROP TABLE #HandsetTable

IF(@TempRetailer != '')
BEGIN
	INSERT INTO h3giRetailerHandset (channelCode, retailerCode, catalogueVersionID, catalogueProductID)
	SELECT @channelCode, @RetailerCode, catalogueVersionID, catalogueProductID FROM dbo.h3giRetailerHandset 
	WHERE retailerCode = @TempRetailer
	AND channelCode = @channelCode
END



SET @ErrorCode = @@ERROR
IF @ErrorCode > 0 
BEGIN 
	SET @ErrorCount = @ErrorCount + 1
END


IF (@Internal = 'No')
BEGIN
	--Add an SMSGroupDetail record
	INSERT INTO h3giSMSGroupDetail (groupid, retailerCode, channelCode)
	VALUES(@GroupID, @RetailerCode, @channelCode)

	SET @ErrorCode = @@ERROR
	IF @ErrorCode > 0 
	BEGIN 
		SET @ErrorCount = @ErrorCount + 1
	END
END
ELSE
BEGIN
	--Add and InternalRetailerCodes record
	INSERT INTO h3giInternalRetailerCodes (retailerCode)
	VALUES(@RetailerCode)

	SET @ErrorCode = @@ERROR
	IF @ErrorCode > 0
	BEGIN
		SET @ErrorCount = @ErrorCount + 1
	END
END

--check for affinity groups
IF EXISTS (SELECT * FROM h3giAffinityRetailers WHERE channelCode = @channelCode AND retailerCode = '' AND storeCode = '')
BEGIN
	INSERT INTO h3giAffinityRetailers
	SELECT	affinityGroupId,
			@channelCode,
			@RetailerCode,
			''
	FROM	h3giAffinityRetailers
	WHERE	channelCode = @channelCode
		AND retailerCode = ''
		AND storeCode = ''
		
	SET @ErrorCode = @@ERROR
	IF @ErrorCode > 0
	BEGIN
		SET @ErrorCount = @ErrorCount + 1
	END
END


IF @ErrorCount > 0
BEGIN 
	ROLLBACK TRAN
	RETURN 1
END
ELSE
BEGIN
	COMMIT TRAN
	RETURN 0
END




GRANT EXECUTE ON h3giCreateRetailer TO b4nuser
GO
GRANT EXECUTE ON h3giCreateRetailer TO ofsuser
GO
GRANT EXECUTE ON h3giCreateRetailer TO reportuser
GO
