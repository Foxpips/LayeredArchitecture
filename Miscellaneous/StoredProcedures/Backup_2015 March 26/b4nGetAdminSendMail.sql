



create procedure dbo.b4nGetAdminSendMail
As
select email from b4nAdmin with(nolock) where sendMail = 1


GRANT EXECUTE ON b4nGetAdminSendMail TO b4nuser
GO
