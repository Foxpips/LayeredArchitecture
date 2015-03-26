

-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 1/02/2012
-- Description:	Inserts a record in OrderAnalytics table.
-- =============================================
CREATE PROCEDURE [dbo].[h3giInsertOrderAnalytics]
(
	@OrderRef		int,
	@OrderDate		datetime,
	@Ip				nvarchar(200),
	@UserAgent		nvarchar(200),
	@BrowserName	nvarchar(200),
	@BrowserVersion	nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO h3giOrderAnalytics           
     VALUES
           (@OrderRef
		   ,@OrderDate
           ,@Ip
           ,@UserAgent
		   ,@BrowserName
		   ,@BrowserVersion)
END


GRANT EXECUTE ON h3giInsertOrderAnalytics TO b4nuser
GO
