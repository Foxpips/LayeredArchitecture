-- ================================================================================
-- Author:		Stephen Quin
-- Create date: 15/09/09
-- Description:	Performs a search on out of stock orders
-- Changes:		26/07/2011 - Stephen Quin	-	removed join to viewOrderPhone
--				14/09/2011 - GH - added case for Accessory OrderType, uses cat.productName
--									and fixed space bug in dynamic SQL before WHERE							
-- ================================================================================
CREATE PROCEDURE [dbo].[h3giOutOfStockSearch] 
	@orderRef INT = -1,
	@daytimeContactAreaCode VARCHAR(10) = '',
	@daytimeContactNumber VARCHAR(15) = '',
	@homeLandlineAreaCode VARCHAR(10) = '',
	@homeLandlineNumber VARCHAR(15) = '',
	@forename VARCHAR(100) = '',
	@surname VARCHAR(100) = '',
	@address VARCHAR(1000) = '',
	@orderDateFrom DATETIME = NULL,
	@orderDateTo DATETIME = NULL,
	@dobDD INT = -1,
	@dobMM INT = -1,
	@dobYYYY INT = -1,
	@peopleSoftId VARCHAR(50) = '-1',
	@channelCode VARCHAR(20) = '',
	@retailerCode VARCHAR(20) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(4000)
    DECLARE @params NVARCHAR(1000)
    
    SET @sql =			'SELECT h3gi.orderRef,'
    SET @sql = @sql +	'		b4n.billingForename + '' '' + (CASE WHEN(LEN(h3gi.initials) > 0) THEN h3gi.initials + '' '' ELSE '''' END) + b4n.billingSurname AS name,'
    SET @sql = @sql +	'		h3gi.daytimeContactAreaCode + '' '' + h3gi.daytimeContactNumber AS contactNumber,'
    SET @sql = @sql +	'		cat.productName AS product,'
    SET @sql = @sql +	'		b4n.orderDate, '
	SET @sql = @sql +	'		CASE h3gi.orderType'
    SET @sql = @sql +	'			WHEN 0 THEN ''Contract'''
    SET @sql = @sql +	'		 	WHEN 1 THEN ''Prepay'''
    SET @sql = @sql +	'		 	WHEN 2 THEN ''Upgrade'''
    SET @sql = @sql +	'			WHEN 3 THEN ''Upgrade'''
    SET @sql = @sql +	'			WHEN 4 THEN ''Accessory'''
    SET @sql = @sql +	'		END AS orderType,'
    SET @sql = @sql +	'		CASE h3gi.channelCode'
    SET @sql = @sql +	'			WHEN ''UK000000290'' THEN ''Web'''
    SET @sql = @sql +	'			WHEN ''UK000000291'' THEN ''Telesales'''
    SET @sql = @sql +	'			WHEN ''UK000000294'' THEN ''Distance'''
    SET @sql = @sql +	'		END AS channel '
    SET @sql = @sql +	'FROM	h3giOrderHeader h3gi'
    SET @sql = @sql +	'	INNER JOIN b4nOrderHeader b4n'
    SET @sql = @sql +	'		ON h3gi.orderRef = b4n.orderRef'
    SET @sql = @sql +	'	INNER JOIN h3giProductCatalogue cat'
	SET @sql = @sql +	'		ON h3gi.phoneProductCode = cat.productFamilyId'
	SET @sql = @sql +	'		AND h3gi.catalogueVersionID = cat.catalogueVersionID '
    SET @sql = @sql +	'WHERE	b4n.status IN (600,601,602) '
    
    IF @orderRef <> -1
		SET @sql = @sql +	'	AND h3gi.orderRef = @orderRef'
    
    IF @daytimeContactAreaCode <> ''
		SET @sql = @sql +	'	AND h3gi.daytimeContactAreaCode = @daytimeContactAreaCode'
    
    IF @homeLandlineAreaCode <> ''
		SET @sql = @sql +	'	AND h3gi.homePhoneAreaCode = @homeLandlineAreaCode'
    
    IF @homeLandlineNumber <> ''
		SET @sql = @sql +	'	AND h3gi.homePhoneNumber = @homeLandlineNumber'
    
    IF @forename <> ''
		SET @sql = @sql +	'	AND b4n.BillingForename LIKE @forename'
    
    IF @surname <> ''
		SET @sql = @sql +	'	AND b4n.BillingSurname LIKE @surname'
    
    IF @address <> ''
    BEGIN
		SET @sql = @sql +	'	AND REPLACE(LTRIM(RTRIM(h3gi.billingHouseNumber)), '' '', '''') + 
									REPLACE(LTRIM(RTRIM(h3gi.billingHouseName)), '' '', '''') + 
	    							REPLACE(LTRIM(RTRIM(b4n.billingAddr2)), '' '', '''') +
	    							REPLACE(LTRIM(RTRIM(b4n.billingAddr3)), '' '', '''') +
	    							REPLACE(LTRIM(RTRIM(b4n.billingCity)), '' '', '''') +
	    							REPLACE(LTRIM(RTRIM(b4n.billingCounty)), '' '', '''') +
	    							REPLACE(LTRIM(RTRIM(b4n.billingCountry)), '' '', '''') 
	    						LIKE ''%' + @address + '%'''
    END
    
    IF(@orderDateFrom IS NOT NULL AND @orderDateTo IS NOT NULL)
		SET @sql = @sql +	'	AND b4n.orderDate BETWEEN @orderDateFrom AND @orderDateTo' 

	IF(@dobDD <> -1 AND @dobMM <> -1 AND @dobYYYY <> -1)
		SET @sql = @sql +	'	AND h3gi.dobDD = @dobDD AND h3gi.dobMM = @dobMM AND h3gi.dobYYYY = @dobYYYY'
	
	IF(@peopleSoftId <> '-1')
		SET @sql = @sql +	'	AND cat.peopleSoftId = @peopleSoftId'
		
	IF(@channelCode = 'UK000000291')
	BEGIN
		SET @sql = @sql +	'	AND h3gi.channelCode IN (''UK000000290'',''UK000000291'')'
		SET @sql = @sql +	'	AND h3gi.retailerCode IN (''BFN01'',''BFN02'')'
	END
	ELSE
	BEGIN
		SET @sql = @sql +	'	AND h3gi.channelCode = @channelCode'
		SET @sql = @sql +	'	AND h3gi.retailerCode = @retailerCode'
	END
		
	SET @params = '@orderRef INT, @daytimeContactAreaCode VARCHAR(10),@homeLandlineAreaCode VARCHAR(10),@homeLandlineNumber VARCHAR(15),@forename VARCHAR(100),@surname VARCHAR(100),@address VARCHAR(1000),@orderDateFrom DATETIME,@orderDateTo DATETIME,@dobDD INT,@dobMM INT,@dobYYYY INT,@peopleSoftId VARCHAR(50),@channelCode VARCHAR(20),@retailerCode VARCHAR(20)'
		
	PRINT @sql
	EXEC sp_executesql @sql, @Params, @orderRef, @daytimeContactAreaCode, @homeLandlineAreaCode, @homeLandlineNumber, @forename, @surname, @address, @orderDateFrom, @orderDateTo, @dobDD, @dobMM, @dobYYYY, @peopleSoftId, @channelCode, @retailerCode
END

GRANT EXECUTE ON h3giOutOfStockSearch TO b4nuser
GO
