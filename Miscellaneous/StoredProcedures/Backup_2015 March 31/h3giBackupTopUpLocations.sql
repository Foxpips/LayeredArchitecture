

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giBackupTopUpLocations
** Author		:	Peter Murphy
** Date Created		:	06/07/2006
**					
**********************************************************************************************************************
**				
** Description		:	Backup to a _BAK table before batch loading new locations
**					
**********************************************************************************************************************
**									
** Change Control	:	06/07/2006 - Created
**********************************************************************************************************************/


CREATE procedure h3giBackupTopUpLocations

@SupplierID varchar(20)

as

begin

	delete from h3giTopUpLocation_BAK where DataSupplier = @SupplierID

	insert into h3giTopUpLocation_BAK
		(storeName,
		storePhoneNumber,
		storeAddress1,
		storeAddress2,
		storeCity,
		storeCounty,
		postcode,
		locality,
		DataSupplier,
		CreateDate)
	select storeName,
		storePhoneNumber,
		storeAddress1,
		storeAddress2,
		storeCity,
		storeCounty,
		postcode,
		locality,
		DataSupplier,
		CreateDate 
	from h3giTopUpLocation
	where DataSupplier = @SupplierID

	delete from h3giTopUpLocation where DataSupplier = @SupplierID
		

end


GRANT EXECUTE ON h3giBackupTopUpLocations TO b4nuser
GO
GRANT EXECUTE ON h3giBackupTopUpLocations TO ofsuser
GO
GRANT EXECUTE ON h3giBackupTopUpLocations TO reportuser
GO
