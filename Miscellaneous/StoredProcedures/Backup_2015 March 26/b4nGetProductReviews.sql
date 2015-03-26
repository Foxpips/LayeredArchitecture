

/****** Object:  Stored Procedure dbo.b4nGetProductReviews    Script Date: 23/06/2005 13:31:59 ******/



CREATE procedure dbo.b4nGetProductReviews
@productfamilyid int
as
begin

select top 10 reviewid,reviewtype,productfamilyid,reviewText,rating,userName,userlocation,
active
from b4nproductreview witH(nolock)
where active = 'Y'
and reviewType = 1
and productfamilyid = @productfamilyid
order by createdate desc
end





GRANT EXECUTE ON b4nGetProductReviews TO b4nuser
GO
GRANT EXECUTE ON b4nGetProductReviews TO helpdesk
GO
GRANT EXECUTE ON b4nGetProductReviews TO ofsuser
GO
GRANT EXECUTE ON b4nGetProductReviews TO reportuser
GO
GRANT EXECUTE ON b4nGetProductReviews TO b4nexcel
GO
GRANT EXECUTE ON b4nGetProductReviews TO b4nloader
GO
