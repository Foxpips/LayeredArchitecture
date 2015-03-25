

  /****** Object:  Stored Procedure dbo.smCreateNewUser    Script Date: 23/06/2005 13:35:28 ******/  
/*********************************************************************************************************************  
**                       
** Procedure Name : smCreateNewUser  
** Author  : Neil Murtagh   
** Date Created  : 5/4/2005  
** Version  : 1.0.1  
**       
**********************************************************************************************************************  
**      
** Description  : This stored procedure creates a new user within the model  
**    1 - created successfully  
**    2 - error  
**       
**********************************************************************************************************************  
**           
** Change Control :   
**        
**********************************************************************************************************************/  
         
CREATE procedure [dbo].[smCreateNewUser]  
@applicationId int =0,  
@roleId int = 0,  
@userName varchar(255) = '',  
@password varchar(255) = '',  
@gen1 varchar(255) = '',  
@gen2 varchar(255) = '',  
@gen3 varchar(255) = '',  
@gen4 varchar(255) = '',  
@gen5 varchar(255) = '',  
@gen6 varchar(255) = '',  
@gen7 varchar(255) = '',  
@gen8 varchar(255) = '',  
@gen9 varchar(255) = '',  
@gen10 varchar(255) = '',  
@gen11 varchar(255) = '',  
@gen12 varchar(255) = '',  
@gen13 varchar(255) = '',  
@gen14 varchar(255) = '',  
@gen15 varchar(255) = '',  
@nameOfUser varchar(255) = '',  
@retailerID int =0,
@email nvarchar(255) = '',
@team nvarchar(255)='',
@userId int output
as  
begin  
  
  
declare @errorCount int  
declare @userCount int  
set @errorCount = 0  
set @userId =0  
  
begin transaction  
  
  
 set @userCount = (select count(userName)  from smapplicationUsers with(nolock)  
where applicationId = @applicationId and userName = @userName)  
  
 if(@userCount = 0)  
 begin  
  
 insert into smApplicationUsers  
 (  
 applicationId,roleId,userName,password,createDate,  
 modifyDate,loginDate,lastActivity,  
 gen1,gen2,gen3,gen4,gen5,  
 gen6,gen7,gen8,gen9,gen10,  
 gen11,gen12,gen13,gen14,gen15,nameOfUser,active,retailerID,email,team  
 )  
 values  
  (  
 @applicationId,@roleId,@userName,@password,getdate(),  
 getdate(),getdate(),getdate(),  
 @gen1,@gen2,@gen3,@gen4,@gen5,  
 @gen6,@gen7,@gen8,@gen9,@gen10,  
 @gen11,@gen12,@gen13,@gen14,@gen15,@nameOfUser,'Y',@retailerID,@email,@team  
 )  
 set @errorCount =@errorCount + @@error   
 set @userId = @@identity  
 end  
 else  
 begin  
 set @userId = -1 -- user already exists  
 end  
   
  
   
  
   
  
  
if(@errorcount != 0)  
begin  
set @userId = 0  -- error occured  
rollback tran  
select 'error, rolling back action '  
  
end  
else  
begin  
commit tran  
end  
  
  
end  
  
  
  
  
  

GRANT EXECUTE ON smCreateNewUser TO b4nuser
GO
GRANT EXECUTE ON smCreateNewUser TO ofsuser
GO
GRANT EXECUTE ON smCreateNewUser TO reportuser
GO
