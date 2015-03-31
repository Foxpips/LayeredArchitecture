

/****** Object:  Stored Procedure dbo.b4nConfigGetCardEncryptionKey    Script Date: 23/06/2005 13:31:03 ******/






/****** Object:  Stored Procedure dbo.b4nConfigGetCardEncryptionKey    Script Date: 27/05/2004 12:35:31 ******/

/****** Object:  Stored Procedure dbo.b4nConfigGetCardEncryptionKey    Script Date: 10/05/2004 10:25:57 ******/
create proc dbo.b4nConfigGetCardEncryptionKey
@strPkey varchar(255) output
as
begin
set @strPkey = isnull((select idvalue from b4nsysdefaults with(nolock) where idname = 'cardEncryptionKey'),'')
end












GRANT EXECUTE ON b4nConfigGetCardEncryptionKey TO b4nuser
GO
GRANT EXECUTE ON b4nConfigGetCardEncryptionKey TO helpdesk
GO
GRANT EXECUTE ON b4nConfigGetCardEncryptionKey TO ofsuser
GO
GRANT EXECUTE ON b4nConfigGetCardEncryptionKey TO reportuser
GO
GRANT EXECUTE ON b4nConfigGetCardEncryptionKey TO b4nexcel
GO
GRANT EXECUTE ON b4nConfigGetCardEncryptionKey TO b4nloader
GO
