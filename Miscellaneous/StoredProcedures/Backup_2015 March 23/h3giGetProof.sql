

-- ==================================================================
-- Author:		John O'Sullivan
-- Create date: 19/01/09
-- Description:	Returns data associated with a proof type

-- Change Control: 24/10/14  -  Stephen Quin  - now returns availableFor
-- ===================================================================
CREATE PROCEDURE [dbo].[h3giGetProof]
	@proofTypeId int,
	@type varchar(50)
AS
begin
	set nocount on
	
	declare @classSysId varchar(50)
	set @classSysId = 'ProofCountry'
	
	select
		proofTypeId,
		type,
		proof,
		shouldBeRecent,
		isActive,
		availableFor
	from
		h3giProofType
	where 
		proofTypeId = @proofTypeId and
		type = @type
	
	--get the proof country data if it's there
	select
		pc.proofCountryId,
		pc.classCode,
		cc.b4nClassDesc,
		pc.priority
	from
		h3giProofCountry pc,
		b4nClassCodes cc
	where
		pc.classCode = cc.b4nClassCode and
		cc.b4nClassSysID = pc.classSysId and
		proofTypeId = @proofTypeId and
		type = @type
				
	--get the data that is not assigned to the proof - all the class codes that could possibly be assigned to it but are not
	select
		b4nClassCode,
		b4nClassDesc
	from
		b4nClassCodes
	where
		b4nClassSysID = @classSysId and
		b4nClassCode not in (select classCode from h3giProofCountry where proofTypeId = @proofTypeId and type = @type) and
		b4nValid = 'Y'
end



GRANT EXECUTE ON h3giGetProof TO b4nuser
GO
