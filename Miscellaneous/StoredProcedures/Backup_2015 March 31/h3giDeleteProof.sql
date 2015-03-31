
-- =============================================
-- Author:		John O'Sullivan
-- Create date: 19/01/09
-- Description:	Sets a proof to non-active

-- Change Control
-- =============================================

create procedure h3giDeleteProof
	@proofTypeId int,
	@type varchar(50)
as
begin
	update
		h3giProofType
	set
		isActive = 0
	where
		proofTypeId = @proofTypeId and
		type = @type
end

GRANT EXECUTE ON h3giDeleteProof TO b4nuser
GO
