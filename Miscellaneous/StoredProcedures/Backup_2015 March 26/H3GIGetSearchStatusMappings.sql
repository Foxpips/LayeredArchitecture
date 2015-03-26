

/****** Object:  Stored Procedure dbo.H3GIGetSearchStatusMappings    Script Date: 23/06/2005 13:30:51 ******/
CREATE PROCEDURE dbo.H3GIGetSearchStatusMappings
	@Type varchar(50)
AS
SELECT
	 Filter, code 
FROM
	dbo.H3GISearchFilterMap
WHERE 
	IsValid='Y' and Source =@Type
ORDER BY 
	Filter



GRANT EXECUTE ON H3GIGetSearchStatusMappings TO b4nuser
GO
GRANT EXECUTE ON H3GIGetSearchStatusMappings TO helpdesk
GO
GRANT EXECUTE ON H3GIGetSearchStatusMappings TO ofsuser
GO
GRANT EXECUTE ON H3GIGetSearchStatusMappings TO reportuser
GO
GRANT EXECUTE ON H3GIGetSearchStatusMappings TO b4nexcel
GO
GRANT EXECUTE ON H3GIGetSearchStatusMappings TO b4nloader
GO
