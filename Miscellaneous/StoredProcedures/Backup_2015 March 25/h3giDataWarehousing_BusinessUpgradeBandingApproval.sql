


/*********************************************************************************************************************
**												
** Procedure Name	:	h3giDataWarehousing_BusinessUpgradeBandingApproval
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

--exec h3giDataWarehousing_BusinessUpgradeBandingApproval '20/09/2013'

CREATE PROC [dbo].[h3giDataWarehousing_BusinessUpgradeBandingApproval]
	@endDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @endDateMorning DATETIME
	SET @endDateMorning = DATEADD(dd, DATEDIFF(dd, 0, @endDate), 0)
	
	DECLARE @startDate DATETIME
	SET @startDate = DATEADD(dd,-7,@endDateMorning)

CREATE TABLE #temp(
caseid INT,
casedesc VARCHAR(50)
)

INSERT INTO #temp VALUES(0,'None')
INSERT INTO #temp VALUES(1,'Open')
INSERT INTO #temp VALUES(2,'Approved')
INSERT INTO #temp VALUES(3,'Declined')
INSERT INTO #temp VALUES(4,'Closed')
INSERT INTO #temp VALUES(5,'Used')

	 SELECT 
	 blend.createdDate AS 'Date / Time of Change',
	 smusers2.nameOfUser AS 'Requesting User ID',
	 smusers.nameOfUser AS 'Approving User ID',
	 item.endUserBan AS 'BAN',
	 item.incomingBand AS 'Original Band',
	 item.potentialNewBand AS 'Updated Band',
	 item.caseId AS 'Case ID'
	 --blend.decisionDate AS 'Date Decided',
	 --blend.id AS 'Case Number', 
	 --blend.parentBAN AS 'Parent Ban',
	 --temp.casedesc AS 'Status'
	 
	 FROM h3gi..threeUpgradeBlendedDiscountCase blend
	 LEFT OUTER JOIN 
		h3gi..smApplicationUsers smusers 
		ON blend.userProcessed = smusers.userId
	 LEFT OUTER JOIN 
		h3gi..smApplicationUsers smusers2
		ON blend.userSubmitted = smusers2.userId
	 LEFT OUTER JOIN #temp temp
		ON temp.caseid = blend.status
	 INNER JOIN 
		h3gi..threeUpgradeBlendedDiscountCaseItem item 
		ON item.caseId = blend.id
	 WHERE blend.status IN(2,5)
	 	AND blend.createdDate > @StartDate
		AND blend.decisionDate <@EndDate	 
	 ORDER BY blend.createdDate DESC
END   


GRANT EXECUTE ON h3giDataWarehousing_BusinessUpgradeBandingApproval TO b4nuser
GO
