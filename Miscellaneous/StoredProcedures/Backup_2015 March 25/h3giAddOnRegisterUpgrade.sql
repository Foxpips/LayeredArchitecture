
CREATE PROCEDURE dbo.h3giAddOnRegisterUpgrade 
	@addOnPeoplesoftId varchar(20),
	@billingAccountNumber varchar(10)
AS
BEGIN
	DECLARE @Message VARCHAR(100)	
	DECLARE @addOnId INT
	DECLARE @upgradeId INT

	SELECT TOP 1 @addOnId = addOnId
	FROM h3giAddOn a
	INNER JOIN h3giProductCatalogue pc
		ON a.catalogueProductId = pc.catalogueProductId
		AND a.catalogueVersionId = pc.catalogueVersionId
	WHERE pc.peoplesoftId = @addOnPeoplesoftId AND pc.productType = 'ADDON'
	ORDER BY a.catalogueVersionId DESC

	IF @addOnId IS NULL
	BEGIN
		SET @Message = 'AddOn ' + @addOnPeoplesoftId + ' could not be found'
		RAISERROR( @Message,1,1 ) WITH NOWAIT

		RETURN -1
	END

	SELECT @upgradeId = upgradeId FROM h3giUpgrade
	WHERE billingAccountNumber = @billingAccountNumber

	IF @upgradeId IS NULL
	BEGIN
		SET @Message = 'Upgrade customer with BAN ' + @billingAccountNumber + ' could not be found'
		RAISERROR( @Message,1,1 ) WITH NOWAIT

		RETURN -2
	END

	IF EXISTS (SELECT * FROM h3giUpgradeAddOn WHERE upgradeId = @upgradeId AND addOnId = @addOnId)
	BEGIN
		SET @Message = 'Upgrade customer with BAN ' + @billingAccountNumber + ' already had Add On ' + @addOnPeoplesoftId
		RAISERROR( @Message,1,1 )

		RETURN 1
	END
	ELSE
	BEGIN
		INSERT INTO h3giUpgradeAddOn
		VALUES (@upgradeId, @addOnId)
	END

	IF @@ERROR <> 0
		RETURN -3
	ELSE
		RETURN 0
END

GRANT EXECUTE ON h3giAddOnRegisterUpgrade TO b4nuser
GO
GRANT EXECUTE ON h3giAddOnRegisterUpgrade TO ofsuser
GO
GRANT EXECUTE ON h3giAddOnRegisterUpgrade TO reportuser
GO
