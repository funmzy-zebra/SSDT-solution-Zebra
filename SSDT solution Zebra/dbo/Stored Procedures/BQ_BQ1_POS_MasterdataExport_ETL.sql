


CREATE PROCEDURE [dbo].[BQ_BQ1_POS_MasterdataExport_ETL] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	       
	DECLARE 
	@AuthUser VARCHAR(100),
	@project VARCHAR(100),
	@AuthKeyPath VARCHAR(100),
	@dag_run_id Varchar(100);
    DECLARE @shell_cmd VARCHAR(1000);
	DECLARE @sql_bin VARCHAR(1000);

	SET @sql_bin = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'sql_bin');
	SET @shell_cmd = CONCAT('cd ',@sql_bin);
	EXEC sp_nextgen_etl_run_cmd 'c:';
	EXEC sp_nextgen_etl_run_cmd @shell_cmd;

	
	SET @AuthUser = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'AuthUser');
	SET @project = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'project');
	SET @AuthKeyPath = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'AuthKeyPath');
	

	SET @shell_cmd = 'gcloud auth activate-service-account '+@AuthUser+' --key-file='+@AuthKeyPath;

	PRINT @shell_cmd;
    EXEC sp_nextgen_etl_run_cmd @shell_cmd;
	
	SET @shell_cmd = 'gcloud config set project '+ @project;	
	   
	EXEC sp_nextgen_etl_run_cmd @shell_cmd

		 --table list run =>  bq ls --max_results 1000 'lux-nextgen-dev:raw_bq1_pr19' 

		  
		     DECLARE @prf_db nvarchar(100)
			 SELECT @prf_db= [NvarcharValue]
			     
			 FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun]
			 where ConfigKey = 'ProfitectDB'--BQ1_MasterFile_localPath
			 
			 IF OBJECT_ID('dbo.BQ1_POS_Pipeline_MasterTablesToExtract', 'U') IS NOT NULL 
			 DROP TABLE dbo.BQ1_POS_Pipeline_MasterTablesToExtract; 
			 
			 SELECT [ID]
			     ,[table_FileName]+'_' as TBL_FileName
			     ,CONCAT('SELECT * FROM ',@prf_db,'.dbo.',[tableName]) as sql_query
			 into [NextGenETL].[dbo].BQ1_POS_Pipeline_MasterTablesToExtract
			 FROM [NextGenETL].[dbo].[BQ1_POS_MasterTables]


		   Declare @LocalPath nvarchar(1000), @fullPath nvarchar(1000);
           SELECT @LocalPath = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_MasterFile_localPath'

		   set @fullPath = (SELECT CONCAT('del "',@LocalPath,'"\ /s /q'));
		   EXEC sp_nextgen_etl_run_cmd @fullPath;
		   
		   			
			Declare @i int, @id int;

			SELECT @i =  MIN(ID) from NextGenETL..BQ1_POS_Pipeline_MasterTablesToExtract
			SELECT @id = MAX(ID) from NextGenETL..BQ1_POS_Pipeline_MasterTablesToExtract
			
			
			if @i is not null
			BEGIN
				WHILE @i<=@id
				BEGIN
					DECLARE @tbName nvarchar (255),@sql_query varchar(1000)
					select @tbName = TBL_FileName,@sql_query=sql_query  from NextGenETL..BQ1_POS_Pipeline_MasterTablesToExtract WHERE ID=@i
					EXEC BQ_ExtractData_ETL_ByQuery
					@destFileName = @tbName,
					@localFolder = @LocalPath,
					@delimiter = N'^!^',
					@query = @sql_query

					
					
					set @i=@i+1 
				END
			END
			---drop table #to_table

			update c set [DateValue] = getdate()
			      ,[UpdateDate] = getdate()
				  ,NvarcharValue = format(getdate(),'yyyyMMdd_HHmmss')
			  FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] c
			  where [ConfigKey] = 'BQ1_MasterDataExportDate'

			  declare @exportdt nvarchar(100)
			  set @exportdt = (SELECT format([DateValue],'yyyyMMdd_HHmmss') from [NextGenETL].[dbo].[ETLConfig_PiplineRun] c where [ConfigKey] = 'BQ1_MasterDataExportDate')
			  

			  declare @CMD nvarchar(1000)
			  set @CMD= (SELECT concat('"C:\Program Files\7-Zip\7z.exe" a -tzip "',@LocalPath,'"\BQ1_Master_',@exportdt,'.zip "',@LocalPath,'"\*.csv -mx1'))
			
			  update c set NvarcharValue = @CMD
			  FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] c
			  where [ConfigKey] = 'BQ1_MasterDataExportDate'
		   
		 
		   
		      declare @shell_cmdzip nvarchar(1000)
			    SET @shell_cmdzip =  'bcp.exe "SELECT NvarcharValue FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] WHERE [ConfigKey] = ''BQ1_MasterDataExportDate''" queryout "' 
					+ @localPath + '\masterdata_zip' + '.bat" -c -T';
				PRINT @shell_cmdzip;
				EXEC sp_nextgen_etl_run_cmd @shell_cmdzip;

				SET @shell_cmdzip = '"'+ @localPath + '\masterdata_zip' + '.bat"'
				EXEC sp_nextgen_etl_run_cmd @shell_cmdzip;

				Declare @gcpPath nvarchar(1000)
                SELECT @gcpPath = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_MasterFile_GSPath'

				set @shell_cmdzip = CONCAT( 'gsutil cp "',@LocalPath,'"\BQ1_Master_',@exportdt,'.zip "',@gcpPath,'"');

				print @shell_cmdzip;
				EXEC sp_nextgen_etl_run_cmd @shell_cmdzip;
		  
END
