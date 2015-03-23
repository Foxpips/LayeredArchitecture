

/****** Object:  Stored Procedure dbo.b4nNewsletterInsert    Script Date: 23/06/2005 13:32:13 ******/

create    Procedure b4nNewsletterInsert
@name 			varchar(255) = '',
@email 			varchar(255) = ''

As
Begin

insert into b4nNewsletter(CreateDate,Name,EmailAddress)
values(getDate(),@name,@email)

End




GRANT EXECUTE ON b4nNewsletterInsert TO b4nuser
GO
GRANT EXECUTE ON b4nNewsletterInsert TO helpdesk
GO
GRANT EXECUTE ON b4nNewsletterInsert TO ofsuser
GO
GRANT EXECUTE ON b4nNewsletterInsert TO reportuser
GO
GRANT EXECUTE ON b4nNewsletterInsert TO b4nexcel
GO
GRANT EXECUTE ON b4nNewsletterInsert TO b4nloader
GO
