

/****** Object:  Stored Procedure dbo.b4nGetDetailList_backup    Script Date: 23/06/2005 13:31:44 ******/

/**********************************************************************************************************************
**									
** Change Control	:	24/11/2004 - John M. - updated the order by clause. so that the 'Product Features List'
**				will come out in the order they were entered through content manager.		
**											
**						
*  Change Control	:	15.02.2005 - John H - updated this sp to handle extra column in b4nattributeproductfamily					
**				UPPM		
**********************************************************************************************************************/
CREATE     Procedure dbo.b4nGetDetailList_backup
@attributeCollectionID int,
@productFamilyID int
As
set nocount on

Select p.productid,t.*,c.*,a.*,f.* ,b.displayvalue,acl.displayMultiValues,
(select top 1 pc1.categoryid from b4ncategoryproduct pc1 with(nolock), b4nproduct pc2 with(nolock)
where pc1.productid = pc2.productid and pc2.deleted = 0 and pc2.productid = p.productid) as categoryid

From 	b4nAttributeType t with(nolock), 
	b4nAttributeInCollection c with(nolock), 
	b4nAttributeCollection acl with(nolock), 
	b4nAttribute a 
		left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID
			and f.productfamilyid = @productFamilyID
		left outer join b4nAttributeBase b with(nolock) on a.attributeID = b.attributeID 
			and b.attributeValue = f.attributeValue,
	b4nProduct p with(nolock)
	
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = @attributeCollectionID
and attributesource = 'C'
and f.productFamilyID = @productFamilyID
and p.productfamilyid = f.productfamilyid
and acl.attributeCollectionID = @attributeCollectionID

--UNION

--Select '',t.*,c.*,a.*,
--f.productFamilyId,f.storeId,f.attributeId,
--v.attributevalue,
--f.multiValuePriority,f.attributeAffectsBasePriceBy,f.attributeAffectsRRPPriceBy,f.attributeImageName,
--f.attributeImageNameSmall,f.modifyDate,f.createDate,f.attributeRowID, f.UPPM,
-- ('') as displayValue, acl.displayMultiValues,'' as categoryid
--From 	b4nAttributeType t with(nolock), 
--	b4nAttributeInCollection c with(nolock), 
--	b4nAttributeCollection acl with(nolock),
--	b4nAttribute a left outer join b4nAttributeProductFamily f with(nolock) 
--			on a.attributeID = f.attributeID
--			and f.productfamilyid = @productFamilyID,
--	b4nAttribute aa left outer join b4nViewAttributeValue v with(nolock) 
--			on 	aa.attributeID = v.attributeID 
--			and 	v.viewTypeId = 2
--Where t.attributeTypeID = a.attributeTypeID
--and a.attributeID = c.attributeID
--and c.attributeCollectionID = @attributeCollectionID
--and acl.attributeCollectionID = @attributeCollectionID
--and a.attributesource = 'S'
--and a.attributeid = aa.attributeid
----Order By a.attributeID  ,f.multiValuePriority ,f.attributevalue

Order By a.attributeID  ,f.attributerowid ,f.attributevalue

/*
Select '',t.*,c.*,a.*,f.*, ('') as displayValue, acl.displayMultiValues
,''as categoryid

From 	b4nAttributeType t with(nolock), 
	b4nAttributeInCollection c with(nolock), 
	b4nAttributeCollection acl with(nolock),
	b4nAttribute a left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = @attributeCollectionID
and acl.attributeCollectionID = @attributeCollectionID
and attributesource = 'S'
Order By a.attributeID  ,f.multiValuePriority ,f.attributevalue
*/





GRANT EXECUTE ON b4nGetDetailList_backup TO b4nuser
GO
GRANT EXECUTE ON b4nGetDetailList_backup TO helpdesk
GO
GRANT EXECUTE ON b4nGetDetailList_backup TO ofsuser
GO
GRANT EXECUTE ON b4nGetDetailList_backup TO reportuser
GO
GRANT EXECUTE ON b4nGetDetailList_backup TO b4nexcel
GO
GRANT EXECUTE ON b4nGetDetailList_backup TO b4nloader
GO
