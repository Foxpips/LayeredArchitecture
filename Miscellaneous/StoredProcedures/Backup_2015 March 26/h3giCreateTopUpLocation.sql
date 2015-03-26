

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCreateTopUpLocation
** Author		:	Peter Murphy
** Date Created		:	19/04/2006
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure creates a Top Up Location
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Initial version
**			:	1.0.1 - Peter Murphy - added CreateDate and DataSupplier
**						
**********************************************************************************************************************/

CREATE PROCEDURE dbo.h3giCreateTopUpLocation

@StoreID int,
@StoreName varchar(50),
@StorePhone varchar(30),
@StoreAddr1 varchar(50),
@StoreAddr2 varchar(50),
@StoreCity varchar(50),
@Locality varchar(50),
@PostCode varchar(2),
@StoreCountyID varchar(50),
@DataSupplier varchar(20) = ''

as

BEGIN TRAN

insert into h3giTopUpLocation 
	(storeName, 
	storePhoneNumber, 
	storeAddress1, 
	storeAddress2, 
	storeCity, 
	Locality,
	postCode,
	storeCounty,
	DataSupplier,
	CreateDate)

values(@StoreName,
	@StorePhone,
	@StoreAddr1,
	@StoreAddr2,
	@StoreCity,
	@Locality,
	@PostCode,
	@StoreCountyID,
	@DataSupplier,
	getdate())

IF @@Error > 0 
BEGIN 
	ROLLBACK TRAN
	return 1
END
ELSE
BEGIN
	COMMIT TRAN
	return 0
END


GRANT EXECUTE ON h3giCreateTopUpLocation TO b4nuser
GO
GRANT EXECUTE ON h3giCreateTopUpLocation TO ofsuser
GO
GRANT EXECUTE ON h3giCreateTopUpLocation TO reportuser
GO
