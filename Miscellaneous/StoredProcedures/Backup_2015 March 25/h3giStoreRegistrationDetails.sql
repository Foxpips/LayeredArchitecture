

create proc [dbo].[h3giStoreRegistrationDetails]
/*********************************************************************************************************************
**                                                                                                              
** Procedure Name    :    h3giStoreRegistrationDetails
** Author            :    John Hannon
** Date Created      :    03/03/06
**                         
**********************************************************************************************************************
**                   
** Description       :    Stores the registration details attached to the order - for PrePay
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
	INSERT INTO [dbo].[h3giRegistration]
		([orderref]
		,[title]
		,[firstname]
		,[middleInitial]
		,[surname]
		,[gender]
		,[dobDay]
		,[dobMonth]
		,[dobYear]
		,[email] 
		,[daytimeContactAreaCode] 
		,[daytimeContactNumber] 
		,[homeLandlineAreaCode] 
		,[homeLandlineNumber] 
		,[addrAptNumber]
		,[addrHouseNumber] 
		,[addrHouseName]
		,[addrStreetName] 
		,[addrLocality] 
		,[addrTownCity] 
		,[addrCounty] 
		,[addrCountry] 
		,[memorableName] 
		,[memorablePlace])
	VALUES
		(@orderref
		,@title
		,@firstname
		,@middleInitial
		,@surname
		,@gender
		,@dobDay
		,@dobMonth
		,@dobYear
		,@email
		,@daytimeContactAreaCode
		,@daytimeContactNumber
		,@homeLandlineAreaCode
		,@homeLandlineNumber
		,@addrAptNumber
		,@addrHouseNumber
		,@addrHouseName
		,@addrStreetName
		,@addrLocality
		,@addrTownCity
		,@addrCounty
		,@addrCountry
		,@memorableName
		,@memorablePlace)

if (@@error <> 0)
begin
	rollback transaction
end
else
begin
	commit transaction
end

end



GRANT EXECUTE ON h3giStoreRegistrationDetails TO b4nuser
GO
