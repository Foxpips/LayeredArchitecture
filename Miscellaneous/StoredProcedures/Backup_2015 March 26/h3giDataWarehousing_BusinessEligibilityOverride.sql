




/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giDataWarehousing_BusinessEligibilityOverride
** Author			:	Simon Markey
** Date Created		:	31/05/2005
** Version			:	1
**					
**********************************************************************************************************************
**				
** Description		:	returns customer details for completed Accessory Sales
**					
**********************************************************************************************************************
**									
** Change Control	:	
**									
**											
**********************************************************************************************************************/

--exec h3giDataWarehousing_BusinessEligibilityOverride

CREATE PROC [dbo].[h3giDataWarehousing_BusinessEligibilityOverride]
	@endDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @endDateMorning DATETIME
	SET @endDateMorning = DATEADD(dd, DATEDIFF(dd, 0, @endDate), 0)
	
	DECLARE @startDate DATETIME
	SET @startDate = DATEADD(dd,-7,@endDateMorning)

	 SELECT audit.dateChanged [Date / Time of Change],
			smusers.nameOfUser AS 'User ID',
			audit.childBan [Ban],
			CASE audit.newStatus WHEN 'N' THEN 'Ineligible'
			WHEN 'Y' THEN 'Eligible' END AS 'New Status'
			--audit.id,
			--smusers.nameOfUser
	 FROM h3gi..threeEligibilityOverrideAuditLog audit
		LEFT OUTER JOIN h3gi..threeUpgrade upgrade ON audit.userId = upgrade.upgradeId
		LEFT OUTER JOIN h3gi..smApplicationUsers smusers ON smusers.userId = audit.processedBy
	 WHERE audit.dateChanged < @EndDate AND audit.dateChanged > @StartDate
	 ORDER BY audit.dateChanged DESC
END   



GRANT EXECUTE ON h3giDataWarehousing_BusinessEligibilityOverride TO b4nuser
GO
