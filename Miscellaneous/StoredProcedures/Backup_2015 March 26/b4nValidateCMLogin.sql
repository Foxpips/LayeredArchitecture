

/****** Object:  Stored Procedure dbo.b4nValidateCMLogin    Script Date: 23/06/2005 13:32:52 ******/





CREATE proc dbo.b4nValidateCMLogin 

@loginName varchar(50),

@loginPassword varchar(50),

@Total int output

as

select @Total= COUNT(*) from cmUser

where username = @loginName

and password = @loginPassword

 






GRANT EXECUTE ON b4nValidateCMLogin TO b4nuser
GO
GRANT EXECUTE ON b4nValidateCMLogin TO helpdesk
GO
GRANT EXECUTE ON b4nValidateCMLogin TO ofsuser
GO
GRANT EXECUTE ON b4nValidateCMLogin TO reportuser
GO
GRANT EXECUTE ON b4nValidateCMLogin TO b4nexcel
GO
GRANT EXECUTE ON b4nValidateCMLogin TO b4nloader
GO
