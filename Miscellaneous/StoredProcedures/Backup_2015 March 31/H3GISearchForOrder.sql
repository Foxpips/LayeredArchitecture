



/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.h3giSearchForOrder
** Author			:	Ciaran Hurst	
** Date Created		:	09/05/2005
** Parameters		:	
** Return Values		:	
**Tested 			
**On all permutations	:	No
** Version		:	1.0.0
** Description		:	Search for a record given a number of results
**Change Control	:	09/11/2005 - Niall Carroll - Added searchFrom CAF (for retailers creating CAF forms)
**							- included filter for RetailerCode and StoreCode
**
**			:	07/03/2006 - Peter Murphy - include PaymentMethod in all searches
**			:	30/03/2006 - John Hannon - check h3giSalesCapture_Audit for prepay
**			:	25/04/2006 - Peter Murphy - select registration name and address
**			:	19/06/2006 - Peter Murphy - Allow search for Web PrePay orders
**			:	21/07/2006 - Niall Carroll - Filter out orders which are not Ported for CAF search
**			:	08/08/2006 - Attila Pall - Exclude Retail orders for Telesales search
**			:	13/03/2007 - Adam Jasinski - Added Own Retail channel support
**			:	24/06/2007 - Attila Pall - Added channelCode filter and excluded Distance reseller chanel from telesales search
**			:	06/12/2007 - Adam Jasinski - Added MSISDN and returns support
**			:	01/02/2008 - Adam Jasinski - Added UpgradeProcessed status (400) to return search
**			:	29/02/2008 - Adam Jasinski - Added Prepay Upgrade support
**			:	29/05/2008 - Stephen Quin - Added functionality for Deposit Customers (CR593)
**			:	04/06/2008 - Stephen Quin - Removed section from Distance Deposit Customers checking the RetailerCode. 
**											This is already done later in the code.
**			:	31/10/2008 - Stephen Quin - Added a @Status check that will return all fraud orders if the status code
**											is 555.
**			:	03/11/2008 - Stephen Quin - Added new parameters @BankSortCode and @BankAccountNumber that allow searching
**											for fraud orders using the bank sort code and bank account number
**			:	06/11/2008 - Stephen Quin - Ensured that if the status code is 506 it will only be searched for in the
**											b4nOrderHistory table and not the b4nOrderHeader table
**			:	12/08/2011 - Stephen Quin - Return the simpler h3giOrderHeader orderType column as PrePay
**			:	21/11/2011 - Stephen Quin - Prepay orders that have been partially refunded are now excluded
**********************************************************************************************************************/ 

CREATE     PROCEDURE [dbo].[H3GISearchForOrder]
	@MaxSearchResults	INT		=10,
	@OrderRef 		INT	 	= -999,
	@Address 		VARCHAR(1000) = '',
	@OrderDateFrom 		VARCHAR(50) 	= '',
	@OrderDateTo 		VARCHAR(50) 	= '',
	@Status 		INT 		= -100,
	@ForeName		VARCHAR(50)	= '',
	@SurName		VARCHAR(50)	= '',
	@HomephoneArea		VARCHAR(4)	= '',
	@HomephoneNum		VARCHAR(20)	= '',
	@ContphoneArea 		VARCHAR(4)	= '',
	@ContphoneNum		VARCHAR(20)	= '',
	@dobDD			INT		= -1,
	@dobMM			INT		= -1,
	@dobYYYY		INT		= -1,
	@PaymentMethod		SMALLINT	= -1,	--AJ: in fact, this is the orderType (aka 'prepay')
	@searchfrom		varchar(20)	= '',
	@ChannelCode		varchar(20)	= '',
	@RetailerCode		varchar(20) = '',
	@StoreCode		varchar(20) = '',
	@Ban		varchar(10) 	= NULL,
	@MSISDN		varchar(12) = '',
	@BankSortCode varchar(6) = '',
	@BankAccountNumber varchar(8) = ''
AS

DECLARE   	@Err 		int,
		@SQL 		NVARCHAR(4000),
		@WHERESQL	NVARCHAR(4000),
		@Params	NVARCHAR(1000),
		@channelCodeList VARCHAR(255)


DECLARE @B4Nforename varchar(50)
DECLARE @B4Nsurname varchar(50)
DECLARE @B4Naddress varchar (500)

DECLARE @REGforename varchar(50)
DECLARE @REGsurname varchar(50)
DECLARE @REGaddress varchar (500)

if(@MaxSearchResults = -1)
BEGIN
	SET @MaxSearchResults = 10000
END


-- Build Insert SQL
SET @SQL = 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; '
SET @SQL = @SQL + ' SELECT TOP  ' + CAST(@MaxSearchResults AS VARCHAR)  +' B4N.OrderRef AS orderref, B4N.BillingForeName as Forename,H3G.initials as initials, B4N.BillingSurName  AS Surname, B4N.ccNumber AS ccNumber, CHANNEL.channelName as channel, '
SET @SQL = @SQL + ' (SELECT b4nClassDesc FROM dbo.b4nClassCodes WHERE  b4nClassSysID= ' +char(39)+'StatusCode' +char(39)+' and  b4nClassCode=cast(B4N.Status as varchar(20)) AND b4nValid='+char(39)+'Y'+char(39)+ ') AS Status,'
SET @SQL = @SQL + ' B4N.Status as StatusCode, H3G.channelCode  AS channelCode, ch.channelName, '
SET @SQL = @SQL + ' H3G.billingHouseNumber as housenumber,  H3G.billingHouseName as housename , B4N.billingAddr2 as address2 ,B4N.billingAddr3 as address3, + '  
SET @SQL = @SQL + ' B4N.billingCity as city,B4N.billingCounty as county ,B4N.billingCountry as country  , '  
SET @SQL = @SQL + ' B4N.OrderDate as orderdate, IsNull(AU.userName, '''') as lock, '
SET @SQL = @SQL + ' isnull(UPG.BillingAccountNumber, '''') as BAN, ' 
SET @SQL = @SQL + ' H3G.orderType as PrePay '


--Peter Murphy - join on the registration table to get a name and address for PrePay orders (defect 751)
SET @SQL = @SQL + ', isnull(REG.firstname, '''') as RegFirstName, isnull(REG.surname, '''') as RegSurName, '
SET @SQL = @SQL + ' isnull(REG.addrHouseNumber, '''') as RegHouseNumber, isnull(REG.addrHouseName, '''') as RegHouseName, '
SET @SQL = @SQL + ' isnull(REG.addrStreetName, '''') as RegStreetName, isnull(REG.addrLocality, '''') as RegLocality, '
SET @SQL = @SQL + ' isnull(REG.addrTownCity, '''') as RegTownCity, isnull(REG.addrCounty, '''') as RegCounty, '
SET @SQL = @SQL + ' isnull(REG.addrCountry, '''') as RegCountry, isnull(REG.middleInitial, '''') as RegInitial '
-- End of defect 751 change


SET @SQL = @SQL + '	FROM b4nOrderHeader B4N JOIN h3giOrderHeader H3G ON B4N.OrderRef = H3G.OrderRef  '
--SET @SQL = @SQL + '	left outer join h3giSalesCapture_Audit SCA on B4N.OrderRef = SCA.OrderRef '

--Check for PrePay bit
--IF(@PaymentMethod <> -1) 
--BEGIN
--	SET @SQL = @SQL + ' AND SCA.PrePay = ' + cast(@PaymentMethod as varchar(2))
--END
--ELSE IF (@searchfrom NOT IN ('view'))
--BEGIN
--	SET @SQL = @SQL + ' AND SCA.PrePay  !=  2'
--END

SET @SQL = @SQL + '	LEFT OUTER JOIN h3giChannel CHANNEL on H3G.channelCode = CHANNEL.channelCode '
SET @SQL = @SQL + '	LEFT OUTER JOIN h3giUpgrade UPG on H3G.upgradeId = UPG.upgradeId '
SET @SQL = @SQL + '	inner join h3giOrderType ot on H3G.orderType = ot.orderTypeId '
SET @SQL = @SQL + ' left outer join h3giLock L on B4N.OrderRef = L.OrderID AND TypeID = 1 '
SET @SQL = @SQL + ' left outer join smApplicationUsers AU on AU.userID = L.userID '

--Peter Murphy - join on the registration table to get a name and address for PrePay orders (defect 751)
SET @SQL = @SQL + ' left outer join h3giRegistration REG on REG.orderRef = B4N.OrderRef'

--Adam Jasinski - join with h3giOrderExistingMobileDetails
IF @searchFrom = 'CAF'
BEGIN
	SET @SQL = @SQL + ' left outer join h3giOrderExistingMobileDetails EMD
			on H3G.orderref = EMD.orderref '
END

--Adam Jasinski - join with ICCID (if MSISDN is in the search criteria)
IF @MSISDN <> ''
BEGIN
	SET @SQL = @SQL + ' left outer join h3giICCID ICCIDTable ON H3G.ICCID = ICCIDTable.ICCID '
END

SET @SQL = @SQL + ', h3giChannel ch WHERE H3G.channelcode = ch.channelcode AND'


--Numbers only so must be equal if its not the default
IF(@OrderRef>0) SET @SQL = @SQL+' B4N.OrderRef = @OrderRef AND '

IF (@channelCode = '')
BEGIN
	-- If we don't set the channelCode explicitely we do some magic to filter
	-- If @PaymentMethod = 2 AND @searchfrom = 'view' then it's the Telesales search, so we have to exclude retailer orders
	IF(@searchfrom = 'refund' OR @searchfrom = 'referred')
	BEGIN
		SELECT @channelCodeList = ' (' + char(39) + channelCode + char(39)
					from h3giChannel with(nolock) where channelName = '3rd Party Retail' 
		SELECT @channelCodeList = @channelCodeList + ',' + char(39) + channelCode + char(39) + ') ' 
					from h3giChannel with(nolock) where channelName = 'Own Retail'
		SET @SQL = @SQL+' H3G.channelCode NOT IN ' + @channelCodeList + ' AND '
	END
	ELSE IF((NOT (@searchfrom = 'credit' OR @searchfrom = 'CAF' OR @searchfrom = 'deposits' OR @searchfrom = 'overrideCredit' OR @searchfrom = 'upgrade' OR @searchFrom = 'fops' )) AND NOT (@PaymentMethod IN (2, 3) AND @searchfrom <> 'view') ) 
	BEGIN
		SELECT @channelCodeList = ' (' + char(39) + channelCode + char(39)
					from h3giChannel with(nolock) where channelName = '3rd Party Retail' 
		SELECT @channelCodeList = @channelCodeList + ',' + char(39) + channelCode + char(39)
					from h3giChannel with(nolock) where channelName = 'Own Retail' 
		SELECT @channelCodeList = @channelCodeList + ',' + char(39) + channelCode + char(39) + ') ' 
					from h3giChannel with(nolock) where channelName = 'Distance Reseller'
		SET @SQL = @SQL+' H3G.channelCode NOT IN ' + @channelCodeList + ' AND '
	END
END
-- Deposit Customers
ELSE IF (@channelCode = 'UK000000291' AND @searchFrom = 'depositCustomer')
BEGIN
	SET @SQL = @SQL + ' H3G.channelCode IN (''UK000000290'',''UK000000291'') AND '
	SET @SQL = @SQL + ' ((H3G.creditAnalystId > 0 AND B4N.status = 402) OR (B4N.status=405)) AND '
END
ELSE IF (@channelCode = 'UK000000294' AND @searchFrom = 'depositCustomer')
BEGIN
	SET @SQL = @SQL + ' H3G.channelCode = ''UK000000294'' AND '
	SET @SQL = @SQL + ' ((H3G.creditAnalystId > 0 AND B4N.status = 402) OR (B4N.status = 405)) AND '
END
-- End Deposit
ELSE
BEGIN
	SET @SQL = @SQL+' H3G.channelCode = ' + char(39) + @channelCode + char(39) + ' AND '
END

IF(@RetailerCode <> '')
	SET @SQL = @SQL+' H3G.RetailerCode = ' + char(39) + @RetailerCode + char(39) + ' AND '	

IF(@StoreCode <> '')
	SET @SQL = @SQL+' H3G.StoreCode = ' + char(39) + @StoreCode + char(39) + ' AND '	

IF(@Ban IS NOT NULL)
	SET @SQL = @SQL + ' UPG.BillingAccountNumber = ' + @Ban + ' AND '

IF (@searchfrom = 'CAF')
	SET @SQL = @SQL + ' EMD.intentionToPort = ''Y'' AND '

--Peter Murphy - defect 800 - either search b4OrderHeader or h3giRegistration for name and address
SET @B4Nforename = ' B4N.BillingForeName LIKE @ForeName '
SET @B4Nsurname = ' B4N.BillingSurName LIKE @SurName '
SET @B4Naddress = ' replace(ltrim(rtrim(H3G.billingHouseNumber)), '' '', '''') + 
		replace(ltrim(rtrim(H3G.billingHouseName)), '' '', '''') + 
	    	replace(ltrim(rtrim(billingAddr2)), '' '', '''') +
	    	replace(ltrim(rtrim(billingAddr3)), '' '', '''') +
	    	replace(ltrim(rtrim(billingCity)), '' '', '''') +
	    	replace(ltrim(rtrim(billingCounty)), '' '', '''') +
	    	replace(ltrim(rtrim(billingCountry)), '' '', '''')
		LIKE ''%' + @Address + '%'' '

SET @REGforename = ' REG.firstname LIKE @ForeName '
SET @REGsurname = ' REG.surname LIKE @SurName '
SET @REGaddress = ' replace(ltrim(rtrim(REG.addrHouseNumber)), '' '', '''') + 
		replace(ltrim(rtrim(REG.addrHouseName)), '' '', '''') + 
	    	replace(ltrim(rtrim(REG.addrStreetName)), '' '', '''') +
	    	replace(ltrim(rtrim(REG.addrLocality)), '' '', '''') +
	    	replace(ltrim(rtrim(REG.addrTownCity)), '' '', '''') +
	    	replace(ltrim(rtrim(REG.addrCounty)), '' '', '''') +
	    	replace(ltrim(rtrim(REG.addrCountry)), '' '', '''')
		LIKE ''%' + @Address + '%'' '


if(@searchfrom = 'ordered') -- Even though they are PrePay, Web orders should not look for registration info
BEGIN
	IF(@ForeName <> '') SET @SQL = @SQL + @B4Nforename + ' AND '
	IF(@SurName <> '')  SET @SQL = @SQL + @B4Nsurname + ' AND '
	IF(LEN(@Address) > 0) SET @SQL = @SQL + @B4Naddress + ' AND '
END
ELSE IF (@PaymentMethod = 0) --Contract
BEGIN
	IF(@ForeName <> '') SET @SQL = @SQL + @B4Nforename + ' AND '
	IF(@SurName <> '')  SET @SQL = @SQL + @B4Nsurname + ' AND '
	IF(LEN(@Address) > 0) SET @SQL = @SQL + @B4Naddress + ' AND '
END

ELSE IF (@PaymentMethod = 1) --PrePay
BEGIN
	IF(@ForeName <> '') SET @SQL = @SQL + @REGforename + ' AND '
	IF(@SurName <> '')  SET @SQL = @SQL + @REGsurname + ' AND '
	IF(LEN(@Address) > 0) SET @SQL = @SQL + @REGaddress + ' AND '
END

ELSE IF (@PaymentMethod = -1)--Either Contract OR PrePay
BEGIN
	IF(@ForeName <> '') SET @SQL = @SQL + '(' + @REGforename + ' OR ' + @B4Nforename + ') AND '
	IF(@SurName <> '')  SET @SQL = @SQL + '(' + @REGsurname + ' OR ' + @B4Nsurname + ') AND '
	IF(LEN(@Address) > 0) SET @SQL = @SQL + '(' + @REGaddress + ' OR ' + @B4Naddress + ') AND '
END
--Peter Murphy - end of change for defect 800



--search by date of birth
IF(@dobDD>0 AND @dobMM>0 AND @dobYYYY>0) 
BEGIN
	SET @SQL = @SQL +' H3G.dobDD=@dobDD AND H3G.dobMM =@dobMM AND H3G.dobYYYY=@dobYYYY AND  '		
END

--home phone number
IF(@HomephoneArea <> '')
BEGIN
	SET @SQL = @SQL+' H3G.homePhoneAreaCode =@HomephoneArea AND '
END 	

--home phone number
IF(@HomephoneNum <> '')
BEGIN
	SET @SQL =@SQL+'  H3G.homePhoneNumber = @HomephoneNum AND   '
END 	

--Day time contact number
IF(@ContphoneArea <>'')
BEGIN
	SET @SQL = @SQL+' H3G.daytimecontactAreaCode  = @ContphoneArea AND   '
END

--Day time contact number
IF(@ContphoneNum <>'')
BEGIN
	SET @SQL = @SQL+' H3G.daytimecontactNumber =  @ContphoneNum  AND   '
END

--Adam Jasinski - search by MSISDN
IF @MSISDN <> ''
BEGIN
	SET @SQL = @SQL + ' ICCIDTable.MSISDN = @MSISDN AND'
END

--search for items that weren't returned
IF @searchfrom = 'returns'
BEGIN
	SET @SQL = @SQL + ' B4N.Status IN (312, 400) AND H3G.itemReturned = 0 AND '
END

--@OrderDateFrom @OrderDateTo 
--if you have a valid range
IF(@OrderDateFrom <> '' and @OrderDateTo <> '')
BEGIN	 
	SET @SQL = @SQL+'  B4N.OrderDate BETWEEN  CONVERT(SMALLDATETIME, @OrderDateFrom, 103) AND CONVERT(SMALLDATETIME, @OrderDateTo, 103)   AND '    
END

--filter by status
IF(@Status<900 and @Status>0 and @Status <> 506)
BEGIN
	SET @SQL = @SQL +' B4N.Status = ' + CONVERT(VARCHAR(10), @Status) + '  AND  '	
END

--bring back all credit 
IF(@Status=900 and @Status>0)
BEGIN
	SET @SQL = @SQL+ ' B4N.Status IN(300,302 )  AND  ' 
END

--bring back all declined
IF(@Status=901 and @Status>0)
BEGIN 
	SET @SQL = @SQL +'   B4N.Status IN(305,304 ) AND '
END

--bring back all statuses
IF(@Status=902 and @Status>0)
BEGIN
	SET @SQL = @SQL+ ' B4N.Status IN(select distinct(b4nClasscode) from b4nclasscodes where b4nclassSysID = '+char(39)+'statuscode'+char(39)+')  AND  ' 
END

--bring back orders for Upgrade Queue
IF(@Status = 903 and @Status >0)
BEGIN
	SET @SQL = @SQL +'   B4N.Status IN(312,309 ) AND '
END

--bring back orders for Upgrade Queue
IF(@Status = 904)
BEGIN
	SET @SQL = @SQL +'   ( B4N.Status = 402
				OR (B4N.Status = 403 AND DATEADD(dd,7,B4N.OrderDate) > GETDATE()) 
				OR (B4N.Status in (311,312) AND EXISTS (SELECT * FROM h3giOrderDeposit WHERE h3giOrderDeposit.orderRef = B4N.orderRef))) AND '
END

--bring back all fraud
IF(@Status = 955)
BEGIN
	SET @SQL = @SQL + '( B4N.Status IN (500,501,502,505,506) OR EXISTS(SELECT * FROM b4nOrderHistory WHERE orderRef=B4N.orderRef and orderStatus=506) )AND '
END
IF(@Status = 506)
BEGIN
	SET @SQL = @SQL + '( EXISTS(SELECT * FROM b4nOrderHistory WHERE orderRef=B4N.orderRef and orderStatus=506) )AND '
END

IF(@searchfrom = 'overrideCredit')
BEGIN
	SET @SQL = @SQL +'   DATEADD(dd,30,B4N.OrderDate) > GETDATE() AND '
END

--Check for PrePay bit
IF(@PaymentMethod <> -1)
BEGIN
	SET @SQL = @SQL + ' H3G.orderType = ' + cast(@PaymentMethod as varchar(2)) + ' AND '
END
ELSE IF @searchFrom = 'upgrade'
BEGIN
	SET @SQL = @SQL + ' ot.isUpgrade = 1 AND '	--contract and prepay upgrades
END
ELSE IF @searchFrom = 'credit'
BEGIN
	SET @SQL = @SQL + ' H3G.orderType = 0 AND '	--no upgrades
END
ELSE IF (@searchfrom NOT IN ('view', 'returns'))
BEGIN
	SET @SQL = @SQL + ' H3G.orderType != 2  AND '
END

IF(@Status = 401)
BEGIN
	SET @SQL = @SQL + ' H3G.orderType != 1 AND '
END

--Check for Sort Code and Account Number
IF(@BankSortCode <> '')
BEGIN
	SET @SQL = @SQL + ' H3G.sortCode = @BankSortCode AND '
END

IF(@BankAccountNumber <> '')
BEGIN
	SET @SQL = @SQL + ' H3G.accountNumber = @BankAccountNumber AND '
END

--check for a trailing and
SET @SQL  = RTRIM(@SQL)
SET @SQL  = SUBSTRING(@SQL,0,LEN(@SQL)-3)


--order by
SET @SQL = @SQL +' ORDER BY OrderRef asc'


SET @Params = '@MaxSearchResults INT, @OrderRef INT, @ForeName VARCHAR(50),@SurName varchar(50), @dobDD INT  ,'
SET @Params = @Params + ' @dobMM INT ,  @dobYYYY INT, @HomephoneArea VARCHAR(4)  ,@HomephoneNum VARCHAR(20), ' 
SET @Params = @Params + ' @ContphoneArea VARCHAR(4),@ContphoneNum VARCHAR(20), @OrderDateFrom VARCHAR(50), @OrderDateTo VARCHAR(50),@Status INT, @Address VARCHAR(1000), @MSISDN VARCHAR(12), @BankSortCode VARCHAR(6), @BankAccountNumber VARCHAR(8)  '

SET @Err = @@ERROR
IF (@Err <> 0)
BEGIN
	GOTO Fail
END

SET @SQL = @SQL + ' SET TRANSACTION ISOLATION LEVEL READ COMMITTED;'

print(@Sql)
EXEC sp_executesql @SQL, @Params, @MaxSearchResults,@OrderRef,@ForeName,@SurName,@dobDD,@dobMM,@dobYYYY,@HomephoneArea,@HomephoneNum,@ContphoneArea,@ContphoneNum, @OrderDateFrom, @OrderDateTo,@Status,@Address, @MSISDN, @BankSortCode, @BankAccountNumber

return @Err
Fail:
RETURN -1






GRANT EXECUTE ON H3GISearchForOrder TO b4nuser
GO
GRANT EXECUTE ON H3GISearchForOrder TO reportuser
GO
