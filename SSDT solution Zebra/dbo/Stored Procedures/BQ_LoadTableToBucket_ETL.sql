






CREATE PROCEDURE [dbo].[BQ_LoadTableToBucket_ETL]
/*** Description
Retrieves data from the specified SQL Server table and uploads to the BigQuery equivalent

Input Parameters
 @sourceDB 		-- source SQL Server database 
 @sourceTable 	-- source SQL Server table 
 @localFolder 	-- local folder to place intermediary data file
 @gcpFolder 	-- gcp folder to upload intermediary data file
 @bigQueryDB 	-- destination BigQuery dataset
 @bigQueryTable -- destination BigQuery table
 @delimiter		-- delimiter to separate columns

 Example
 exec [BQ_LoadTable_ETL] 'ProfitectDB_QA', 'POSDocumentPromotionalDiscount', 
'D:\Profitect\BigQuery\Upload', 'gs://bigquery_profitect/Upload', 
'rnd-gcp:BQ_MUMIN', 'POSFactDiscount', '|';

***/
  
(
 @sourceDB varchar(50), 
 @sourceTable varchar(50), 
 @localFolder varchar(150), 
 @gcpFolder varchar(150), 
 --@bigQueryDB varchar(150), 
 --@bigQueryTable varchar(50), 
 @delimiter varchar(2)
)
as 
BEGIN

DECLARE @shell_cmd VARCHAR(1000);
DECLARE @localPath VARCHAR(1000);
DECLARE @gcpPath VARCHAR(1000);
Declare @NonUnicodFile VARCHAR(1000);
DECLARE @UnicodeFile VARCHAR(1000);



IF (RIGHT(@localFolder,1) = '/' OR RIGHT(@localFolder,1) = '\') 
	SET @localPath = @localFolder;
ELSE
	SET @localPath = @localFolder + '\';

IF (RIGHT(@gcpFolder,1) = '/' OR RIGHT(@gcpFolder,1) = '\') 
	SET @gcpPath = @gcpFolder;
ELSE
	SET @gcpPath = @gcpFolder + '/';


--SET @shell_cmd =  'bcp.exe "select * from [' + @sourceDB + '].[dbo].[' + @sourceTable + ']" queryout "' 
--				+ @localPath + @sourceTable + '_temp.csv" -w -t"' + @delimiter + '" -T';
--PRINT @shell_cmd;
--EXEC sp_nextgen_etl_run_cmd @shell_cmd;

--SET @NonUnicodFile = '"'+ @localPath + @sourceTable + '_temp.csv"'

--SET @UnicodeFile = '"'+ @localPath + @sourceTable + '.csv"'

--SET @shell_cmd = 'powershell.exe "get-content -path '+@NonUnicodFile+' | out-file '+@UnicodeFile+' -encoding utf8  "'
--PRINT @shell_cmd;
--EXEC sp_nextgen_etl_run_cmd @shell_cmd;


--SET @shell_cmd = 'powershell.exe "Remove-Item '+@NonUnicodFile+'"';
--EXEC sp_nextgen_etl_run_cmd @shell_cmd;


SET @shell_cmd =  'bcp.exe "select * from [' + @sourceDB + '].[dbo].[' + @sourceTable + ']" queryout "' 
				+ @localPath + @sourceTable + '.csv" -c -t"' + @delimiter + '" -T';
PRINT @shell_cmd;
EXEC sp_nextgen_etl_run_cmd @shell_cmd;


--remove current file gsutil -m rm gs://sqltobq/Product.csv
SET @shell_cmd = 'gsutil -m rm ' + @gcpPath+@sourceTable + '.csv '
PRINT @shell_cmd;
EXEC  sp_nextgen_etl_run_cmd @shell_cmd;

SET @shell_cmd = 'gsutil -m cp "' + @localPath + @sourceTable + '.csv" '+ @gcpPath
PRINT @shell_cmd;
EXEC  sp_nextgen_etl_run_cmd @shell_cmd;



--SET @shell_cmd = 'powershell.exe "Remove-Item '+@UnicodeFile+'"';
--EXEC sp_nextgen_etl_run_cmd @shell_cmd;

END



