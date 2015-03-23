

/*********************************************************************************************************************  
**                       
** Procedure Name : dbo.threeBusinessOrderCreate  
** Author   : Adam Jasinski   
** Date Created  :   
**       
**********************************************************************************************************************  
**      
** Description  :       
**       
**********************************************************************************************************************  
**           
** Change Control	:	Adam Jasinski	-	Created  
**	12/11/2008		:	John O'Sullivan -	added support for @salesAssociateId  
**	01/02/2011		:	Stephen Quin	-	removed insertion of data to the h3giNbsAddressData table  
**	18/12/2012		:	Stephen Quin	-	new parameter added: @businessAccManager
**  15/01/2013		:	Stephen King	-	changed @businessAccManager to int
**  05/09/2013		:	Simon Markey	-	add bic and iban fields for sepa
**  01/10/2013		:	Stephen King	-	added has sepa field
**********************************************************************************************************************/  
CREATE PROCEDURE [dbo].[threeBusinessOrderCreate]  
   @orderStatus INT,  
   @channelCode VARCHAR(20),  
   @retailerCode VARCHAR(20),  
   @storeCode VARCHAR(20) = '',  
   @salesAssociateName NVARCHAR(50) = '',  
   @salesAssociateId INT = NULL,  
   @userId INT,  
   @organizationId INT,  
   @accountHolderName NVARCHAR(80) = N'',  
   @sortCode CHAR(6) = '',  
   @accountNumber CHAR(8) = '',  
   @timeWithBankYears INT = 0,  
   @timeWithBankMonths INT = 0,  
   @paymentMethod VARCHAR(30),  
   @bankAcceptsDirectDebit BIT = 0,  
   @canAuthorizeDebits BIT = 0,  
   @creditAnalystId INT = NULL,  
   @creditCheckReference VARCHAR(50) ='',  
   @decisionCode VARCHAR(20) ='',  
   @decisionDescription VARCHAR(255) = '',  
   @reasonCode VARCHAR(20) = '',  
   @reasonDescription VARCHAR(255) = '',  
   @creditScore INT = 0,  
   @creditLimit MONEY = 0,  
   @shadowCreditLimit MONEY = 0,  
   @depositAmount MONEY = 0,
   @nbsLevel INT,
   @businessAccManager INT = 1,
   @orderRef INT OUT,
   @bic NVARCHAR(11) ='',
   @iban NVARCHAR(34)='',
   @hasSepa BIT = 1
AS  
BEGIN  
  
 DECLARE   
  @NewTranCreated INT,  
  @RC INT  
 SET @NewTranCreated = 0  
 SET @RC=0  
  
 IF @@TRANCOUNT = 0  --if not in a transaction context yet  
 BEGIN  
  SET @NewTranCreated = 1  
  BEGIN TRANSACTION  --then create a new transaction  
 END  
  
 SET @orderRef = 0;  
  
 DECLARE @orderDate DATETIME;  
 SET @orderDate = GETDATE();  
  
 INSERT INTO [dbo].[b4nOrderHeader]  
 (OrderID, StoreID, ZoneID, CustomerID, OrderDate, Status, GoodsPrice)  
 VALUES  
 (1, 1, 1, 0, @orderDate, @orderStatus, 0.0);  
  
 IF @@ERROR = 0 SET @orderRef = SCOPE_IDENTITY();  
 ELSE GOTO ERR_HANDLER;  
  
 INSERT INTO [dbo].[threeOrderHeader]  
 (  
	[orderRef]  
	,[orderStatus]  
	,[orderDate]  
	,[channelCode]  
	,[retailerCode]  
	,[storeCode]  
	,[salesAssociateName]  
	,[salesAssociateId]  
	,[userId]  
	,[customerId]  
	,[organizationId]  
	,[accountHolderName]  
	,[bankSortCode]  
	,[accountNumber]  
	,[timeWithBankYears]  
	,[timeWithBankMonths]  
	,[paymentMethod]  
	,[bankAcceptsDirectDebit]  
	,[canAuthorizeDebits]  
	,[creditAnalystId]  
	,[creditCheckReference]  
	,[decisionCode]  
	,[decisionDescription]  
	,[reasonCode]  
	,[reasonDescription]  
	,[creditScore]  
	,[creditLimit]  
	,[shadowCreditLimit]  
	,[depositAmount]
	,[NbsLevel]
	,[businessAccManagerId]
	,[bic]
	,[iban]
	,[hasSepa]
 )  
 VALUES  
 (  
	@orderRef  
	,@orderStatus --orderStatus  
	,@orderDate  
	,@channelCode  
	,@retailerCode  
	,@storeCode  
	,@salesAssociateName  
	,@salesAssociateId  
	,@userId  
	,NULL --customerId  
	,@organizationId  
	,@accountHolderName  
	,@sortCode  
	,@accountNumber  
	,@timeWithBankYears  
	,@timeWithBankMonths  
	,@paymentMethod  
	,@bankAcceptsDirectDebit  
	,@canAuthorizeDebits  
	,@creditAnalystId  
	,@creditCheckReference  
	,@decisionCode  
	,@decisionDescription  
	,@reasonCode  
	,@reasonDescription  
	,@creditScore  
	,@creditLimit  
	,@shadowCreditLimit  
	,@depositAmount
	,@nbsLevel 
	,@businessAccManager
	,@bic
	,@iban
	,@hasSepa
 );  
  
 IF @@ERROR <> 0 GOTO ERR_HANDLER;  
   
IF @NewTranCreated=1 AND @@TRANCOUNT > 0  
  COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure  
RETURN 0  
  
ERR_HANDLER:  
 PRINT 'threeBusinessOrderCreate: Rolling back...'  
 IF @NewTranCreated=1 AND @@TRANCOUNT > 0   
  ROLLBACK TRANSACTION  --rollback all changes  
 RETURN -1  --return error code  
END  
  
  





GRANT EXECUTE ON threeBusinessOrderCreate TO b4nuser
GO
GRANT EXECUTE ON threeBusinessOrderCreate TO ofsuser
GO
GRANT EXECUTE ON threeBusinessOrderCreate TO reportuser
GO
