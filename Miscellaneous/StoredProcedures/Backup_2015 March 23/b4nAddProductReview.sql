

/****** Object:  Stored Procedure dbo.b4nAddProductReview    Script Date: 23/06/2005 13:30:58 ******/



create procedure dbo.b4nAddProductReview
@nRating int,
@nProductId int,
@strName varchar(255),
@strLocation varchar(255),
@strReview varchar(6000)
as
begin

declare @active char(1)
declare @nReviewType int
declare @nTotalRating int
declare @nTotalReviews int

declare @productFamilyId int
set @active = 'N'
set @nReviewType = 1 -- user review
set @productFamilyId = (select productfamilyid from b4nproduct with(nolock) where productid = @nProductId)

insert into b4nProductReview
(ReviewType,productfamilyid,ReviewText,Rating,userName,userLocation,active)
values
(@nReviewType,@productFamilyId,@strReview,@nRating,@strName,@strLocation,@active)


end








GRANT EXECUTE ON b4nAddProductReview TO b4nuser
GO
GRANT EXECUTE ON b4nAddProductReview TO helpdesk
GO
GRANT EXECUTE ON b4nAddProductReview TO ofsuser
GO
GRANT EXECUTE ON b4nAddProductReview TO reportuser
GO
GRANT EXECUTE ON b4nAddProductReview TO b4nexcel
GO
GRANT EXECUTE ON b4nAddProductReview TO b4nloader
GO
