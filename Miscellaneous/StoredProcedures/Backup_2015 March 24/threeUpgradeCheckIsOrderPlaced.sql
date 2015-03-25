
 
-- =========================================================  
-- Author:  Simon Markey 
-- Create date: 07/05/2013  
-- Description: Checks if an order has recently been placed 
-- =========================================================  
CREATE PROCEDURE [dbo].[threeUpgradeCheckIsOrderPlaced]   
 	@upgradeIdList h3giIds READONLY
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
 IF EXISTS (SELECT 1 FROM threeupgrade WHERE upgradeId IN(SELECT Id FROM @upgradeIdList) AND dateUsed + 14 > GETDATE())
  BEGIN
	RETURN 1   
  END
 ELSE
  BEGIN   
	RETURN 0   
  END     
END  


GRANT EXECUTE ON threeUpgradeCheckIsOrderPlaced TO b4nuser
GO
