




/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giListStoreLogins
** Author			:	Gearóid Healy
** Date Created		:	01/06/2005
** Version			:	1.0.2
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure returns all store logins
**					
**********************************************************************************************************************
**									
** Change Control	:	03/07/2005 - Gearoid Healy - no longer looks at b4nclasscodes
**
**					: 	05/07/2005 - Gearoid Healy - no longer gets store name from smapplication users
**						
**********************************************************************************************************************/

CREATE          Procedure [dbo].[h3giListStoreLogins]

as

	select au.userId,
			au.username,
			au.nameOfUser,
			r.retailername + ' - ' + s.storename as nameofuser,
			c.channelcode,
			r.retailercode,
			r.retailerName,
			s.storecode,
			s.storeName
	from smapplicationusers au with(nolock)
	join h3giretailer r with(nolock) on au.gen1 = r.retailercode
	join h3gichannel c with(nolock) on r.channelcode = c.channelcode
	join h3giretailerstore s with(nolock) on au.gen2 = s.storecode
	where au.gen2 <> ''
	order by au.username -- Peter Murphy - defect 508






GRANT EXECUTE ON h3giListStoreLogins TO b4nuser
GO
GRANT EXECUTE ON h3giListStoreLogins TO ofsuser
GO
GRANT EXECUTE ON h3giListStoreLogins TO reportuser
GO
