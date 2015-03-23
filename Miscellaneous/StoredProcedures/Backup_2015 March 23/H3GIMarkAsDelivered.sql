

CREATE  PROCEDURE dbo.H3GIMarkAsDelivered AS

/*********************************************************************************************************************																				
* Procedure Name	: H3GIMarkAsDelivered
* Author		: Niall Carroll
* Date Created		: 08/06/2005
* Version		: 1.1.0
*					
**********************************************************************************************************************
* Description		: Mark orders as delivered (if the are in dispacthed for 7 days)
**********************************************************************************************************************
**********************************************************************************************************************
* Change Control	: 12/06/2005 - Niall Carroll : Sets Sprint status as well
* V1.1.0		: 29/06/2005 - Niall Carroll : Excluded all Buy4NowLogistics by excluding dublin county addresses
**********************************************************************************************************************/


DECLARE @B4NDB 	varchar(25)
DECLARE @SQL	varchar(200)

SELECT @B4NDB = idValue FROM config WHERE idName = 'h3giDB'

SELECT 	GMOH.orderRef into #delTemp
FROM	gmOrderHeader GMOH inner join gmAddress GMA ON GMA.addressID = GMOH.delAddrID AND GMA.county != 'Dublin'
WHERE 	GMOH.StatusID = 3 
AND 	GMOH.statusDate < DateAdd(dd, -7 ,GetDate())


UPDATE 	gmOrderHeader 
SET 	StatusID = 4, 
	modifyDate = Getdate(), 
	statusDate = Getdate()
WHERE 	OrderRef in (SELECT orderRef FROM #delTemp)

SELECT @SQL =
'UPDATE ' + @B4NDB + '..b4nOrderHeader SET Status = 310 
WHERE OrderRef in (SELECT orderRef FROM #delTemp)
AND		Status = 309'

EXEC (@SQL)

GRANT EXECUTE ON H3GIMarkAsDelivered TO b4nuser
GO
GRANT EXECUTE ON H3GIMarkAsDelivered TO helpdesk
GO
GRANT EXECUTE ON H3GIMarkAsDelivered TO ofsuser
GO
GRANT EXECUTE ON H3GIMarkAsDelivered TO reportuser
GO
GRANT EXECUTE ON H3GIMarkAsDelivered TO b4nexcel
GO
GRANT EXECUTE ON H3GIMarkAsDelivered TO b4nloader
GO
