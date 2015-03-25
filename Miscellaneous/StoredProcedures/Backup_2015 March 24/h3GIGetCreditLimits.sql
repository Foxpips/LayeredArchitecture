


/****** Object:  Stored Procedure dbo.h3GIGetCreditLimits    Script Date: 23/06/2005 13:35:00 ******/
CREATE PROCEDURE [dbo].[h3GIGetCreditLimits]  
AS

SELECT LimitID, Limit, Shadow FROM h3GICreditLimits
ORDER BY Limit




GRANT EXECUTE ON h3GIGetCreditLimits TO b4nuser
GO
GRANT EXECUTE ON h3GIGetCreditLimits TO ofsuser
GO
GRANT EXECUTE ON h3GIGetCreditLimits TO reportuser
GO
