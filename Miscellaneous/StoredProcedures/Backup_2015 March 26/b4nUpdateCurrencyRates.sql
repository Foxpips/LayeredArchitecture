

/****** Object:  Stored Procedure dbo.b4nUpdateCurrencyRates    Script Date: 23/06/2005 13:32:52 ******/


create procedure dbo.b4nUpdateCurrencyRates
@currencyName varchar(255),
@currencyRate real
as
begin

if exists (select currencyrate from b4nCurrencyRates with(nolock) where currencyName = @currencyName)
begin
update b4ncurrencyrates
set currencyRate = @currencyRate,modifyDate = getdate()
where currencyName  = @currencyName
end
else
begin
insert into b4ncurrencyrates
(currencyName,currencyRate,createDate,modifyDate)
values
(@currencyName,@currencyRate,getdate(),getdate())

end


end






GRANT EXECUTE ON b4nUpdateCurrencyRates TO b4nuser
GO
GRANT EXECUTE ON b4nUpdateCurrencyRates TO helpdesk
GO
GRANT EXECUTE ON b4nUpdateCurrencyRates TO ofsuser
GO
GRANT EXECUTE ON b4nUpdateCurrencyRates TO reportuser
GO
GRANT EXECUTE ON b4nUpdateCurrencyRates TO b4nexcel
GO
GRANT EXECUTE ON b4nUpdateCurrencyRates TO b4nloader
GO
