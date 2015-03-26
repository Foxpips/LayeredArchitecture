

/****** Object:  Stored Procedure dbo.h3giGetUsers    Script Date: 23/06/2005 13:35:22 ******/
CREATE proc dbo.h3giGetUsers
as
begin
	select distinct userid, 
	case active
		when 'N' THEN username + ' * (deleted)'
		else username
	end as username
	from smApplicationUsers with (nolock)
	order by username asc
end


GRANT EXECUTE ON h3giGetUsers TO b4nuser
GO
GRANT EXECUTE ON h3giGetUsers TO helpdesk
GO
GRANT EXECUTE ON h3giGetUsers TO ofsuser
GO
GRANT EXECUTE ON h3giGetUsers TO reportuser
GO
GRANT EXECUTE ON h3giGetUsers TO b4nexcel
GO
GRANT EXECUTE ON h3giGetUsers TO b4nloader
GO
