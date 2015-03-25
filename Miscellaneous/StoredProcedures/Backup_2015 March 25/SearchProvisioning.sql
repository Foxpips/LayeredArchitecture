

/****** Object:  Stored Procedure dbo.SearchProvisioning    Script Date: 23/06/2005 13:30:54 ******/
CREATE PROC dbo.SearchProvisioning
@OrderRef 	int,
@IMEI 		varchar(25),
@SCCID		varchar(25)
AS
--DECLARE @OrderRef int
--DECLARE @IMEI varchar(25)
--DECLARE @SCCID varchar(25)

--SET @OrderRef = 30246
--SET @IMEI = '354802004750650'


DECLARE @sOrderRef varchar(10)
SET @sOrderRef = Cast(@OrderRef as varchar(10))
------
DECLARE @GMDB varchar(50)
SELECT @GMDB = idValue FROM config WHERE idName = 'OFS4GMDatabase'
DECLARE @SQL varchar(4000)
	SET @SQL = ' SELECT B4N.OrderRef AS orderref, B4N.BillingForeName as Forename,H3G.initials as initials, B4N.BillingSurName  AS Surname,'
	SET @SQL = @SQL + ' (SELECT b4nClassDesc FROM dbo.b4nClassCodes WHERE  b4nClassSysID= ' +char(39)+'StatusCode' +char(39)+' and  b4nClassCode=cast(B4N.Status as varchar(20)) AND b4nValid='+char(39)+'Y'+char(39)+ ') AS Status,'
	SET @SQL = @SQL + ' H3G.channelCode  AS channelCode,'
	SET @SQL = @SQL + ' H3G.billingHouseNumber as housenumber,  H3G.billingHouseName as housename , B4N.billingAddr2 as address2 ,B4N.billingAddr3 as address3, + '  
	SET @SQL = @SQL + ' B4N.billingCity as city,B4N.billingCounty as county ,B4N.billingCountry as country  , '  
	SET @SQL = @SQL + ' B4N.OrderDate as orderdate, IsNull(sequence_no, 0) as ProvisioningNo ,'  
	SET @SQL = @SQL + ' IsNull(gen1, '''') as IMEI, IsNull (gen2, '''') as SCCID ' 

	SET @SQL = @SQL + '	FROM b4nOrderHeader B4N JOIN h3giOrderHeader H3G ON B4N.OrderRef = H3G.OrderRef  '
	SET @SQL = @SQL + '	left outer join h3giSalesCapture_Audit SCA on B4N.OrderRef = SCA.OrderRef '
	SET @SQL = @SQL + '	left outer join ' + @GMDB + '..gmOrderLine GOL on GOL.OrderRef = B4N.OrderRef '

IF @OrderRef is not null
BEGIN
	SET @SQL = @SQL + ' WHERE B4N.OrderRef = ' + @sOrderRef
END
ELSE
BEGIN
	IF @IMEI is not null
	BEGIN
		SET @SQL = @SQL + ' WHERE GOL.gen1 = ''' + @IMEI + char(39)
		IF @SCCID is not null
		BEGIN
			SET @SQL = @SQL + ' AND GOL.gen2 = ''' + @SCCID + char(39)
		END
	END
	ELSE
	BEGIN
		IF @SCCID is not null
		BEGIN
			SET @SQL = @SQL + ' WHERE GOL.gen2 = ''' + @SCCID + char(39)
		END
	END
	
END
PRINT @SQL
EXEC (@SQL)




GRANT EXECUTE ON SearchProvisioning TO b4nuser
GO
GRANT EXECUTE ON SearchProvisioning TO helpdesk
GO
GRANT EXECUTE ON SearchProvisioning TO ofsuser
GO
GRANT EXECUTE ON SearchProvisioning TO reportuser
GO
GRANT EXECUTE ON SearchProvisioning TO b4nexcel
GO
GRANT EXECUTE ON SearchProvisioning TO b4nloader
GO
