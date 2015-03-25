

/****** Object:  Stored Procedure dbo.b4nGetSpecialCategoryMenu    Script Date: 23/06/2005 13:32:04 ******/


CREATE procedure dbo.b4nGetSpecialCategoryMenu
@menuId int
as
begin


declare @priority varchar(40)
declare @menuCount int
declare @parentMenuId int
declare @submenuId int
declare @topId int
set @parentMenuId = '0'

create table #menuTable
(
contentMenuId int,
parentMenuId  int,
MenuTitle varchar(2000),
MenuLink	varchar(2000),
MenuTarget	varchar(255),
priority	int,
UsesImages	int,
location	varchar(10),
menuType	varchar(255),
linkto		varchar(255),
menuPriority	real,
menuLevel	int,
defaultLink 	varchar(255) 
)
set @parentMenuId = isnull((select parentMenuId from B4nContentSpecialCategoryMenu  where contentMenuId = @menuId),0)

if (@parentMenuId = 0)
begin
set @priority = isnull((select priority  from B4nContentSpecialCategoryMenu  where contentMenuId = @menuId),'0')
set @priority = @priority + '.01'

end
else
begin
set @topId = (select parentMenuId  from B4nContentSpecialCategoryMenu  where contentMenuId = @parentMenuId)
if (@topId != '0')
begin
set @priority = isnull((select priority  from B4nContentSpecialCategoryMenu  where contentMenuId = @topId),'0')
set @priority = @priority + '.01'
end
else
begin
set @priority = isnull((select priority  from B4nContentSpecialCategoryMenu  where contentMenuId = @parentMenuId),'0')
set @priority = @priority + '.01'
end


end


-- get the top level of the menu
insert into #menuTable
select *,priority,0,'' from B4nContentSpecialCategoryMenu with(nolocK)
where parentMenuId = '0'



if (@menuId != '0')
begin

-- get the current item selected where it's not a top  level item
insert into #menuTable
select *,@priority,0  + cast(('.00' + cast( priority as  varchar(40))) as real) ,''  from B4nContentSpecialCategoryMenu with(nolocK)
where contentMenuId = @menuId
and parentMenuId != '0'

-- get the parent of the current item selected where it's not a  top level menu item
insert into #menuTable
select *,@priority,0  + cast(('.00' + cast( priority as  varchar(40))) as real) ,''  from B4nContentSpecialCategoryMenu with(nolocK)
where parentMenuId = @menuId
and parentMenuId != '0'

-- get the item which is the parent of the current item 
insert into #menuTable
select *,@priority,0  + cast(('.00' + cast( priority as  varchar(40))) as real),''  from B4nContentSpecialCategoryMenu with(nolocK)
where contentMenuId = @parentMenuId
and parentMenuId != '0'





end


update #menuTable 
set #menuTable.menuLevel = 1 
where #menuTable.parentMenuId != 0
and #menuTable.parentMenuId in (select t.contentMenuId from #menuTable t where  t.contentMenuId = #menuTable.parentMenuId and t.parentMenuId =0)

update #menuTable 
set #menuTable.menuLevel = 2 
where #menuTable.parentMenuId != 0
and #menuTable.parentMenuId not in (select t.contentMenuId from #menuTable t where  t.contentMenuId = #menuTable.parentMenuId and t.parentMenuId =0)

update #menuTable
set defaultLink = 'content.aspx?loc=0'

select * from #menuTable order by menuPriority asc

end




GRANT EXECUTE ON b4nGetSpecialCategoryMenu TO b4nuser
GO
GRANT EXECUTE ON b4nGetSpecialCategoryMenu TO helpdesk
GO
GRANT EXECUTE ON b4nGetSpecialCategoryMenu TO ofsuser
GO
GRANT EXECUTE ON b4nGetSpecialCategoryMenu TO reportuser
GO
GRANT EXECUTE ON b4nGetSpecialCategoryMenu TO b4nexcel
GO
GRANT EXECUTE ON b4nGetSpecialCategoryMenu TO b4nloader
GO
