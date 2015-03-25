

/****** Object:  Stored Procedure dbo.H3GIReport_LOG_BAT    Script Date: 23/06/2005 13:30:52 ******/
CREATE PROC dbo.H3GIReport_LOG_BAT
/*********************************************************************************************************************																				
* Procedure Name	: H3GIReport_LOG_BAT
* Author		: Niall Carroll
* Date Created		: 16/05/2005
* Version		: 1.0.0	
*					
**********************************************************************************************************************
* Description		: (D9 – Order Batch Summary) 
			  Overview of batch’s created between 2 dates or for a specific batch number
**********************************************************************************************************************/

@BatchID		int 		= null,
@BatchStatus		int		= null,
@BatchCreateDateFrom	DateTime	= null,
@BatchCreateDateTo	DateTime	= null


AS
DECLARE @SQL NVARCHAR(4000)

SET @SQL = 
'SELECT
	B.BatchID as BatchRef, 
	B.Courier as Carrier, 
	Count(OrderRef) as OrderCount, 
	B.CreateDate as BatchCreateDate,
	Case B.SearchOutOfStock
		WHEN 0 THEN ''New Order''
		WHEN 1 THEN ''Out Of Stock''
	END as BatchOrderStatusBase,
	b4nClassDesc as CurrentBatchStatus,
	ModifyDate as CurrentBatchStatusDate
FROM h3giBatch B 
	inner join h3giBatchOrder BO on B.BatchID = BO.BatchID
	inner join b4nClassCodes BCC on B.Status = Cast(b4nClassCode as int) AND b4nClassSysID = ''BatchStatus''
WHERE 1 = 1'

IF @BatchID 		is NOT NULL 
BEGIN 
	SET @SQL = @SQL + ' AND B.BatchID = ' + Cast(@BatchID as nvarchar(10))
END
ELSE
BEGIN 
	IF @BatchStatus 	is NOT NULL SET @SQL = @SQL + ' AND B.Status = ' + Cast(@BatchStatus as nvarchar(10))
	IF @BatchCreateDateFrom	is NOT NULL SET @SQL = @SQL + ' AND B.SearchDateFrom = ''' + Cast (@BatchCreateDateFrom as nvarchar(25)) + ''
	IF @BatchCreateDateTo	is NOT NULL SET @SQL = @SQL + ' AND B.SearchDateTo = ''' + Cast (@BatchCreateDateTo as nvarchar(25)) + ''
END

SET @SQL = @SQL + 'GROUP BY B.BatchID, B.Courier, B.CreateDate, B.SearchOutOfStock, b4nClassDesc, ModifyDate'

PRINT @SQL

EXEC sp_executesql @SQL


GRANT EXECUTE ON H3GIReport_LOG_BAT TO b4nuser
GO
GRANT EXECUTE ON H3GIReport_LOG_BAT TO helpdesk
GO
GRANT EXECUTE ON H3GIReport_LOG_BAT TO ofsuser
GO
GRANT EXECUTE ON H3GIReport_LOG_BAT TO reportuser
GO
GRANT EXECUTE ON H3GIReport_LOG_BAT TO b4nexcel
GO
GRANT EXECUTE ON H3GIReport_LOG_BAT TO b4nloader
GO
