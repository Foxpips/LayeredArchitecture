

/************************************************************************************************************
http://www.sqlteam.com/forums/topic.asp?TOPIC_ID=84331
Created By:  Bryan Massey
Created On:  3/11/2007
Comments:  Stored proc performs the following actions:
	1) Queries system tables to retrieve table schema for @TableName parameter
	2) Creates a History table ("History" + @TableName) to mimic the original table, plus include 
           additional history columns.
	3) If @CreateTrigger = 'Y' then it creates an Update/Delete trigger on the @TableName table, 
	   which is used to populate the History table.
        4) Writes simple script to pre-populate the History table with the current values of the Historyed table.
************************************************************************************************************/
CREATE PROCEDURE h3giAutoGenerateHistoryTableAndTrigger
    @TableName VARCHAR(200)
,   @CreateTrigger CHAR(1) = 'Y' -- optional parameter; defaults to "Y" 
AS 
    DECLARE
        @SQLTable VARCHAR(MAX)
    ,   @SQLTrigger VARCHAR(MAX)
    ,   @FieldList VARCHAR(6000)
    ,   @FirstField VARCHAR(200)
    DECLARE
        @TAB CHAR(1)
    ,   @CRLF CHAR(1)
    ,   @SQL VARCHAR(1000)
    ,   @Date VARCHAR(12)

    SET @TAB = CHAR(9)
    SET @CRLF = CHAR(13) + CHAR(10)
    SET @Date = CONVERT(VARCHAR(12), GETDATE(), 101)
    SET @FieldList = ''
    SET @SQLTable = ''
    
    DECLARE @cnt1 INT
    
    DECLARE @CheckExistsParams NVARCHAR(200)
    SET @CheckExistsParams = '@cnt INT OUTPUT'
    
    DECLARE @CheckExists NVARCHAR(200)
    SET @CheckExists = 'SELECT @cnt = COUNT(*) FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].'+ @TableName + '_History' + ''') AND type in (N''U'')'
    
    PRINT @CheckExists

	EXEC sp_executesql @CheckExists, @CheckExistsParams, @cnt = @cnt1 OUTPUT
	
	IF @cnt1 = 1
	RETURN

    DECLARE @PKFieldName VARCHAR(100)
    DECLARE
        @FieldName VARCHAR(100)
    ,   @DataType VARCHAR(50) 
    DECLARE
        @FieldLength VARCHAR(10)
    ,   @Precision VARCHAR(10)
    ,   @Scale VARCHAR(10)
    ,   @FieldDescr VARCHAR(500)
    ,   @AllowNulls VARCHAR(1)
    ,   @FieldIsIdentity BIT
    ,   @FieldLengthInt INT

    DECLARE CurHistoryTable CURSOR
    FOR
        -- query system tables to get table schema
SELECT
        CONVERT(VARCHAR(100), SC.Name) AS FieldName
    ,   CONVERT(VARCHAR(50), ST.Name) AS DataType
    ,   CONVERT(VARCHAR(10), SC.max_length) AS FieldLength
    ,   CONVERT(VARCHAR(10), SC.precision) AS FieldPrecision
    ,   CONVERT(VARCHAR(10), SC.Scale) AS FieldScale
    ,   CASE SC.Is_Nullable
          WHEN 1 THEN 'Y'
          ELSE 'N'
        END AS AllowNulls
    ,   sc.Is_Identity AS FieldIsIdentity
    ,   sc.max_length AS FieldLengthInt
    FROM
        Sys.Objects SO
        INNER JOIN Sys.Columns SC
            ON SO.object_ID = SC.object_ID
-- http://stackoverflow.com/questions/8550427/how-do-i-get-column-type-from-table
-- duplicate column names for Nvarchar fields
-- INNER JOIN Sys.Types ST ON SC.system_type_id = ST.system_type_id
        INNER JOIN Sys.Types ST
            ON SC.user_type_id = ST.user_type_id
    WHERE
        SO.type = 'u'
        AND SO.Name = @TableName
    ORDER BY
        SO.[name]
    ,   SC.Column_Id ASC

    OPEN CurHistoryTable

    FETCH NEXT FROM CurHistoryTable INTO @FieldName, @DataType, @FieldLength, @Precision, @Scale, @AllowNulls, @FieldIsIdentity, @FieldLengthInt

    WHILE @@FETCH_STATUS = 0 
        BEGIN

	-- create list of table columns
            IF LEN(@FieldList) = 0 
                BEGIN
                    SET @FieldList = @FieldName
                    SET @FirstField = @FieldName
                END
            ELSE 
                BEGIN
                    SET @FieldList = @FieldList + ', ' + @FieldName
                END

-- if we are at the start add the std History columns in front
            IF LEN(@SQLTable) = 0 
                BEGIN
                    SET @SQLTable = 'CREATE TABLE [DBO].[' + @TableName + '_History] (' + @CRLF
                    SET @SQLTable = @SQLTable + @TAB + '[' + @TableName + '_HistoryID] [INT] IDENTITY(1,1) NOT NULL,' + @CRLF
                    SET @SQLTable = @SQLTable + @TAB + '[DateOfAction]' + @TAB + 'DATETIME        NOT NULL  DEFAULT (getdate()),' + @CRLF
                    SET @SQLTable = @SQLTable + @TAB + '[SysUser]' + @TAB + '[nvarchar](30) NOT NULL DEFAULT (suser_sname()),' + @CRLF
-- Application context data. Uncomment and replace with your own function call
--                    SET @SQLTable = @SQLTable + @TAB + '[RlpInitiatorPersonId]' + @TAB + '[int] NULL DEFAULT ([dbo].[fnCurrentPersonID]()),' + @CRLF
                    SET @SQLTable = @SQLTable + @TAB + '[Operation]' + @TAB + 'CHAR (1)        NOT NULL,' + @CRLF
                END


            SET @SQLTable = @SQLTable + @TAB + '[' + @FieldName + '] ' + '[' + @DataType + ']'
	
            IF UPPER(@DataType) IN ( 'CHAR', 'VARCHAR', 'NCHAR', 'NVARCHAR', 'BINARY' ) 
                BEGIN
                    IF @FieldLengthInt = -1 
                        SET @FieldLength = 'MAX'
		
                    SET @SQLTable = @SQLTable + '(' + @FieldLength + ')'
                END
            ELSE 
                IF UPPER(@DataType) IN ( 'DECIMAL', 'NUMERIC' ) 
                    BEGIN
                        SET @SQLTable = @SQLTable + '(' + @Precision + ', ' + @Scale + ')'
                    END


	
            SET @SQLTable = @SQLTable + ' NULL'
	
            SET @SQLTable = @SQLTable + ',' + @CRLF


            IF @FieldIsIdentity = 1 
                SET @PKFieldName = @FieldName

            FETCH NEXT FROM CurHistoryTable INTO @FieldName, @DataType, @FieldLength, @Precision, @Scale, @AllowNulls, @FieldIsIdentity, @FieldLengthInt
        END

    CLOSE CurHistoryTable
    DEALLOCATE CurHistoryTable

-- finish history table script  and code for Primary key
    SET @SQLTable = @SQLTable + ' )' + @CRLF + @CRLF
    SET @SQLTable = @SQLTable + 'ALTER TABLE [dbo].[' + @TableName + '_History]' + @CRLF
    SET @SQLTable = @SQLTable + @TAB + 'ADD CONSTRAINT [PK_' + @TableName + '_HistoryID] PRIMARY KEY CLUSTERED ([' + @TableName + '_HistoryID] ASC)' + @CRLF
    SET @SQLTable = @SQLTable + @TAB
        + 'WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];' + @CRLF
        + @CRLF

    PRINT @SQLTable

-- execute sql script to create history table
    EXEC(@SQLTable)

	PRINT 'After exec @sqltable'
	
    SET @SQLTrigger = ''

    IF @@ERROR <> 0 
        BEGIN
            PRINT '******************** ERROR CREATING HISTORY TABLE FOR TABLE: ' + @TableName + ' **************************************'
            RETURN -1
        END

	PRINT 'Before create trigger @CreateTrigger = ' + @CreateTrigger

    IF @CreateTrigger = 'Y' 
        BEGIN
	-- create history trigger
            SET @SQLTrigger = '/************************************************************************************************************' + @CRLF
            SET @SQLTrigger = @SQLTrigger + 'Created By: ' + SUSER_SNAME() + @CRLF
            SET @SQLTrigger = @SQLTrigger + 'Created On: ' + @Date + @CRLF
            SET @SQLTrigger = @SQLTrigger + 'Comments: Auto generated trigger' + @CRLF
            SET @SQLTrigger = @SQLTrigger + '***********************************************************************************************/' + @CRLF
            SET @SQLTrigger = @SQLTrigger + 'CREATE TRIGGER [historyTrg_' + @TableName + '] ON DBO.' + @TableName + @CRLF
            SET @SQLTrigger = @SQLTrigger + 'AFTER INSERT, DELETE, UPDATE' + @CRLF
            SET @SQLTrigger = @SQLTrigger + 'AS' + @CRLF 
            SET @SQLTrigger = @SQLTrigger + 'BEGIN' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + '-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + 'SET NOCOUNT ON;' + @CRLF + @CRLF
	
	-- Here is an IDENTITY BACKUP workaround for @@IDENTITY context corruption problem
	-- Original behavior raise obstacles for after INSERT actions to retrieve new record's identity in a Microsoft way (ADO problem)
	-- http://www.delphigroups.info/2/4/299655.html
	 SET @SQLTrigger = @SQLTrigger + @TAB +'-- START OF IDENTITY BACKUP'+ @CRLF
SET @SQLTrigger = @SQLTrigger + @TAB +'DECLARE @BackupIdentitySeederFunc VARCHAR(1000)'+ @CRLF
SET @SQLTrigger = @SQLTrigger + @TAB +'SET @BackupIdentitySeederFunc = '''+ @CRLF
SET @SQLTrigger = @SQLTrigger + @TAB +'DECLARE @BackupIdentity TABLE'+ @CRLF
SET @SQLTrigger = @SQLTrigger + @TAB +'(IdentityID INT IDENTITY('' + CAST(@@IDENTITY AS VARCHAR) + '', 1))'+ @CRLF
SET @SQLTrigger = @SQLTrigger + @TAB +'INSERT @BackupIdentity DEFAULT VALUES'''+ @CRLF
SET @SQLTrigger = @SQLTrigger + @TAB +'-- END OF IDENTITY BACKUP'+ @CRLF



            SET @SQLTrigger = @SQLTrigger + @TAB + '-- Added or Modified rows:' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + 'INSERT [dbo].[' + @TableName + '_History]' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + '(Operation, ' + @FieldList + ')'
            SET @SQLTrigger = @SQLTrigger + @TAB + 'SELECT [Operation] = CASE WHEN D.' + @PKFieldName + ' IS NULL THEN ''A'' ELSE ''M'' END,' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + '       I.*' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + 'FROM   inserted AS I' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + '       LEFT OUTER JOIN deleted AS D' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + '                ON I.' + @PKFieldName + '= D.' + @PKFieldName + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + '-- Deleted rows:' + @CRLF
	

            SET @SQLTrigger = @SQLTrigger + @TAB + 'INSERT [dbo].[' + @TableName + '_History]' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + '(Operation, ' + @FieldList + ')'
            SET @SQLTrigger = @SQLTrigger + @TAB + 'SELECT	[Operation] = ''D'',' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + '       D.*' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + 'FROM   deleted AS D' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + '       LEFT OUTER JOIN inserted AS I' + @CRLF
            SET @SQLTrigger = @SQLTrigger + @TAB + '                ON I.' + @PKFieldName + ' = D.' + @PKFieldName + +@CRLF

SET @SQLTrigger = @SQLTrigger + @TAB +'-- RETRIEVE ORIGINAL IDENTITY'+ @CRLF
SET @SQLTrigger = @SQLTrigger + @TAB +'EXEC (@BackupIdentitySeederFunc)'+ @CRLF


            SET @SQLTrigger = @SQLTrigger + 'END' + @CRLF + @CRLF + @CRLF
	
-- and to populate the initial History entries try this query:
	--SET @SQLTrigger = @SQLTrigger + 'INSERT [dbo].['+ @TableName + '_History]'+ @CRLF
	--SET @SQLTrigger = @SQLTrigger + '	SELECT [DateOfAction] = GETDATE()' + ',' + @CRLF
	--SET @SQLTrigger = @SQLTrigger + '		   [SysUser] = suser_sname()' + ',' + @CRLF
	--SET @SQLTrigger = @SQLTrigger + '		   [Operation] = ''A'', T.*' + @CRLF
	--SET @SQLTrigger = @SQLTrigger + '   FROM   dbo.' + @TableName + ' AS T' + @CRLF
	        
	        PRINT 'Before print @sqltrigger '
	        
	        PRINT ' @sqltrigger = ' + @SQLTrigger
	        
            PRINT @SQLTrigger
	
	-- execute sql script to create update/delete trigger
            EXEC(@SQLTrigger)
		
            IF @@ERROR <> 0 
                BEGIN
                    PRINT '******************** ERROR CREATING HISTORY TRIGGER FOR TABLE: ' + @TableName + ' **************************************'
                    RETURN -1
                END

        END