-- =============================================
-- Author:		John O'Sullivan
-- Create date: 19/01/09
-- Description:	Adds a proof

-- Change Control
-- =============================================

create procedure h3giGetAllProofCountries
as
begin
	select 
		b4nClassCode, 
		b4nClassDesc 
	from
		b4nClassCodes 
	where 
		b4nClassSysId = 'ProofCountry' and 
		b4nValid = 'Y'
	order by 
		b4nClassDesc
end

GRANT EXECUTE ON h3giGetAllProofCountries TO b4nuser
GO
