

/****** Object:  Stored Procedure dbo.b4nGetReferentialProductDisplayView    Script Date: 23/06/2005 13:32:03 ******/



CREATE    PROCEDURE dbo.b4nGetReferentialProductDisplayView 
@referentialType varchar(50)
As
Set nocount on
Set CURSOR_CLOSE_ON_COMMIT OFF --need this because commit / rollback transaction closes cursors otherwise

CREATE table #tTable(
	attributecollectionid int, 
	tableid int, 
	row int, 
	cell int, 
	contenttype char(1), 
	content int, 
	height int, 
	width int,
	measurementHeight varchar(2),
	measurementWidth varchar(2),
	vAlign varchar(10),
	hAlign varchar(10),
	bgColor varchar(10),
	cellpadding int,
	cellspacing int,itemsperrow int,textClassSize char(1),imageBorder int,imageHeight int,imageWidth int,colspan int,rowspan int
)

Declare table_dbs_cursor insensitive cursor 

For Select Distinct(tableid),r.viewTypeid From b4nCollectionDisplay b, b4nViewType r
where b.viewTypeID = r.viewTypeId 
and r.viewType = @referentialType

Open table_dbs_cursor

Declare @tableid int
declare @viewTypeId int

Fetch Next From table_dbs_cursor Into @tableid,@viewTypeId

While (@@fetch_status = 0)
Begin
	Delete From #tTable

	Insert Into #tTable
	Select attributecollectionid, tableid, row, cell, contenttype, content, height, width,measurementHeight, measurementWidth,
		vAlign, hAlign, bgColor, cellpadding, cellspacing ,itemsperrow,textClassSize,imageborder,imageHeight,imageWidth,colspan,rowspan
	From b4nCollectionDisplay
	Where tableid =  @tableid
	and viewTypeID = @viewTypeID
	order by tableid,row,cell

	Select * From #tTable

	Fetch Next From table_dbs_cursor Into @tableid,@viewTypeId

End

Close table_dbs_cursor

Deallocate table_dbs_cursor





GRANT EXECUTE ON b4nGetReferentialProductDisplayView TO b4nuser
GO
GRANT EXECUTE ON b4nGetReferentialProductDisplayView TO helpdesk
GO
GRANT EXECUTE ON b4nGetReferentialProductDisplayView TO ofsuser
GO
GRANT EXECUTE ON b4nGetReferentialProductDisplayView TO reportuser
GO
GRANT EXECUTE ON b4nGetReferentialProductDisplayView TO b4nexcel
GO
GRANT EXECUTE ON b4nGetReferentialProductDisplayView TO b4nloader
GO
