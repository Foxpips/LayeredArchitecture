

/****** Object:  Stored Procedure dbo.atlLoadCategory    Script Date: 23/06/2005 13:30:56 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	atlLoadCategory
** Author		:	Niall Carroll
** Date Created		:	27/01/2005
** Version		:	1.0.0	
**					
**********************************************************************************************************************
** 
** Description		:	Uses category import table to update existing categories and insert new  
**				categories which do not already exist (validated against productID)
**				Also inserts/updates basic category attributes  
** ---------------------------------------------------------------------------------------------------------------------------------------
**
**	Proc will probably be updated to use category mapping, categories will be maintained from the
**	contract manager.
**
**********************************************************************************************************************/

CREATE PROCEDURE dbo.atlLoadCategory

AS
BEGIN
declare @StoreID integer
declare @CategoryID integer
declare @ParentID integer
declare @Name varchar(255)
declare @IsDel int

update atlImportCategory set ParentID = 0 where ParentID is null

DECLARE curCategory  CURSOR FAST_FORWARD FOR 
SELECT  
	StoreID,
	CategoryID,
	ParentID,
	[Name],
	IsDel
FROM atlImportCategory (nolock)
     
 OPEN curCategory
 FETCH NEXT FROM curCategory 
 INTO  
	@StoreID,
	@CategoryID,
	@ParentID,
	@Name,
	@IsDel

 WHILE ((@@fetch_status <> -1) and (@@fetch_status <> -2))
 BEGIN
	UPDATE 	b4nCategory
	SET 
		parentCategoryId = convert(varchar(255),@ParentID),
		categoryName = @Name,
		deleted = @IsDel
	WHERE 
		CategoryID = convert(varchar(255),@CategoryID) 
		and storeId = @StoreID

	if @@rowcount = 0
	BEGIN
		INSERT INTO b4nCategory (categoryId, categoryName, parentCategoryId, storeId, createDate, modifyDate, onPromotion, deleted)
		values(convert(varchar(255),@CategoryID), @Name, convert(varchar(255),@ParentID), @StoreID, getdate(), getdate(), 0, @IsDel)
	END


	UPDATE	b4nAttributeCategory
	SET		
		attributeValue = @Name
	WHERE
		CategoryID = CONVERT(varchar(255),@CategoryID) 
	AND 	storeId = @StoreID
	AND 	attributeID = 73
			
	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO b4nAttributeCategory (categoryId, storeId, attributeId, attributeValue, multiValuePriority, attributeImageName, attributeImageNameSmall, createDate, modifyDate)
		VALUES(CONVERT(varchar(255),@CategoryID), @StoreID, 73, @Name, 0, NULL, NULL, getdate(), getdate())
	END

     
	FETCH NEXT FROM curCategory 
	INTO  
		@StoreID,
		@CategoryID,
		@ParentID,
		@Name,
		@IsDel
END  -- while

CLOSE curCategory
DEALLOCATE curCategory

END


GRANT EXECUTE ON atlLoadCategory TO b4nuser
GO
GRANT EXECUTE ON atlLoadCategory TO helpdesk
GO
GRANT EXECUTE ON atlLoadCategory TO ofsuser
GO
GRANT EXECUTE ON atlLoadCategory TO reportuser
GO
GRANT EXECUTE ON atlLoadCategory TO b4nexcel
GO
GRANT EXECUTE ON atlLoadCategory TO b4nloader
GO
