


/*********************************************************************************************************************																				
* Procedure		: h3giSearchProvisioning
* Author		: Niall Carroll
* Date Created	: 23/06/2005
* Version		: 1.0.1	
*					
**********************************************************************************************************************
* Description	: Search for provisioning file number from audit table
*
* V1.0.1		: Searches sprint plus for IMEI & SCCID instead of GM (Ncarroll - 18/07/2005)
**********************************************************************************************************************/
CREATE PROC dbo.h3giSearchProvisioning
@OrderRef 	int = null,
@IMEI 		varchar(25) = null,
@SCCID		varchar(25) = null
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
	SET @SQL = ' SELECT B4N.OrderRef AS orderref, B4N.BillingForeName + '' '' + B4N.BillingSurName  AS Name,'
	SET @SQL = @SQL + ' (SELECT b4nClassDesc FROM dbo.b4nClassCodes WHERE  b4nClassSysID= ' +char(39)+'StatusCode' +char(39)+' and  b4nClassCode=cast(B4N.Status as varchar(20)) AND b4nValid='+char(39)+'Y'+char(39)+ ') AS Status,'
	SET @SQL = @SQL + ' H3G.channelCode  AS channelCode,'
	SET @SQL = @SQL + ' IsNull(H3G.billingHouseNumber, '''') + '' '' +  IsNull(H3G.billingHouseName, '''') + '' '' + IsNull(B4N.billingAddr2, '''') + '' '' + IsNull(B4N.billingAddr3, '''') + '  
	SET @SQL = @SQL + ' '' '' + B4N.billingCity  + '' '' + B4N.billingCounty as Address ,B4N.billingCountry as country  , '  
	SET @SQL = @SQL + ' B4N.OrderDate as orderdate, IsNull(sequence_no, 0) as ProvisioningNo ,'  
	SET @SQL = @SQL + ' IsNull(H3G.IMEI, '''') as IMEI, IsNull (H3G.ICCID, '''') as SCCID ' 

	SET @SQL = @SQL + '	FROM b4nOrderHeader B4N JOIN h3giOrderHeader H3G ON B4N.OrderRef = H3G.OrderRef  '
	SET @SQL = @SQL + '	inner join  h3giSalesCapture_Audit SCA on B4N.OrderRef = SCA.OrderRef '
	--SET @SQL = @SQL + '	left outer join ' + @GMDB + '..gmOrderLine GOL on GOL.OrderRef = B4N.OrderRef '

IF @OrderRef is not null
BEGIN
	SET @SQL = @SQL + ' WHERE B4N.OrderRef = ' + @sOrderRef
END
ELSE
BEGIN
	IF @IMEI is not null
	BEGIN
		SET @SQL = @SQL + ' WHERE H3G.IMEI = ''' + @IMEI + char(39)
		IF @SCCID is not null
		BEGIN
			SET @SQL = @SQL + ' AND H3G.ICCID = ''' + @SCCID + char(39)
		END
	END
	ELSE
	BEGIN
		IF @SCCID is not null
		BEGIN
			SET @SQL = @SQL + ' WHERE H3G.ICCID = ''' + @SCCID + char(39)
		END
	END
	
END
PRINT @SQL
EXEC (@SQL)


GRANT EXECUTE ON h3giSearchProvisioning TO b4nuser
GO
GRANT EXECUTE ON h3giSearchProvisioning TO helpdesk
GO
GRANT EXECUTE ON h3giSearchProvisioning TO ofsuser
GO
GRANT EXECUTE ON h3giSearchProvisioning TO reportuser
GO
GRANT EXECUTE ON h3giSearchProvisioning TO b4nexcel
GO
GRANT EXECUTE ON h3giSearchProvisioning TO b4nloader
GO
