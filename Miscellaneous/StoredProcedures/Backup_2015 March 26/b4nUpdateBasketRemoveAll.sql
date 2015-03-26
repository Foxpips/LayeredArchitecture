

/****** Object:  Stored Procedure dbo.b4nUpdateBasketRemoveAll    Script Date: 23/06/2005 13:32:51 ******/



CREATE procedure dbo.b4nUpdateBasketRemoveAll
@nCustomerId int,
@nStoreId int
as
begin


delete from b4nBasketAttribute
where basketid in 
(
	select basketid from b4nbasket   
	where CustomerId = @nCustomerId
	and storeId = @nStoreId
)

delete from b4nBasket 
where  CustomerId = @nCustomerId
and storeId = @nStoreId

end







GRANT EXECUTE ON b4nUpdateBasketRemoveAll TO b4nuser
GO
GRANT EXECUTE ON b4nUpdateBasketRemoveAll TO helpdesk
GO
GRANT EXECUTE ON b4nUpdateBasketRemoveAll TO ofsuser
GO
GRANT EXECUTE ON b4nUpdateBasketRemoveAll TO reportuser
GO
GRANT EXECUTE ON b4nUpdateBasketRemoveAll TO b4nexcel
GO
GRANT EXECUTE ON b4nUpdateBasketRemoveAll TO b4nloader
GO
