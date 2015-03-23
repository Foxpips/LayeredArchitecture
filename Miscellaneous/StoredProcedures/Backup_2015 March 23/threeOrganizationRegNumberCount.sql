-- =================================================
-- Author:		Stephen Quin
-- Create date: 23/10/07
-- Description:	Returns the number of Organisations
--				whose registered number is equal
--				to the one provided as a parameter
-- =================================================
CREATE PROCEDURE [dbo].[threeOrganizationRegNumberCount]
	@registeredNumber varchar(10),
	@organizationCount int OUTPUT
	
AS
BEGIN
	SET @organizationCount = 
	(
		SELECT COUNT(*)
		FROM [dbo].[threeOrganization]
		WHERE [registeredNumber] = @registeredNumber
	)
END


GRANT EXECUTE ON threeOrganizationRegNumberCount TO b4nuser
GO
GRANT EXECUTE ON threeOrganizationRegNumberCount TO reportuser
GO
