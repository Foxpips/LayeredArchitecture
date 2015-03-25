-- =============================================
-- Author:		Stephen Quin
-- Create date: 13/12/07
-- Description:	Marks a return as Processed
-- =============================================
CREATE PROCEDURE [dbo].[threeProcessReturn] 
	@returnRef int,
	@returnType varchar(20)
AS
BEGIN
	UPDATE threeOrderItemReturn
	SET returnProcessed = 1
	WHERE returnNumber = @returnRef
	AND returnType = @returnType
END

GRANT EXECUTE ON threeProcessReturn TO b4nuser
GO
