


/*********************************************************************************************************************
**																					
** Procedure Name	:	threeGetUpgradeAccountByBan
** Author			:	Simon Markey
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec Sproc_Name 1, 'Test', 1
**********************************************************************************************************************
**				
** Description		:	new stored procedure to search for business bans for upgrade orders
**					
**********************************************************************************************************************
**				
** Change Log		:	08/05/2013	-	Stephen Quin	-	approved blended discounts now applied
**					
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[threeGetUpgradeAccountByBan]
	@BAN VARCHAR(10)
AS
BEGIN
	
	DECLARE @upgradeData TABLE
	(
		upgradeId INT,
		msisdn NVARCHAR(13),
		childBAN NVARCHAR(10) PRIMARY KEY,
		parentBAN NVARCHAR(10),
		accountType INT,
		companyName NVARCHAR(100),
		authorisedContactName NVARCHAR(100),
		userName NVARCHAR(100),
		contractEndDate DATETIME,
		parentTariff NVARCHAR(12),
		childTariff NVARCHAR(12),
		parentAddOns NVARCHAR(255),
		childAddOns NVARCHAR(255),
		houseNumber NVARCHAR(10),
		houseName NVARCHAR(40),
		street NVARCHAR(40),
		locality NVARCHAR(40),
		town VARCHAR(40),
		countyId INT,
		contactNumAreaCode NVARCHAR(4),
		contactNumMain NVARCHAR(7),
		emailAddress NVARCHAR(255),
		eligibilityStatus INT,
		band VARCHAR(10),		
		bandValue INT,
		bandName VARCHAR(100),
		dateUsed DATETIME,
		blendedDiscountCaseNum INT,
		originalBand VARCHAR(10)
	)

	DECLARE @blendedDiscountData TABLE
	(
		caseId INT,
		endUserBan NVARCHAR(10) PRIMARY KEY,
		incomingBand VARCHAR(10),
		potentialNewBand VARCHAR(10)
	)

	INSERT INTO @upgradeData
		SELECT	upgradeId,
				msisdn,
				childBAN,
				parentBAN,
				accountType,
				companyName,
				authorisedContactName,
				userName,
				contractEndDate,
				parentTariff,
				childTariff,
				ISNULL(parentAddOns,'') AS parentAddOns,
				ISNULL(childAddOns,'') AS childAddOns,
				ISNULL(houseNumber,'') AS houseNumber,
				ISNULL(houseName,'') AS houseName,
				ISNULL(locality,'') AS locality,
				ISNULL(street,'') AS street,
				town,
				countyId,
				contactNumAreaCode,
				contactNumMain,
				emailAddress,
				eligibilityStatus,
				band,
				bandvalue,
				cc.b4nClassDesc,
				dateUsed,
				0,
				band
		FROM threeUpgrade upg
		INNER JOIN threeUpgradeBandValues upv
			ON upv.bandcode = upg.band
		INNER JOIN b4nClassCodes cc
			ON upg.band = cc.b4nClassCode
			AND cc.b4nClassSysID = 'BusinessUpgradeBand'
		WHERE(upg.childBan = @BAN 
		OR upg.parentBAN = @BAN)
		AND upg.eligibilityStatus NOT IN (0)


	DECLARE @parentBAN varchar(10), @caseId INT

	SELECT @parentBan = parentBAN
	FROM threeUpgrade
	WHERE (parentBAN = @BAN OR childBAN = @BAN)
	AND eligibilityStatus NOT IN (0)

	SELECT TOP 1 @caseId = Id
	FROM threeUpgradeBlendedDiscountCase
	WHERE parentBan = @parentBAN
	AND status IN (2,5)
	AND createdDate BETWEEN DATEADD(dd,-14,GETDATE()) AND GETDATE()
	ORDER BY createdDate DESC
	

	INSERT INTO @blendedDiscountData
	SELECT	caseId,
			endUserBan,
			incomingBand,
			potentialNewBand
	FROM threeUpgradeBlendedDiscountCaseItem	
	WHERE caseId = @caseId

	UPDATE @upgradeData
	SET band = bdd.potentialNewBand,
		blendedDiscountCaseNum = bdd.caseId,
		bandValue = bv.bandValue,
		bandName = cc.b4nClassDesc,
		originalBand = bdd.incomingBand
	FROM @blendedDiscountData bdd
	INNER JOIN @upgradeData ud
		ON bdd.endUserBan = ud.childBAN
	INNER JOIN threeUpgradeBandValues bv
		ON bv.bandcode = bdd.potentialNewBand
	INNER JOIN b4nClassCodes cc
		ON bdd.potentialNewBand = cc.b4nClassCode
		AND cc.b4nClassSysID = 'BusinessUpgradeBand'

	SELECT * FROM @upgradeData
END


GRANT EXECUTE ON threeGetUpgradeAccountByBan TO b4nuser
GO
