

create proc [dbo].[h3giUpdateRegistrationDetails]
/*********************************************************************************************************************
**                                                                                                              
** Procedure Name    :    h3giUpdateRegistrationDetails
** Author            :    John Hannon
** Date Created      :    03/03/06
**                         
**********************************************************************************************************************
**                   
** Description       :    Updates the registration details attached to the order - for PrePay
**                         
**********************************************************************************************************************
**                                              
** Change Control    :    
**                              
**********************************************************************************************************************/

@orderref int,
@title varchar(20),
@firstname varchar(100),
@middleInitial varchar(5),
@surname varchar(100),
@gender varchar(20),
@dobDay smallint,
@dobMonth smallint,
@dobYear smallint,
@email varchar(255),
@daytimeContactAreaCode varchar(10),
@daytimeContactNumber varchar(20),
@homeLandlineAreaCode varchar(10),
@homeLandlineNumber varchar(20),
@addrAptNumber varchar(50),
@addrHouseNumber varchar(50),
@addrHouseName varchar(50),
@addrStreetName varchar(50),
@addrLocality varchar(50),
@addrTownCity varchar(50),
@addrCounty varchar(50),
@addrCountry varchar(50),
@memorableName varchar(50),
@memorablePlace varchar(50)
as
begin

begin transaction 

	update h3giRegistration
	set 	title = @title,
		firstname = @firstname,
		middleInitial = @middleInitial,
		surname = @surname,
		gender = @gender,
		dobDay = @dobDay,
		dobMonth = @dobMonth,
		dobYear = @dobYear,
		email = @email,
		daytimeContactAreaCode = @daytimeContactAreaCode,
		daytimeContactNumber = @daytimeContactNumber,
		homeLandlineAreaCode = @homeLandlineAreaCode,
		homeLandlineNumber = @homeLandlineNumber,
		addrAptNumber = @addrAptNumber,
		addrHouseNumber = @addrHouseNumber,
		addrHouseName = @addrHouseName,
		addrStreetName = @addrStreetName,
		addrLocality = @addrLocality,
		addrTownCity = @addrTownCity,
		addrCounty = @addrCounty,
		addrCountry = @addrCountry,
		memorableName = @memorableName,
		memorablePlace = @memorablePlace
	where orderref = @orderref

if (@@error <> 0)
begin
	rollback transaction
end
else
begin
	commit transaction
end

end



GRANT EXECUTE ON h3giUpdateRegistrationDetails TO b4nuser
GO
