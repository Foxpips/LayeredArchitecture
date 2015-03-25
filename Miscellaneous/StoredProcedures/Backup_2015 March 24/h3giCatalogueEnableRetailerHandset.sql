

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueEnableRetailerHandset
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.1.0
**
**	Changes			:
**						19/02/2007 - Adam Jasinski - added @prepayUpgrade support
**********************************************************************************************************************
**				
** Description		:	Enables/disables handsets available for retailers.
**	
**						Specify @peopleSoftId 
**						and optionally @contract, @prepay and @contractUpgrade flags (by default all are set to 1)
**						to determine which handset types should be enabled/disabled.
**
** Parameters		:	@catalogueVersionId
**						@channelCode
**						@retailerCode
**						@peopleSoftId - PeopleSoftID of selected handset
**						@contract - 1: add contract handset to list of enabled handsets (if @enable==1, otherwise add to list of disabled handsets)
**						@prepay - 1: add prepay handset to list of enabled handsets (if @enable==1, otherwise add to list of disabled handsets)
**						@contractUpgrade - 1: add contract upgrade handset to list of enabled handsets (if @enable==1, otherwise add to list of disabled handsets)
**						@prepayUpgrade - 1: add prepay upgrade handset to list of enabled handsets (if @enable==1, otherwise add to list of disabled handsets)
**						@affinityGroupId - value for affinityGroupId: NULL - everyone; 1 - consumers only; N - specific affinity group
**						@negateAffinityGroupId: 1 - negate given affinity groun; 0 - don't negate
**						@enable : 1 - enable; 0 - disable; other values are ignored
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCatalogueEnableRetailerHandset]
	@catalogueVersionId int = NULL,
	@channelCode varchar(20),
	@retailerCode varchar(20), 
	@peopleSoftId varchar(50),
	@contract bit = 1,
	@prepay bit = 1,
	@contractUpgrade bit = 1,
	@prepayUpgrade bit = 1,
	@affinityGroupId int = NULL,
	@negateAffinityGroupId bit = 0,
	@enable bit = 1
AS
BEGIN

IF @catalogueVersionId IS NULL	SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion();

	DECLARE @handsetTypeSet TABLE (prepayValue int PRIMARY KEY);

	IF @contract=1 INSERT INTO @handsetTypeSet VALUES (0);
	IF @prepay=1 INSERT INTO @handsetTypeSet VALUES (1);
	IF @contractUpgrade=1 INSERT INTO @handsetTypeSet VALUES (2);
	IF @prepayUpgrade=1 INSERT INTO @handsetTypeSet VALUES (3);

	--Insert into RetailerHandset the difference of these two sets:
	--1) handsets with given @catalogueVersionId and @peopleSoftId,
	--   AND given @contract, @prepay, and @contractUpgrade values
	--2) handsets with given @catalogueVersionId and @peopleSoftId
	--	 that already exist in RetailerHandset table (for given channel, retailer and affinity)

IF @enable = 1		--enable handsets
BEGIN
	INSERT INTO h3giRetailerHandset
		   ([channelCode]
		   ,[retailerCode]
		   ,[catalogueVersionID]
		   ,[catalogueProductID]
		   ,[affinityGroupId]
			,[negateAffinityGroupId])
		SELECT @channelCode, @retailerCode, pc.catalogueVersionId, pc.catalogueProductID, @affinityGroupId, @negateAffinityGroupId
		FROM h3giProductCatalogue AS pc 
		WHERE  pc.catalogueVersionId = @catalogueVersionId
		AND pc.peopleSoftID = @peopleSoftId
		AND pc.Prepay IN (SELECT prepayValue FROM @handsetTypeSet)
		AND NOT EXISTS (
				SELECT * FROM h3giRetailerHandset rh
				WHERE rh.channelCode = @channelCode AND rh.retailerCode = @retailerCode
				AND rh.catalogueVersionId = pc.catalogueVersionId 
				AND rh.catalogueProductId = pc.catalogueProductId
				AND rh.affinityGroupID = @affinityGroupId
				AND rh.negateAffinityGroupId = @negateAffinityGroupId
				);
END
ELSE IF @enable = 0		--disable handsets
BEGIN
	DELETE FROM h3giRetailerHandset
	WHERE channelCode = @channelCode
	AND retailerCode = @retailerCode
	AND catalogueVersionId = @catalogueVersionId
	AND (@affinityGroupId IS NULL OR (affinityGroupId = @affinityGroupId	AND negateAffinityGroupId = @negateAffinityGroupId))
	AND EXISTS
	(SELECT * FROM h3giProductCatalogue AS pc 
	 WHERE pc.catalogueVersionId = @catalogueVersionId
	 AND pc.peopleSoftId = @peopleSoftID
	 AND pc.prepay  IN (SELECT prepayValue FROM @handsetTypeSet)
	 AND pc.catalogueProductId = h3giRetailerHandset.catalogueProductId
    );
END

--DIAGNOSTICS - to be commented out
--	SELECT  rh.channelCode, rh.retailerCode, rh.catalogueVersionID, 
--			rh.catalogueProductID, pc.PrePay, pc.peoplesoftID
--	FROM    h3giRetailerHandset rh
--	INNER JOIN h3giProductCatalogue AS pc 
--	ON rh.catalogueVersionID = pc.catalogueVersionID 
--	AND  rh.catalogueProductID = pc.catalogueProductID
--	WHERE pc.catalogueVersionId = @catalogueVersionId
--	AND pc.peopleSoftID = @peopleSoftId
--	AND rh.channelCode = @channelCode AND rh.retailerCode = @retailerCode

END





GRANT EXECUTE ON h3giCatalogueEnableRetailerHandset TO b4nuser
GO
