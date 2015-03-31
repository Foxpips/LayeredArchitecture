


/*********************************************************************************************************************
**                                                                                                                            
** Procedure Name :     h3giCleanOrdersFromQueue
** Author               :     Kevin Roche
** Date Created         :     July 2005
** Version              :     1.0.2
**                            
**********************************************************************************************************************
**                      
** Description          :     marks 3rd Party Retail orders not at a final status after 2 days as cancelled
**                            
**********************************************************************************************************************
**                                                    
** Change Control :     11/08/2005 - Gearóid Healy - now sets credit analyst id as blank
**                                                    
** Change Control :     16/08/2005 - Gearóid Healy - cancels orders older than 72 hours now, not 48 hours
**
**                            :     12/03/2007 - Adam Jasinski - added own retail orders support
**                
**                            :     01/06/2010 - Stephen Quin - Orders will now be cancelled after 10 days
**                  
**                  :   18/04/2010 - Stephen Mooney - Add cancellation reason to h3giOrderCancelReason
**
**                            :     18/05/2012 - Stephen Quin - Orders will now be cancelled after 30 days
**							  :		05/12/2013 - Smarkey - Increased queue to 20 days
**********************************************************************************************************************/


CREATE    Procedure [dbo].[h3giCleanOrdersFromQueue]
AS

Begin       
      declare @OrderRefTable table (orderref int)

      insert into @OrderRefTable
      SELECT b.orderref
      from h3giOrderHeader h with(nolock)
      join b4nOrderHeader b with(nolock) on h.orderref = b.orderref
      where h.channelcode in ('UK000000293', 'UK000000292')
      and b.status in (300,302,311,402,405) -- ordered,pending,approved
      and b.orderdate < dateadd(dd,-10,getdate()) -- SM: This value was 10 before extended for iphone 5 release

      -- set order status to cancelled
      UPDATE b4norderheader
      SET status = 301 
      WHERE orderref in (select orderref from @OrderRefTable)

      -- set creditanalystid to blank in history table for this new status change
      UPDATE b4norderhistory
      SET creditanalystid = ''
      WHERE orderref in (select orderref from @OrderRefTable)
      AND orderstatus = 301 
      
      -- Add cancellation reason to h3giOrderCancelReason
      DECLARE @AutoCancelCode INT
      SELECT @AutoCancelCode = b4nclasscode 
            FROM b4nClassCodes
      WHERE b4nClassSysID = 'CancelReasonTextCode'
            AND b4nClassDesc = 'Automated Cancellation'
      
      INSERT INTO h3giOrderCancelReason
            SELECT      orderref AS orderRef,
                        GETDATE() AS reasonDate,
                        @AutoCancelCode AS reasonDescriptionId,
                        0 AS userId
            FROM @OrderRefTable
END









GRANT EXECUTE ON h3giCleanOrdersFromQueue TO b4nuser
GO
