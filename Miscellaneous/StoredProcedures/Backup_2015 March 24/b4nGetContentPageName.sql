

/****** Object:  Stored Procedure dbo.b4nGetContentPageName    Script Date: 23/06/2005 13:31:38 ******/


/*********************************************************************************************************************
**																					
** Procedure Name	:	b4nGetContentPageName
** Author			:	Gearóid Healy
** Date Created		:	11/03/2005
** Version			:	1.0.01
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure returns the name of the content page from b4nContent based on 
**						the locations passed
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 			
CREATE   procedure dbo.b4nGetContentPageName
	@strLocation varchar(10)
as
begin

	declare @StartingPoint int
	
	set @StartingPoint = 1
	
	select @StartingPoint = charindex('-', contentDesc, 1)
	from b4nContent with(nolock)
	where location = @strLocation
	
	print @StartingPoint
	
	if(@StartingPoint = 0)
		set @StartingPoint = 1
	else
		set @StartingPoint = @StartingPoint + 2
	
	select substring(contentDesc, @StartingPoint, len(contentDesc)) as contentDesc
	from b4nContent with(nolock)
	where location = @strLocation

end






GRANT EXECUTE ON b4nGetContentPageName TO b4nuser
GO
GRANT EXECUTE ON b4nGetContentPageName TO helpdesk
GO
GRANT EXECUTE ON b4nGetContentPageName TO ofsuser
GO
GRANT EXECUTE ON b4nGetContentPageName TO reportuser
GO
GRANT EXECUTE ON b4nGetContentPageName TO b4nexcel
GO
GRANT EXECUTE ON b4nGetContentPageName TO b4nloader
GO
