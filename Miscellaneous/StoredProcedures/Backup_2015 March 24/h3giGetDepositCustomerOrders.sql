-- =============================================
-- Author:		Stephen Quin
-- Create date: 30/05/08
-- Description:	Returns all the orders for the 
--				deposit customers orders queue
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetDepositCustomerOrders] 
@channel AS VARCHAR(20) = '',
@retailerCode AS VARCHAR(20) = '',
@max int = 1000
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @sql AS NVARCHAR(4000)

	SET @sql = 'SELECT TOP ' + str(@max)
	SET @sql = @sql + ' b4nHeader.orderRef, '
	SET @sql = @sql + 'COALESCE(REG.firstname, b4nHeader.billingForename) AS forename, '
	SET @sql = @sql + 'COALESCE(REG.middleInitial, h3giHeader.initials) AS initials, '
	SET @sql = @sql + 'COALESCE(REG.surname, b4nHeader.billingSurName) AS surname, '
	SET @sql = @sql + 'COALESCE(REG.addrHouseName, h3giHeader.billingHouseName) AS houseName, '
	SET @sql = @sql + 'COALESCE(REG.addrHouseNumber, h3giHeader.billingHouseNumber) AS houseNumber, '
	SET @sql = @sql + 'COALESCE(REG.addrStreetName, b4nHeader.billingAddr1) AS address1, '
	SET @sql = @sql + 'COALESCE(REG.addrLocality, b4nHeader.billingAddr2) AS address2, '
	SET @sql = @sql + 'b4nHeader.billingAddr3 AS address3, '
	SET @sql = @sql + 'COALESCE(REG.addrTownCity, b4nHeader.billingCity) AS city, '
	SET @sql = @sql + 'COALESCE(REG.addrCounty, b4nHeader.billingCounty) AS county, '
	SET @sql = @sql + 'b4nHeader.billingCountry AS country, '
	SET @sql = @sql + 'h3giHeader.channelCode AS channel, '
	SET @sql = @sql + 'b4nHeader.orderDate, '
	SET @sql = @sql + 'h3giHeader.callbackDate '
	SET @sql = @sql + 'FROM b4nOrderHeader b4nHeader WITH(NOLOCK) '
	SET @sql = @sql + 'INNER JOIN h3giOrderHeader h3giHeader WITH(NOLOCK) ON b4nHeader.orderRef = h3giHeader.orderRef '
	SET @sql = @sql + 'LEFT OUTER JOIN h3giRegistration REG ON b4nHeader.orderRef = REG.orderRef '
	IF(@channel = 'telesales')
	BEGIN
		SET @sql = @sql + 'WHERE h3giHeader.channelCode IN (''UK000000290'',''UK000000291'') '
		SET @sql = @sql + 'AND ((h3giHeader.creditAnalystId > 0 AND b4nHeader.status = 402) OR (b4nHeader.status = 405)) '
	END
	ELSE IF(@channel = 'distance')
	BEGIN
		SET @sql = @sql + 'WHERE h3giHeader.channelCode = ''UK000000294'' '
		SET @sql = @sql + 'AND ((h3giHeader.creditAnalystId > 0 AND b4nHeader.status = 402) OR (b4nHeader.status = 405)) '
		SET @sql = @sql + 'AND h3giHeader.retailerCode = ' + char(39) + @retailerCode + char(39) + ' '
	END
	SET @sql = @sql + 'AND h3giHeader.callbackDate <= GETDATE() '
	SET @sql = @sql + 'ORDER BY b4nHeader.orderRef '

	PRINT(@sql)
	EXEC(@sql)

	SELECT idValue AS RefreshSeconds FROM b4nSysDefaults WITH(NOLOCK) WHERE idName = 'QueueRefresh'
END


GRANT EXECUTE ON h3giGetDepositCustomerOrders TO b4nuser
GO
