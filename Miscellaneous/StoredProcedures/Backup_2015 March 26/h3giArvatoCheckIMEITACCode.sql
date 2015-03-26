
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 17-July-2014
-- Description:	Checks the TAC Code for an IMEI.
-- =============================================
CREATE PROCEDURE [dbo].[h3giArvatoCheckIMEITACCode]
(
	@OrderRef	INT,
	@IMEI 		VARCHAR(50)	
)
AS
BEGIN  
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
	SET NOCOUNT ON;

	DECLARE @ProductId	INT
	DECLARE @PrePay 	INT

	IF EXISTS(SELECT TOP 1 OrderRef FROM h3giOrderHeader WHERE OrderRef = @OrderRef)
	BEGIN 
		PRINT 'Consumer order'
		SELECT @PrePay = ordertype, @ProductId = phoneProductCode
		FROM h3giOrderheader
		WHERE OrderRef = @OrderRef
	END
	ELSE
	BEGIN
		PRINT 'Business upgrade order'
		SELECT @PrePay = 2, @ProductId = deviceId
		FROM threeOrderUpgradeHeader
		WHERE orderRef = @OrderRef
	END

	EXEC h3giCheckTACCode @ProductID = @ProductID, @IMEI = @IMEI, @Prepay = @Prepay
END
GRANT EXECUTE ON h3giArvatoCheckIMEITACCode TO b4nuser
GO
