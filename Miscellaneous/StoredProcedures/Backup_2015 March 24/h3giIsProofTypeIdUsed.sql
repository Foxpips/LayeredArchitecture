
-- =============================================
-- Author:		John O'Sullivan
-- Create date: 19/01/09
-- Description:	Checks if a proof type id is
--				already been used
--
-- Change Control
-- =============================================

create procedure h3giIsProofTypeIdUsed
	@oldProofTypeId int,
	@newProofTypeId int,
	@type varchar(50)
as
begin
	if exists (select * from h3giProofType where proofTypeId != @oldProofTypeId and proofTypeId = @newProofTypeId and type = @type)
		return 1
	else
		return 0
end

GRANT EXECUTE ON h3giIsProofTypeIdUsed TO b4nuser
GO
