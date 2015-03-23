
-- ===============================================  
-- Author:  Neil Murtagh  
-- Create date: 22/09/2011  
-- Description: Procedure that returns a last update key for xml content dictionary - for use by sql cache dependency  
-- Update:  22/03/2012 - Gearóid Healy - now reads updateTime from h3giXmlContentDictionaryLog for last successful update  
-- ===============================================  
CREATE PROCEDURE [dbo].[Cache_h3giGetXmlContentDictionary]  
AS  
BEGIN  
  
 SELECT [catalogue].[updateTime]  
 FROM [dbo].[h3giXmlContentDictionaryLog] AS [catalogue]  
 WHERE [updateStatus] = 1  
  
END  
  




GRANT EXECUTE ON Cache_h3giGetXmlContentDictionary TO b4nuser
GO
