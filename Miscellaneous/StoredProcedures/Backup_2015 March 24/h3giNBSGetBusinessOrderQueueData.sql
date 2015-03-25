-- ======================================================
-- Author:		Stephen Quin
-- Create date: 29/04/09
-- Description:	Gets the NBS Data for orders that should
--				appear in the business queue
-- ======================================================
CREATE PROCEDURE [dbo].[h3giNBSGetBusinessOrderQueueData] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT  header.orderRef,
		person.firstName + ' ' + (CASE WHEN(LEN(person.middleInitial) > 0) THEN person.middleInitial + ' ' ELSE '' END) + person.lastName AS personName,
		organisation.registeredName AS organisationName,
		address.fullAddress AS organisationAddress,
		header.orderDate,
		'Satellite' AS product	
	FROM	threeOrderHeader header
			INNER JOIN threeOrganization organisation
			ON header.organizationId = organisation.organizationId
			INNER JOIN threePerson person
			ON organisation.organizationId = person.organizationId
			INNER JOIN threeOrganizationAddress address
			ON organisation.organizationId = address.organizationId
	WHERE	header.orderStatus = 701

	UNION

	SELECT  header.orderRef,
			case 
				when person.firstName is null then ''
				else person.firstName + ' ' + (CASE WHEN(LEN(person.middleInitial) > 0) THEN person.middleInitial + ' ' ELSE '' END) + person.lastName
			end as personName,
			organisation.registeredName AS organisationName,
			address.fullAddress AS organisationAddress,
			header.orderDate,
			'Repeater' AS product	
	FROM	threeOrderHeader header
			INNER JOIN h3giNbsRepeaterQueue repeaterQueue
			ON header.orderRef = repeaterQueue.orderRef
			AND repeaterQueue.state = 0
			INNER JOIN threeOrganization organisation
			ON header.organizationId = organisation.organizationId
			INNER JOIN threePerson person ON 
				organisation.organizationId = person.organizationId
				and person.personType = 'Contact'
			INNER JOIN threeOrganizationAddress address
			ON organisation.organizationId = address.organizationId

END

GRANT EXECUTE ON h3giNBSGetBusinessOrderQueueData TO b4nuser
GO
