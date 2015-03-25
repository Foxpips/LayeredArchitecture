

/****** Object:  Stored Procedure dbo.b4nGetProductDisplayView    Script Date: 23/06/2005 13:31:58 ******/






CREATE       PROCEDURE dbo.b4nGetProductDisplayView 
@attributeCollectionID int,
@viewTypeID int
As
Set nocount on
Set CURSOR_CLOSE_ON_COMMIT OFF --need this because commit / rollback transaction closes cursors otherwise

CREATE table #tTable(
	attributecolloectionid int, 
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
	cellspacing int,
	itemsperrow int,
	textclasssize char(1)	,imageBorder int,imageHeight int,imageWidth int
	,colspan int,rowspan int
)

Declare table_dbs_cursor insensitive cursor 

For Select Distinct(tableid) From b4nCollectionDisplay
where viewTypeID = @viewTypeID
and attributeCollectionID = @attributeCollectionID

Open table_dbs_cursor

Declare @tableid int

Fetch Next From table_dbs_cursor Into @tableid

While (@@fetch_status = 0)
Begin
	Delete From #tTable

	Insert Into #tTable
	Select attributecollectionid, tableid, row, cell, contenttype, content, height, width,measurementHeight, measurementWidth,
		vAlign, hAlign, bgColor, cellpadding, cellspacing, itemsperrow, textclasssize,imageBorder,imageHeight,imageWidth,
		colspan,rowspan
	From b4nCollectionDisplay
	Where tableid =  @tableid
	and attributeCollectionID = @attributeCollectionID
	and viewTypeID = @viewTypeID
	order by tableid,row,cell

	Select * From #tTable

	Fetch Next From table_dbs_cursor Into @tableid

End

Close table_dbs_cursor

Deallocate table_dbs_cursor







GRANT EXECUTE ON b4nGetProductDisplayView TO b4nuser
GO
GRANT EXECUTE ON b4nGetProductDisplayView TO helpdesk
GO
GRANT EXECUTE ON b4nGetProductDisplayView TO ofsuser
GO
GRANT EXECUTE ON b4nGetProductDisplayView TO reportuser
GO
GRANT EXECUTE ON b4nGetProductDisplayView TO b4nexcel
GO
GRANT EXECUTE ON b4nGetProductDisplayView TO b4nloader
GO
