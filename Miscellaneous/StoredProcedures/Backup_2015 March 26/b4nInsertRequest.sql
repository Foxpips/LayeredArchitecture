

/****** Object:  Stored Procedure dbo.b4nInsertRequest    Script Date: 23/06/2005 13:32:12 ******/

CREATE  PROCEDURE dbo.b4nInsertRequest

@name varchar(500),
@email varchar(500),
@phone varchar(50),
@mobile varchar(50),
@info varchar(8000)
as
 
insert into genAppointmentRequest (name,email,phone,mobile,info,createDate)
values (@name,@email,@phone,@mobile,@info,getdate())




GRANT EXECUTE ON b4nInsertRequest TO b4nuser
GO
GRANT EXECUTE ON b4nInsertRequest TO helpdesk
GO
GRANT EXECUTE ON b4nInsertRequest TO ofsuser
GO
GRANT EXECUTE ON b4nInsertRequest TO reportuser
GO
GRANT EXECUTE ON b4nInsertRequest TO b4nexcel
GO
GRANT EXECUTE ON b4nInsertRequest TO b4nloader
GO
