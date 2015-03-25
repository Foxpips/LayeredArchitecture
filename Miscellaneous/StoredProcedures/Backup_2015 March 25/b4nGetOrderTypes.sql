

/****** Object:  Stored Procedure dbo.b4nGetOrderTypes    Script Date: 23/06/2005 13:31:55 ******/


CREATE PROCEDURE dbo.b4nGetOrderTypes 
@custid int
AS


Select * from b4nClassCodes
Where b4nClassSysId = 'DelDocketType'
And      b4nValid = 'Y'


select attributeuservalue from b4nbasketattribute
where attributeid = 1074
and basketid in (
select basketid from b4nbasket
where customerid = @custid)




GRANT EXECUTE ON b4nGetOrderTypes TO b4nuser
GO
GRANT EXECUTE ON b4nGetOrderTypes TO helpdesk
GO
GRANT EXECUTE ON b4nGetOrderTypes TO ofsuser
GO
GRANT EXECUTE ON b4nGetOrderTypes TO reportuser
GO
GRANT EXECUTE ON b4nGetOrderTypes TO b4nexcel
GO
GRANT EXECUTE ON b4nGetOrderTypes TO b4nloader
GO
