--drop proc h3giGetNbsProductTariffMatrix
--go

create procedure h3giGetNbsProductTariffMatrix
as
begin
	select
		productId,
		tariffId,
		nbsLevel,
		display
	from
		h3giNbsProductTariffMatrix
end

GRANT EXECUTE ON h3giGetNbsProductTariffMatrix TO b4nuser
GO
