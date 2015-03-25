
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giUpdateTopUpLocation
** Author		:	Peter Murphy
** Date Created		:	19/04/2006
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure updates a TopUp Location
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Initial version
**						
**********************************************************************************************************************/


create procedure dbo.h3giUpdateTopUpLocation

@StoreID int,
@StoreName varchar(50),
@StorePhone varchar(30),
@StoreAddr1 varchar(50),
@StoreAddr2 varchar(50),
@StoreCity varchar(50),
@Locality varchar(50),
@PostCode varchar(2),
@StoreCountyID varchar(50)

AS


BEGIN TRAN

update h3giTopUpLocation
set storeName = @StoreName,
    storePhoneNumber = @StorePhone,
    storeAddress1 = @StoreAddr1,
    storeAddress2 = @StoreAddr2,
    StoreCity = @StoreCity,
    Locality = @Locality,
    postCode = @PostCode,
    storeCounty = @StoreCountyID
where storeID = @StoreID


--Check if any errors occurred
if @@Error > 0
BEGIN
	ROLLBACK TRAN
	return 1
END
ELSE
BEGIN
	COMMIT TRAN
	return 0
END



GRANT EXECUTE ON h3giUpdateTopUpLocation TO b4nuser
GO
GRANT EXECUTE ON h3giUpdateTopUpLocation TO ofsuser
GO
GRANT EXECUTE ON h3giUpdateTopUpLocation TO reportuser
GO
