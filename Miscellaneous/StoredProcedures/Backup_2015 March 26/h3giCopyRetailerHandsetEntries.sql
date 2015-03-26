
-- ========================================================
-- Author:		Stephen Quin
-- Create date: 16/02/09
-- Description:	Copies and inserts existing entries in the
--				h3giRetailerHandset tables for new handsets
-- ========================================================
CREATE PROCEDURE [dbo].[h3giCopyRetailerHandsetEntries] 
	@channelCode VARCHAR(50) = '',
	@catalogueProductId INT,
	@catalogueProductIdToCopy INT,
	@catalogueVersionId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @channelCode <> ''
		BEGIN
			IF NOT EXISTS 
			(
				SELECT * 
				FROM h3giRetailerHandset
				WHERE channelCode = @channelCode
				AND catalogueProductId = @catalogueProductId
				AND catalogueVersionId = @catalogueVersionId
			)
			INSERT INTO h3giRetailerHandset
			SELECT @channelCode,retailerCode,@catalogueVersionId,@catalogueProductId,0,NULL
			FROM h3giRetailerHandset
			WHERE catalogueVersionId = @catalogueVersionId - 1
				AND catalogueProductId = @catalogueProductIdToCopy
				AND channelCode = @channelCode
		END
	ELSE
		BEGIN
			DECLARE @totalChannelCount INT
			DECLARE @retailerChannelCount INT

			SELECT @totalChannelCount = COUNT(channelCode) FROM h3giChannel
			
			SELECT @retailerChannelCount = COUNT(DISTINCT channelCode)
			FROM h3giRetailerHandset
			WHERE catalogueProductId = @catalogueProductId
				AND catalogueVersionId = @catalogueVersionId

			IF @totalChannelCount <> @retailerChannelCount
			BEGIN
				INSERT INTO h3giRetailerHandset
				SELECT channelCode,retailerCode,@catalogueVersionId,@catalogueProductId,0,NULL
				FROM h3giRetailerHandset
				WHERE catalogueVersionId = @catalogueVersionId - 1
					AND catalogueProductId = @catalogueProductIdToCopy
					AND channelCode NOT IN
						(
							SELECT DISTINCT channelCode
							FROM h3giRetailerHandset
							WHERE catalogueProductId = @catalogueProductId
								AND catalogueVersionId = @catalogueVersionId
						)
			END
		END
END


GRANT EXECUTE ON h3giCopyRetailerHandsetEntries TO b4nuser
GO
