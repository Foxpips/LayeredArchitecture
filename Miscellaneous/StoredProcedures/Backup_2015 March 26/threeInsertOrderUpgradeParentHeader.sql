
-- ===========================================================================
-- Author:		Stephen Quin
-- Create date: 19/04/2013
-- Description:	Inserts a record into the threeOrderUpgradeParentHeader table
-- ===========================================================================
CREATE PROCEDURE [dbo].[threeInsertOrderUpgradeParentHeader]
	@parentTariffId INT,
	@contractDuration INT,
	@parentBAN NVARCHAR(10),
	@companyName NVARCHAR(100),
	@authorisedContact NVARCHAR(100),	
	@orderDate DATETIME,
	@catalogueVersionId INT,
	@parentId INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SET @parentId = 0;
    
	INSERT INTO threeOrderUpgradeParentHeader 
	(
		parentTariffId, 
		contractDuration, 
		parentBAN, 
		companyName, 
		authorisedContact, 
		orderDate, 
		catalogueVersionId
	)
	VALUES 
	(
		@parentTariffId,
		@contractDuration,
		@parentBAN,
		@companyName,
		@authorisedContact,
		@orderDate,
		@catalogueVersionId
	)
	
	SET @parentId = SCOPE_IDENTITY()
	
END


GRANT EXECUTE ON threeInsertOrderUpgradeParentHeader TO b4nuser
GO
