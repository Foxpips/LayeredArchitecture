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
**********************************************************************************************************************/ 

CREATE PROCEDURE [dbo].[H3GISearchForOrder_backup_250806]
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
	@PaymentMethod		SMALLINT	= -1,
	@searchfrom		varchar(20)	= '',
	@RetailerCode		varchar(20) = '',
	@StoreCode		varchar(20) = '',
	@Ban		varchar(10) 	= NULL
AS



DECLARE   	
		@Err 		int,
		@SQL 		NVARCHAR(4000),
		@WHERESQL	NVARCHAR(4000),
		@Params	NVARCHAR(1000),
		@channelCode VARCHAR(20)


DECLARE @B4Nforename varchar(50)
DECLARE @B4Nsurname varchar(50)
DECLARE @B4Naddress varchar (500)

DECLARE @REGforename varchar(50)
DECLARE @REGsurname varchar(50)
DECLARE @REGaddress varchar (500)




-- Build Insert SQL
SET @SQL = ' SELECT TOP  ' + CAST(@MaxSearchResults AS VARCHAR)  +' B4N.OrderRef AS orderref, B4N.BillingForeName as Forename,H3G.initials as initials, B4N.BillingSurName  AS Surname, B4N.ccNumber AS ccNumber, CHANNEL.channelName as channel, '
SET @SQL = @SQL + ' (SELECT b4nClassDesc FROM dbo.b4nClassCodes WHERE  b4nClassSysID= ' +char(39)+'StatusCode' +char(39)+' and  b4nClassCode=cast(B4N.Status as varchar(20)) AND b4nValid='+char(39)+'Y'+char(39)+ ') AS Status,'
SET @SQL = @SQL + ' H3G.channelCode  AS channelCode, ch.channelName, '
SET @SQL = @SQL + ' H3G.billingHouseNumber as housenumber,  H3G.billingHouseName as housename , B4N.billingAddr2 as address2 ,B4N.billingAddr3 as address3, + '  
SET @SQL = @SQL + ' B4N.billingCity as city,B4N.billingCounty as county ,B4N.billingCountry as country  , '  
SET @SQL = @SQL + ' B4N.OrderDate as orderdate, IsNull(sequence_no, 0) as ProvisioningNo, IsNull(AU.userName, '''') as lock, '
SET @SQL = @SQL + ' isnull(UPG.BillingAccountNumber, '''') as BAN, ' 
SET @SQL = @SQL + ' isnull(VOP.PrePay,''-1'') as PrePay '


--Peter Murphy - join on the registration table to get a name and address for PrePay orders (defect 751)
SET @SQL = @SQL + ', isnull(REG.firstname, '''') as RegFirstName, isnull(REG.surname, '''') as RegSurName, '
SET @SQL = @SQL + ' isnull(REG.addrHouseNumber, '''') as RegHouseNumber, isnull(REG.addrHouseName, '''') as RegHouseName, '
SET @SQL = @SQL + ' isnull(REG.addrStreetName, '''') as RegStreetName, isnull(REG.addrLocality, '''') as RegLocality, '
SET @SQL = @SQL + ' isnull(REG.addrTownCity, '''') as RegTownCity, isnull(REG.addrCounty, '''') as RegCounty, '
SET @SQL = @SQL + ' isnull(REG.addrCountry, '''') as RegCountry, isnull(REG.middleInitial, '''') as RegInitial '
-- End of defect 751 change


SET @SQL = @SQL + '	FROM b4nOrderHeader B4N JOIN h3giOrderHeader H3G ON B4N.OrderRef = H3G.OrderRef  '
SET @SQL = @SQL + '	left outer join h3giSalesCapture_Audit SCA on B4N.OrderRef = SCA.OrderRef '

--Check for PrePay bit
IF(@PaymentMethod <> -1) 
BEGIN
	SET @SQL = @SQL + ' AND SCA.PrePay = ' + cast(@PaymentMethod as varchar(2))
END
ELSE IF (@searchfrom NOT IN ('view'))
BEGIN
	SET @SQL = @SQL + ' AND SCA.PrePay  !=  2'
END

SET @SQL = @SQL + '	LEFT OUTER JOIN h3giChannel CHANNEL on H3G.channelCode = CHANNEL.channelCode '
SET @SQL = @SQL + '	LEFT OUTER JOIN h3giUpgrade UPG on H3G.upgradeId = UPG.upgradeId '

SET @SQL = @SQL + ' inner join viewOrderPhone VOP on VOP.OrderRef = B4N.OrderRef'
SET @SQL = @SQL + ' left outer join h3giLock L on B4N.OrderRef = L.OrderID AND TypeID = 1 '
SET @SQL = @SQL + ' left outer join smApplicationUsers AU on AU.userID = L.userID '

--Peter Murphy - join on the registration table to get a name and address for PrePay orders (defect 751)
SET @SQL = @SQL + ' left outer join h3giRegistration REG on REG.orderRef = B4N.OrderRef'

SET @SQL = @SQL + ', h3giChannel ch with(nolock) WHERE H3G.channelcode = ch.channelcode AND'

--Numbers only so must be equal if its not the default
IF(@OrderRef>0) SET @SQL = @SQL+' B4N.OrderRef = @OrderRef AND '

IF((NOT (@searchfrom = 'credit' OR @searchfrom = 'CAF')) AND @Ban IS NULL) 
BEGIN
	SET @channelCode = (select channelCode from h3gichannel with(nolock) where channelName = '3rd Party Retail')
	SET @SQL = @SQL+' H3G.channelCode <> ' + char(39) + @channelCode + char(39) + ' AND '
END

IF(@RetailerCode <> '')
	SET @SQL = @SQL+' H3G.RetailerCode = ' + char(39) + @RetailerCode + char(39) + ' AND '	

IF(@StoreCode <> '')
	SET @SQL = @SQL+' H3G.StoreCode = ' + char(39) + @StoreCode + char(39) + ' AND '	

IF(@Ban IS NOT NULL)
	SET @SQL = @SQL + ' UPG.BillingAccountNumber = ' + @Ban + ' AND '

IF (@searchfrom = 'CAF')
	SET @SQL = @SQL + ' H3G.intentionToPort = ''Y'' AND '

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

--@OrderDateFrom @OrderDateTo 
--if you have a valid range
IF(@OrderDateFrom <> '' and @OrderDateTo <> '')
BEGIN	 
	SET @SQL = @SQL+'  B4N.OrderDate BETWEEN  CONVERT(SMALLDATETIME, @OrderDateFrom, 103) AND CONVERT(SMALLDATETIME, @OrderDateTo, 103)   AND '    
END

--filter by status
IF(@Status<900 and @Status>0 )
BEGIN
	SET @SQL = @SQL +' B4N.Status = ' + CONVERT(VARCHAR(10), @Status) + '  AND  '	
END

--bring back all declined
IF(@Status=901 and @Status>0)
BEGIN 
	SET @SQL = @SQL +'   B4N.Status IN(305,304 ) AND '
END

--bring back all credit 
IF(@Status=900 and @Status>0)
BEGIN
	SET @SQL = @SQL+ ' B4N.Status IN(300,302 )  AND  ' 
END

--bring back all statuses
IF(@Status=902 and @Status>0)
BEGIN
	SET @SQL = @SQL+ ' B4N.Status IN(select distinct(b4nClasscode) from b4nclasscodes where b4nclassSysID = '+char(39)+'statuscode'+char(39)+')  AND  ' 
END

--Check for PrePay bit
IF(@PaymentMethod <> -1)
BEGIN
	SET @SQL = @SQL + ' VOP.PrePay = ' + cast(@PaymentMethod as varchar(2)) + ' AND '
END
ELSE IF (@searchfrom NOT IN ('view'))
BEGIN
	SET @SQL = @SQL + ' VOP.PrePay != 2  AND '
END


--check for a trailing and
SET @SQL  = RTRIM(@SQL)
SET @SQL  = SUBSTRING(@SQL,0,LEN(@SQL)-3)


--order by
SET @SQL = @SQL +' ORDER BY OrderRef asc'


SET @Params = '@MaxSearchResults INT, @OrderRef INT, @ForeName VARCHAR(50),@SurName varchar(50), @dobDD INT  ,'
SET @Params = @Params + ' @dobMM INT ,  @dobYYYY INT, @HomephoneArea VARCHAR(4)  ,@HomephoneNum VARCHAR(20), ' 
SET @Params = @Params + ' @ContphoneArea VARCHAR(4),@ContphoneNum VARCHAR(20), @OrderDateFrom VARCHAR(50), @OrderDateTo VARCHAR(50),@Status INT, @Address VARCHAR(1000)  '

SET @Err = @@ERROR
IF (@Err <> 0)
BEGIN
	GOTO Fail
END

print(@Sql)
EXEC sp_executesql @SQL, @Params, @MaxSearchResults,@OrderRef,@ForeName,@SurName,@dobDD,@dobMM,@dobYYYY,@HomephoneArea,@HomephoneNum,@ContphoneArea,@ContphoneNum, @OrderDateFrom, @OrderDateTo,@Status,@Address 
return @Err
Fail:
RETURN -1



GRANT EXECUTE ON H3GISearchForOrder_backup_250806 TO b4nuser
GO
GRANT EXECUTE ON H3GISearchForOrder_backup_250806 TO ofsuser
GO
GRANT EXECUTE ON H3GISearchForOrder_backup_250806 TO reportuser
GO
