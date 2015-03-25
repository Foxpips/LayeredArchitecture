
-- =============================================
-- Author:		Stephen Quin
-- Create date: 03/02/2011
-- Description:	Stores the extra address data
--				returned by Bizmaps
-- =============================================
CREATE PROCEDURE [dbo].[h3giStoreBizmapsAddressData] 
	@orderRef INT,
	@longitude VARCHAR(20),
	@latitude VARCHAR(20),
	@geoDirectoryId VARCHAR(50),
	@dedCode INT,
	@autoAddressId VARCHAR(50),
	@coverageLevel VARCHAR(20),
	@coverageType VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO h3giBizmapsAddressData 
    (
		orderRef, 
		longitude, 
		latitude, 
		geoDirectoryId, 
		dedCode, 		
		autoAddressId,
		coverageLevel,
		coverageType
	)
    VALUES 
    (
		@orderRef, 
		@longitude, 
		@latitude, 
		@geoDirectoryId, 
		@dedCode, 		
		@autoAddressId,
		@coverageLevel,
		@coverageType
	)
END


GRANT EXECUTE ON h3giStoreBizmapsAddressData TO b4nuser
GO
