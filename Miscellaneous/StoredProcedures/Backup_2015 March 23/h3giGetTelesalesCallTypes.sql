
-- =======================================================
-- Author:		Stephen Quin
-- Create date: 03/10/2012
-- Description:	Returns the telesalesCallType and the 
--				associated campaign type
-- =======================================================
CREATE PROCEDURE [dbo].[h3giGetTelesalesCallTypes]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT	cc.b4nClassDesc,
			cc.b4nClassCode,
			tType.campaignType
	FROM b4nClassCodes cc
	INNER JOIN h3giTelesalesCallType tType
		ON cc.b4nClassSysID = tType.b4nClassSysID
		AND cc.b4nClassCode = tType.b4nClassCode
END


GRANT EXECUTE ON h3giGetTelesalesCallTypes TO b4nuser
GO
