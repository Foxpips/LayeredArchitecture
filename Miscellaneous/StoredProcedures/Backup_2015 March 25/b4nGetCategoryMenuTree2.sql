

/****** Object:  Stored Procedure dbo.b4nGetCategoryMenuTree2    Script Date: 23/06/2005 13:31:30 ******/


CREATE         proc dbo.b4nGetCategoryMenuTree2
@parentCategoryID varchar(40)
AS
Begin

Declare @table table(
	sortid		int IDENTITY (1, 1),
	priority	int,
	ident	int,
	menuid	varchar(40),
	parentmenuid	varchar	(40),
	menuTitle	varchar	(200),
	menuLink	varchar	(2000),
	menuTarget	varchar	(1000),
	isParent	smallint,
	menuLevel	smallint,
	usesimages	smallint,
	onPromotion	smallint,
	categoryImage	varchar	(100),
	parentCatMenuid varchar(40),
	catcount	int
)

Declare @catcount int

Set @catcount = (Select count(menuid) From b4ncategorymenu with(nolock) Where parentmenuid = '0')

set @parentcategoryid = replace(@parentcategoryid,'.','_')
print @parentcategoryid
Declare catCursor Insensitive Cursor 
For Select priority,menuid,parentmenuid,isParent From b4ncategorymenu with(nolock)
Where parentmenuid = @parentcategoryid Order By priority

Open catCursor

	Declare @priority int, @menuid varchar(40), @parentmenuid varchar(40), @isParent smallint
	
	Fetch Next From catCursor into @priority, @menuid, @parentmenuid,@isParent
	
	While (@@fetch_status = 0)
	Begin
	
		Insert Into @table(priority,ident,menuid,parentmenuid,menuTitle,menuLink,menuTarget,isParent,menuLevel,usesimages,onPromotion,categoryImage,parentCatMenuid,catcount)
		Select cm.priority,cm.ident,cm.menuid,cm.parentmenuid,cm.menuTitle,cm.menuLink,cm.menuTarget,cm.isParent,cm.menuLevel,cm.usesimages,cm.onPromotion,cm.categoryImage,0,1
			From b4ncategorymenu cm with(nolock)
		Where cm.menuid = @menuid
		
		Insert Into @table(priority,ident,menuid,parentmenuid,menuTitle,menuLink,menuTarget,isParent,menuLevel,usesimages,onPromotion,categoryImage,parentCatMenuid,catcount)
		Select cm.priority,cm.ident,cm.menuid,cm.parentmenuid,cm.menuTitle,cm.menuLink,cm.menuTarget,cm.isParent,cm.menuLevel,cm.usesimages,cm.onPromotion,cm.categoryImage,0,1
			From b4ncategorymenu cm with(nolock)
		Where cm.parentmenuid = @menuid
		Order by cm.priority,cm.menuTitle
	
	Fetch Next From catCursor Into @priority, @menuid, @parentmenuid, @isParent
	
	End

Close catCursor
Deallocate catCursor

Select * From @table Order By sortid
End





GRANT EXECUTE ON b4nGetCategoryMenuTree2 TO b4nuser
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree2 TO helpdesk
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree2 TO ofsuser
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree2 TO reportuser
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree2 TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree2 TO b4nloader
GO
