


/*********************************************************************************************************************
**                                                                                                                            
** Procedure Name :     dbo.threeOrganizationGet
** Author               :     Adam Jasinski 
** Date Created         :     
**                            
**********************************************************************************************************************
**                      
** Description          :                             
**                            
**********************************************************************************************************************
**                                                    
** Change Control :     - Adam Jasinski - Created
** 14/06/2012           :     - Simon Markey  - Added Join in order to return nbsLevel of order
**
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[threeOrganizationGet]
      @organizationId int
AS
BEGIN
      SELECT *, dbo.getProductNamefromPeoplesoftId(pricePlanRequiredPeoplesoftId) pricePlanRequiredName FROM [threeOrganization]
      LEFT OUTER JOIN [threeOrderHeader] on [threeOrderHeader].organizationId = [threeOrganization].organizationId
      WHERE [threeOrganization].organizationId = @organizationId;

      SELECT * FROM [threeOrganizationAddress]
      WHERE organizationId = @organizationId;

      SELECT * FROM [threePerson]
      WHERE organizationId = @organizationId;

      SELECT * FROM [threePersonAddress]
      WHERE personId IN
            (SELECT personId FROM [threePerson]
                  WHERE organizationId = @organizationId);

      SELECT * FROM [threePersonPhoneNumber]
      WHERE personId IN
            (SELECT personId FROM [threePerson]
                  WHERE organizationId = @organizationId);

END

GRANT EXECUTE ON threeOrganizationGet TO b4nuser
GO
GRANT EXECUTE ON threeOrganizationGet TO ofsuser
GO
GRANT EXECUTE ON threeOrganizationGet TO reportuser
GO
