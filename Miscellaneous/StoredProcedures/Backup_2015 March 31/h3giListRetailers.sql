

/****** Object:  Stored Procedure dbo.h3giListRetailers    Script Date: 05/07/2005 14:35:28 ******/

CREATE proc dbo.h3giListRetailers 
@channelCode varchar(20) = ''
AS

	SELECT 	retailerCode, 
		channelCode, 
		retailerName 
	FROM 	h3giRetailer 
	WHERE 	(channelCode = @channelCode OR @channelCode = '')
	AND	retailerCode not in ('BFN01','BFN02')


GRANT EXECUTE ON h3giListRetailers TO b4nuser
GO
GRANT EXECUTE ON h3giListRetailers TO helpdesk
GO
GRANT EXECUTE ON h3giListRetailers TO ofsuser
GO
GRANT EXECUTE ON h3giListRetailers TO reportuser
GO
GRANT EXECUTE ON h3giListRetailers TO b4nexcel
GO
GRANT EXECUTE ON h3giListRetailers TO b4nloader
GO
