-- =============================================
-- Author:		Stephen Quin
-- Create date: 02/11/07
-- Description:	Gets the Retailer data
-- =============================================
CREATE PROCEDURE [dbo].[threeRetailerGet] 
	@retailerCode varchar(20)
AS
BEGIN
	SELECT * FROM h3giRetailer
	WHERE retailerCode = @retailerCode
END

GRANT EXECUTE ON threeRetailerGet TO b4nuser
GO
GRANT EXECUTE ON threeRetailerGet TO reportuser
GO
