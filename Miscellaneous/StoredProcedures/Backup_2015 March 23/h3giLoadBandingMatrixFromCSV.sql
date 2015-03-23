


CREATE PROCEDURE [dbo].[h3giLoadBandingMatrixFromCSV]   
	@csvFile VARCHAR(100)
AS
BEGIN
	
	BEGIN TRANSACTION
	SET NOCOUNT ON;
	DECLARE @catalogueVersion INT = dbo.fn_GetActiveCatalogueVersion();
	
	CREATE TABLE #temp_banding_matrix
	(
		incomingBand char(1), 
		tariffPeoplesoftId varchar(50),
		outgoingBand varchar(10)
	)

    DECLARE @sql NVARCHAR(1000) = 
	'BULK INSERT #temp_banding_matrix
	FROM ''' + @csvFile + '''
	WITH (fieldterminator = '','', rowterminator = ''\n'')'
	
	EXEC (@sql)

	TRUNCATE TABLE h3giUpgradePricePlanBands
	
	INSERT INTO h3giUpgradePricePlanBands (pricePlanId, incomingBand, pricingBandCode)
		SELECT ppp.pricePlanID, #temp_banding_matrix.incomingBand, #temp_banding_matrix.outgoingBand 
		FROM #temp_banding_matrix
		INNER JOIN h3giPricePlanPackage ppp
			ON #temp_banding_matrix.tariffPeoplesoftId = ppp.PeopleSoftID
			AND ppp.catalogueVersionID = @catalogueVersion
		
		
	IF @@ERROR <> 0 GOTO ERR_HANDLER

	COMMIT TRANSACTION

	GOTO SPROC_END

	ERR_HANDLER:
		ROLLBACK TRANSACTION
		PRINT 'FAILED. Rolling back.'

	SPROC_END:

END



GRANT EXECUTE ON h3giLoadBandingMatrixFromCSV TO b4nuser
GO
