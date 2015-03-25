

/****** Object:  Stored Procedure dbo.b4nCheckProductLevelAttributes    Script Date: 23/06/2005 13:31:02 ******/




CREATE  Procedure [dbo].b4nCheckProductLevelAttributes
@productFamilyID int

As
Set nocount on
Declare @Fcount as int
Declare @Pcount as int

set @FCount = (Select count(*)
From 	b4nProductFamily pf with(nolock), 
	b4nAttributeInCollection ac with(nolock),
	b4nAttribute a  with(nolock)

Where 	pf.productFamilyID = @productFamilyID
and 	pf.attributeCollectionID = ac.attributeCollectionID
and 	ac.attributeID = a.attributeID
and 	a.cmAttributeLevel = 'F')


set @Pcount = (Select count(*) 
From 	b4nProductFamily pf  with(nolock), 
	b4nAttributeInCollection ac  with(nolock),
	b4nAttribute a  with(nolock)

Where 	pf.productFamilyID = @productFamilyID
and 	pf.attributeCollectionID = ac.attributeCollectionID
and 	ac.attributeID = a.attributeID
and 	a.cmAttributeLevel = 'P')

Select @Fcount as Fcount,@Pcount as Pcount








GRANT EXECUTE ON b4nCheckProductLevelAttributes TO b4nuser
GO
GRANT EXECUTE ON b4nCheckProductLevelAttributes TO helpdesk
GO
GRANT EXECUTE ON b4nCheckProductLevelAttributes TO ofsuser
GO
GRANT EXECUTE ON b4nCheckProductLevelAttributes TO reportuser
GO
GRANT EXECUTE ON b4nCheckProductLevelAttributes TO b4nexcel
GO
GRANT EXECUTE ON b4nCheckProductLevelAttributes TO b4nloader
GO
