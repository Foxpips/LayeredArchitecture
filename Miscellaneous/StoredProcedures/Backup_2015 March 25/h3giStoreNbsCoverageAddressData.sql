

-- ================================================================================
-- Author:		Stephen Quin
-- Create date: 01/02/2011
-- Description:	Stores nbs coverage data against a particular order
-- Changes:		18/04/2011	-	Stephen Quin	-	 added new parameter @address7
-- ================================================================================
CREATE PROCEDURE [dbo].[h3giStoreNbsCoverageAddressData]
	@orderRef INT,
	@address1 VARCHAR(100),
	@address2 VARCHAR(100),
	@address3 VARCHAR(100),
	@address4 VARCHAR(100),
	@address5 VARCHAR(100),
	@address6 VARCHAR(100),
	@address7 VARCHAR(100),
	@autoAddressId VARCHAR(50),
	@coverageLevel VARCHAR(20),
	@coverageType VARCHAR(20),
	@longitude VARCHAR(20),
	@latitude VARCHAR(20),
	@geoDirectoryId VARCHAR(50),
	@dedCode INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO h3giNbsCoverageAddressData 
	(
		orderRef, 
		address1, 
		address2, 
		address3, 
		address4, 
		address5, 
		address6,
		address7,
		autoAddressId, 
		coverageLevel, 
		coverageType,
		longitude,
		latitude,
		geoDirectoryId,
		dedCode
	)
	VALUES 
	(	
		@orderRef, 
		@address1, 
		@address2, 
		@address3, 
		@address4, 
		@address5, 
		@address6, 
		@address7,
		@autoAddressId, 
		@coverageLevel, 
		@coverageType,
		@longitude,
		@latitude,
		@geoDirectoryId,
		@dedCode
	)
END




GRANT EXECUTE ON h3giStoreNbsCoverageAddressData TO b4nuser
GO
