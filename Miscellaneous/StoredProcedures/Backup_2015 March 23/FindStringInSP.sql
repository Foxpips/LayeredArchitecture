

/****** Object:  Stored Procedure dbo.FindStringInSP    Script Date: 23/06/2005 13:30:49 ******/

CREATE   PROC FindStringInSP
	
	@string VARCHAR(200)
AS

	SELECT o.name 
	FROM sysobjects o, syscomments s
	WHERE o.xtype = 'P'
		AND o.id = s.id
		AND s.text LIKE '%' + @string + '%'
	ORDER BY o.name









GRANT EXECUTE ON FindStringInSP TO b4nuser
GO
GRANT EXECUTE ON FindStringInSP TO helpdesk
GO
GRANT EXECUTE ON FindStringInSP TO ofsuser
GO
GRANT EXECUTE ON FindStringInSP TO reportuser
GO
GRANT EXECUTE ON FindStringInSP TO b4nexcel
GO
GRANT EXECUTE ON FindStringInSP TO b4nloader
GO
