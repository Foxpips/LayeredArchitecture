

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetHandsetRiskList 
** Author		:	Attila Pall
** Date Created		:	10/01/2007
**					
**********************************************************************************************************************
**				
** Description		:	Retrieves risk levels by peoplesoft ids
**					
**********************************************************************************************************************
**									
** Change Control	:	03/09/2007- Attila Pall	- Created
**********************************************************************************************************************/

CREATE           PROCEDURE dbo.h3giGetHandsetRiskList
AS
BEGIN
	DECLARE @catalogueVersionId INT
	
	SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()

	select distinct
	productName,
	peoplesoftId,
	riskLevel
	from h3giProductCatalogue 
	where catalogueVersionId = @catalogueVersionId
	and productType = 'HANDSET'
	and validStartDate < GETDATE() AND validEndDate > GETDATE()
END






GRANT EXECUTE ON h3giGetHandsetRiskList TO b4nuser
GO
GRANT EXECUTE ON h3giGetHandsetRiskList TO ofsuser
GO
GRANT EXECUTE ON h3giGetHandsetRiskList TO reportuser
GO
