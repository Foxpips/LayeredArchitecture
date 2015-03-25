




/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetTopUpLocations
** Author		:	Peter Murphy
** Date Created		:	28/03/06
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure returns search info on Top Up Stores
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Initial version
**				1.0.1 - 19/04/06 - Peter Murphy - added row limiter
**				1.0.2 - 03/05/06 - Peter Murphy - allow search for "O'Neills" etc (apostrophes)
**				1.0.3 - 05/05/06 - Peter Murphy - Use "Co. " if there is no postcode in the address
**						
**********************************************************************************************************************/
 
CREATE    PROCEDURE dbo.h3giGetTopUpLocations

@CountyID varchar(2) = '',
@PostCode varchar(2) = '',
@Query varchar(100) = '',
@Locality varchar(100) = '',
@Limit bit

AS BEGIN

	SET @Query = REPLACE(@Query, '''',  '''''')

	DECLARE @SQL varchar(1000)
	DECLARE @RowLimiter int

	select @RowLimiter = idValue from b4nsysdefaults with(nolock) where idName = 'returnTopUpRows'

	select @Limit as IsLimited, @RowLimiter as MaxRows

	if(@Limit = 1)
		SET @SQL = 'select top ' + cast(@RowLimiter as varchar)
	ELSE
		SET @SQL = 'select'


	SET @SQL = @SQL + ' TUL.StoreID as StoreID, TUL.storeName as Store, TUL.storePhoneNumber as Phone, 
		(isnull(TUL.storeAddress1,'''')+
		'', ''+isnull(TUL.storeAddress2,'''')+
		'', ''+isnull(TUL.locality,'''')+
		'', ''+isnull(TUL.storeCity,'''')+
		case 
			when PostCode is null then '', Co. ''
			when PostCode = '''' then '', Co. ''
			else '', ''
		end
		+ isnull(CC.b4nClassDesc,'''')
		+'' ''+isnull(TUL.postCode,'''')) as Address
		from h3giTopUpLocation TUL 
		left outer join b4nClassCodes CC on TUL.storeCounty = CC.b4nClassCode
		where CC.b4nClassSysID = ''SubCountry'''

	IF(NOT @CountyID = '')
	BEGIN
		SET @SQL = @SQL + ' and TUL.storeCounty = ' + @CountyID
	END

	IF(NOT @PostCode = '')
	BEGIN
		SET @SQL = @SQL + ' and TUL.postCode = ''' + @PostCode + ''''
	END

	IF(NOT @Locality = '')
	BEGIN
		SET @SQL = @SQL + ' and TUL.locality = ''' + @Locality + ''''
	END

	if(NOT @Query = '')
	BEGIN
		SET @SQL = @SQL + ' and (TUL.storeName like ''%' + @Query + '%'''
				+ ' or TUL.storeAddress1 like ''%' + @Query + '%'''
				+ ' or TUL.storeAddress2 like ''%' + @Query + '%'''
				+ ' or TUL.locality like ''%' + @Query + '%'''
				+ ' or TUL.storeCity like ''%' + @Query + '%'''
				+ ' or TUL.storePhoneNumber like ''%' + @Query + '%'')'
				--+ ' or CC.b4nClassDesc like ''%' + @Query + '%'')'
	END

	SET @SQL = @SQL + ' order by TUL.storeName'

--	print(@sql)
	EXEC(@SQL)

END





GRANT EXECUTE ON h3giGetTopUpLocations TO b4nuser
GO
GRANT EXECUTE ON h3giGetTopUpLocations TO ofsuser
GO
GRANT EXECUTE ON h3giGetTopUpLocations TO reportuser
GO
