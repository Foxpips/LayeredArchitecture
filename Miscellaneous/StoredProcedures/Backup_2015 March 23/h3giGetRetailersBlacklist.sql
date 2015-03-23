-- =============================================
-- Author:		Stephen Quin
-- Create date: 13/01/10
-- Description:	returns a list of blacklisted
--				retailerCodes
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetRetailersBlacklist] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT	blackList.retailerCode, blackList.retailerName
   FROM		h3giRetailersBlackList blackList
		INNER JOIN h3giRetailer retailer
		ON blackList.retailerCode = retailer.retailerCode
   
END

GRANT EXECUTE ON h3giGetRetailersBlacklist TO b4nuser
GO
