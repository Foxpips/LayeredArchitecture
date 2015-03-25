/*********************************************************************************************************************																				
* Procedure Name	: [h3giOrderAmalgationSearch]
* Author			: Niall Carroll
* Date Created		: 21/03/2006
* Version			: 1.0.0
*					
**********************************************************************************************************************
* Description		: Searches for Orders which have CC numbers for differnt Orders (if that makes sence :P)
**********************************************************************************************************************
* Change Control	: 
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giOrderAmalgationSearch]
	@BatchStatus 	int = -1,
	@OrderDateFrom 	varchar(50) = '',
	@OrderDateTo 	varchar(50) = '',
	@Courier 		varchar(50) = ''
AS

SELECT 
	DISTINCT BOH.OrderRef, BOH.ccNumber, -1 as SearchID 
INTO 
	#AllRecords
FROM b4nOrderHeader  BOH
	INNER join h3gibatchOrder HBO 	ON BOH.OrderRef = HBO.OrderRef
	INNER join h3giBatch HB 		ON HBO.BatchID = HB.BatchID
	--INNER join b4nClassCodes SCode 	ON SCode.b4nClassSysID = 'BatchStatus' AND SCode.b4nClassCode = Cast(HB.Status as varchar(2))
WHERE ccNumber in (SELECT ccNumber FROM b4nOrderHeader WHERE ccNumber = BOH.ccNumber AND OrderRef <> BOH.OrderRef)
AND
	((@BatchStatus = -1) OR (HB.Status = @BatchStatus))
AND
	((@OrderDateFrom = '') OR (BOH.OrderDate > @OrderDateFrom))
AND
	((@OrderDateTo = '') OR (BOH.OrderDate < @OrderDateTo))
AND
	((@Courier = '') OR (HB.Courier = @Courier))
AND 
LEN(BOH.ccNumber) > 0
Order BY BOH.ccNumber, BOH.OrderRef


CREATE TABLE #Summary (ccNumber varchar(50), SearchID int, Amt int)


DECLARE CC cursor for
SELECT ccNumber, Count(*) from #AllRecords group by ccNumber

OPEN CC

DECLARE @ccDistinct varchar(50)
DECLARE @Count int
DECLARE @CurrentRow int

SET @CurrentRow = 0
FETCH NEXT FROM CC INTO @ccDistinct, @Count

WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE #AllRecords SET SearchID = @CurrentRow WHERE #AllRecords.ccNumber = @ccDistinct
	INSERT INTO #Summary (ccNumber , SearchID, Amt) VALUES (@ccDistinct, @CurrentRow, @Count)
	SET	@CurrentRow = @CurrentRow + 1
	PRINT @CurrentRow
	FETCH NEXT FROM CC INTO @ccDistinct, @Count
END

SELECT * FROM #AllRecords
SELECT * FROM #Summary

DROP TABLE #AllRecords
DROP TABLE #Summary

CLOSE CC
DEALLOCATE CC



GRANT EXECUTE ON h3giOrderAmalgationSearch TO b4nuser
GO
GRANT EXECUTE ON h3giOrderAmalgationSearch TO ofsuser
GO
GRANT EXECUTE ON h3giOrderAmalgationSearch TO reportuser
GO
