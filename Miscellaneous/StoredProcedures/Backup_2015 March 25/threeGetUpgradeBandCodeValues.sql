
-- =====================================================
-- Author:		Stephen Quin
-- Create date: 03/05/2013
-- Description:	Returns the band codes and their values
-- =====================================================
CREATE PROCEDURE [dbo].[threeGetUpgradeBandCodeValues]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT bandCode, bandValue, cc.b4nClassDesc AS bandName
    FROM threeUpgradeBandValues bv
    INNER JOIN b4nClassCodes cc
		ON bv.bandcode = cc.b4nClassCode
		AND cc.b4nClassSysID = 'BusinessUpgradeBand'
    
END


GRANT EXECUTE ON threeGetUpgradeBandCodeValues TO b4nuser
GO
