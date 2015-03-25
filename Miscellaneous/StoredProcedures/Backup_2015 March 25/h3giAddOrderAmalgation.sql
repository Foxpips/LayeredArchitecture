/*********************************************************************************************************************																				
* Procedure Name	: [h3giAddOrderAmalgation]
* Author			: Niall Carroll
* Date Created		: 29/03/2006
* Version			: 1.0.0
*					
**********************************************************************************************************************
* Description		: Adds an Order Amalg association
**********************************************************************************************************************
* Change Control	: 
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giAddOrderAmalgation]
@OrderRefList varchar(4000)
AS

DECLARE @AmalgID int
SELECT @AmalgID = (MAX(AmalgamationID) + 1) FROM h3giAmalgamatedOrder

INSERT INTO h3giAmalgamatedOrder (AmalgamationID, OrderRef, DateAdded)
SELECT @AmalgID, Value, GetDate() FROM fnSplitter(@OrderRefList)

GRANT EXECUTE ON h3giAddOrderAmalgation TO b4nuser
GO
GRANT EXECUTE ON h3giAddOrderAmalgation TO ofsuser
GO
GRANT EXECUTE ON h3giAddOrderAmalgation TO reportuser
GO
