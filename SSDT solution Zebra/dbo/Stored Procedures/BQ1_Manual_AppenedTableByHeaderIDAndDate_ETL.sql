


CREATE PROCEDURE [dbo].[BQ1_Manual_AppenedTableByHeaderIDAndDate_ETL]
/*** Description
Retrieves data from the specified SQL Server table for the specified date and 
uploads to the BigQuery equivalent.  

The optional batch processing is used by specifying the optional batch parameters

Input Parameters
 @sourceDB 		-- source SQL Server database 
 @sourceTable 	-- source SQL Server table 
 @dateColumn 	-- source SQL Server column containing the date to load
 @loadDate 		-- date to load.  Must be in format YYYY-MM-DD
 @localFolder 	-- local folder to place intermediary data file 
 @gcpFolder 	-- gcp folder to upload intermediary data file  
 @bigQueryDB 	-- destination BigQuery dataset
 @bigQueryTable -- destination BigQuery table
 @delimiter		-- delimiter to separate columns
 
Example 
exec [BQ_LoadTableByDate_ETL] 'ProfitectDB_QA', 'POSDocumentPromotionalDiscount', 
'TimeScan', '2013-06-21',
'D:\Profitect\BigQuery\Upload', 'gs://bigquery_profitect/Upload', 
'rnd-gcp:BQ_MUMIN', 'POSFactDiscount', '|';

***/
  
(
 @sourceDB varchar(500), 
 @sourceTable varchar(500), 
 @dateColumn varchar(500),	
 @loadDate varchar(500),			
 @localFolder varchar(500), 
 @gcpFolder varchar(500), 
 @bigQueryDB varchar(500), 
 @bigQueryTable varchar(500),
 @HeaderID  varchar(500),
 @HeaderIDColumn varchar(500),
 @endDate varchar(500),	
 @delimiter varchar(10)
)
as 
BEGIN

DECLARE @shell_cmd VARCHAR(1000);
DECLARE @localPath VARCHAR(1000);
DECLARE @gcpPath VARCHAR(1000);
DECLARE @startDate VARCHAR(50);
--DECLARE @endDate VARCHAR(50);
DECLARE @filename VARCHAR(1000);

-- init time frame
SET @startDate = CONVERT(DATE, CONVERT(DATETIME, @loadDate));
if @endDate is null
Begin
SET @endDate = CONVERT(DATE, dateadd(day,2,getdate()));
End
ELSE set @endDate = CONVERT(DATE, @endDate);

-- init file paths
IF (RIGHT(@localFolder,1) = '/' OR RIGHT(@localFolder,1) = '\') 
	SET @localPath = @localFolder;
ELSE
	SET @localPath = @localFolder + '\';

IF (RIGHT(@gcpFolder,1) = '/' OR RIGHT(@gcpFolder,1) = '\') 
	SET @gcpPath = @gcpFolder;
ELSE
	SET @gcpPath = @gcpFolder + '/';
SET @filename = @sourceTable + '_' + @startDate + '.csv';

-- init environment
DECLARE @sql_bin VARCHAR(1000);
	SET @sql_bin = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'sql_bin');
	SET @shell_cmd = CONCAT('cd ',@sql_bin);
	EXEC sp_nextgen_etl_run_cmd 'c:';
	EXEC sp_nextgen_etl_run_cmd @shell_cmd;

-- retrieve data from mssql to local file
SET @shell_cmd =  'bcp.exe "select * from [' + @sourceDB + '].[dbo].[' + @sourceTable + '] where ' 
                + @HeaderIDColumn + ' > ' + '' + @HeaderID + ' and '
				+ @dateColumn + ' >= ''' + @startDate + ''' and ' + @dateColumn + ' < ''' +  @endDate + '''"'
				+ ' queryout "' + @localPath + @filename + '" -c -t"' + @delimiter + '" -T';
PRINT @shell_cmd;
EXEC sp_nextgen_etl_run_cmd @shell_cmd;

-- remove any files in gcp storage before copying local file to gcp
SET @shell_cmd = 'gsutil -m rm ' + @gcpPath + @filename;
PRINT @shell_cmd;
EXEC sp_nextgen_etl_run_cmd @shell_cmd;

SET @shell_cmd = 'gsutil -m cp ' + @localPath + @filename + ' ' + @gcpPath;
PRINT @shell_cmd;
EXEC sp_nextgen_etl_run_cmd @shell_cmd;

-- load from gcp storage to bigquery
SET @shell_cmd = 'bq load --replace=false --field_delimiter="' + @delimiter + '" --quote="" ' 
				+ @bigQueryDB + '.' + @bigQueryTable +  ' ' + @gcpPath +  @filename; 
PRINT @shell_cmd;
EXEC sp_nextgen_etl_run_cmd @shell_cmd;

SET @shell_cmd = 'gsutil -m rm ' + @gcpPath + @filename;
PRINT @shell_cmd;
EXEC sp_nextgen_etl_run_cmd @shell_cmd;

END


