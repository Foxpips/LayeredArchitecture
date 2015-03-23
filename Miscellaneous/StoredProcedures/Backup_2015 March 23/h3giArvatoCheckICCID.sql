
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 17-July-2014
-- Description:	Checks an ICCID.
-- =============================================
CREATE PROCEDURE [dbo].[h3giArvatoCheckICCID]
(
	@OrderRef	INT,
	@ICCID 		VARCHAR(50)	
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
		WHERE OrderRef = @OrderRef
	END

	DECLARE @PrepayBit INT

	IF @Prepay = 0 OR @Prepay = 2
		-- Contract, Contract Upgrade, Business Upgrade
		SET @PrepayBit = 0
	ELSE
		-- Prepay, Prepay Upgrade, Accessory
		SET @PrepayBit = 1

	EXEC h3giCheckICCID @CheckTEXT = @ICCID, @OrderRef = @OrderRef, @Prepay = @PrepayBit, @ProductId = @ProductId
END
GRANT EXECUTE ON h3giArvatoCheckICCID TO b4nuser
GO
