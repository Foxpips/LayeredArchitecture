
/*********************************************************************************************************************
**                                                                                                                                                                                                                                                          
** Procedure Name	:	h3giImportUpgrades
** Author		:	Attila Pall
** Date Created		:	04/07/2006
**                                                          
**********************************************************************************************************************
**                                              
** Description		:  	Inserts a new Customer who got an upgrade, or updates the data of an existing customer
**				based on the data 3 sent
**                                                          
**********************************************************************************************************************
**                                                                                                          
** Change Control	:	1.0.0 – 29/06/2006	- Attila Pall	– Created sproc
**				2.0.0 - 13/07/2006	- Attila Pall	- Modified to use the new h3giUpgrade table
**
**********************************************************************************************************************/


CREATE PROCEDURE DBO.h3giImportUpgrades
	@ban varchar(50),
	@bandCode char(1),
	@tariffCode varchar(7),
	@title varchar(12),
	@nameFirst varchar(30),
	@middleNameInitials varchar(5),
	@nameLast varchar(30),
	@addrHouseNumber varchar(10),
	@addrHouseName varchar(100),
	@addrStreetName varchar(100),
	@addrLocality varchar(100),
	@addrTown varchar(100),
	@addrCounty varchar(100) ,
	@DateOfBirth datetime,
	@email varchar(100),
	@mobileNumberAreaCode varchar(4),
	@mobileNumberMain varchar(7),
	@dayTimeContactNumberAreaCode varchar(4),
	@dayTimeContactNumberMain varchar(7)
AS
BEGIN

	DECLARE @Message varchar (100)
	DECLARE @addrCountyClassCode varchar(50)
	DECLARE @UpgradeId int
	
	
	BEGIN TRANSACTION customerUpgrade

	--SELECT @bandId = BandID FROM dbo.h3giBandCodes WHERE BandCode = @bandCode
	RAISERROR( 'Need to check if the Band exists or not',10,1 )

	SET @Message = 'Need to check if the Band ' + @bandCode + ' exists or not '
	EXEC h3GiLogAuditEvent 0, 2110,  @Message, 0
	
	SELECT @addrCountyClassCode = b4nClassCode FROM b4nClassCodes WHERE b4nClassSysId = 'SubCountry' AND b4nClassDesc = @addrCounty				
	
	IF @addrCountyClassCode IS NULL
	BEGIN
		ROLLBACK TRANSACTION customerUpgrade

		SET @Message = 'Unrecognized County: ' + @addrCounty

		EXEC h3GiLogAuditEvent 0, 2111,  @Message, 0

		RAISERROR( @Message,16,2 ) WITH NOWAIT
		RETURN -2111
	END

	IF ( SELECT COUNT(*) FROM h3giUpgrade WHERE BillingAccountNumber = @ban AND DateUsed IS NULL ) > 0
	BEGIN
		UPDATE h3giUpgrade
			SET DateUsed = GetDate()
		WHERE BillingAccountNumber = @ban AND DateUsed IS NULL

		SET @Message = 'Customer with BAN ' + @ban + ' had an unused upgrade. The existing upgrade has been deactivated'
		EXEC h3GiLogAuditEvent 0, 2112,  @Message, 0
	END
	
	INSERT INTO dbo.h3giUpgrade (
		BillingAccountNumber,
		Band,
		PeoplesoftID,
		title,
		nameFirst,
		nameMiddleInitial,
		nameLast,
		addrHouseNumber,
		addrHouseName,
		addrStreetName,
		addrLocality,
		addrTown,
		addrCountyId,
		dateOfBirth,
		email,
		mobileNumberAreaCode,
		mobileNumberMain,
		dayTimeContactNumberAreaCode,
		dayTimeContactNumberMain,
		DateAdded)
	VALUES (
		@ban,
		@bandCode,
		@tariffCode,
		@title,
		@nameFirst,
		@middleNameInitials,
		@nameLast,
		@addrHouseNumber,
		@addrHouseName,
		@addrStreetName,
		@addrLocality,
		@addrTown,
		@addrCountyClassCode,
		@DateOfBirth,
		@email,
		@mobileNumberAreaCode,
		@mobileNumberMain,
		@dayTimeContactNumberAreaCode,
		@dayTimeContactNumberMain,
		GETDATE()
		)
	
	SET @UpgradeId = SCOPE_IDENTITY()

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION customerUpgrade
		return -1
	END
	ELSE
	BEGIN
		COMMIT TRANSACTION customerUpgrade
		return 0
	END

END

GRANT EXECUTE ON h3giImportUpgrades TO b4nuser
GO
GRANT EXECUTE ON h3giImportUpgrades TO ofsuser
GO
GRANT EXECUTE ON h3giImportUpgrades TO reportuser
GO
