



CREATE PROCEDURE [dbo].[BQ1_Manual_MasterdataLoad_ETL] 
	
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
	SET @project = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'BQ1_Project');
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
			 
			 IF OBJECT_ID('dbo.BQ1_POS_Manual_MasterTablesToExtract', 'U') IS NOT NULL 
			 DROP TABLE dbo.BQ1_POS_Manual_MasterTablesToExtract; 
			 
			 SELECT [ID]
			     ,[table_FileName] as TBL_FileName
				 ,[Delimiter]
			     ,CONCAT('SELECT * FROM ',@prf_db,'.dbo.',[tableName]) as sql_query
			 into [NextGenETL].[dbo].BQ1_POS_Manual_MasterTablesToExtract
			 FROM [NextGenETL].[dbo].[BQ1_POS_Manual_MasterTables]


		   Declare @LocalPath nvarchar(1000), @fullPath nvarchar(1000);
           SELECT @LocalPath = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_ManualLoad_MasterFile_localPath'

		   set @fullPath = (SELECT CONCAT('del "',@LocalPath,'"\ /s /q'));
		   EXEC sp_nextgen_etl_run_cmd @fullPath;
		   
		   Declare @gcpPath nvarchar(150)
           SELECT @gcpPath = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_ManualLoad_MasterFile_GSPath'

		   Declare @gcpDataSet nvarchar(150)
           SELECT @gcpDataSet = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_DataSet'
		   			
			Declare @i int, @id int;

			SELECT @i =  MIN(ID) from NextGenETL..BQ1_POS_Manual_MasterTablesToExtract
			SELECT @id = MAX(ID) from NextGenETL..BQ1_POS_Manual_MasterTablesToExtract
			
			
			if @i is not null
			BEGIN
				WHILE @i<=@id
				BEGIN
					DECLARE @tbName nvarchar (255),@sql_query varchar(1000), @delim varchar(2)
					select @tbName = TBL_FileName,@sql_query=sql_query , @delim=[Delimiter] from NextGenETL..BQ1_POS_Manual_MasterTablesToExtract WHERE ID=@i
					EXEC BQ_LoadTable_ETL_ByQuery
					@sourceTable = @tbName, 
					@localFolder =@LocalPath,
					@gcpFolder =@gcpPath, 
					@bigQueryDB= @gcpDataSet, 
					@bigQueryTable = @tbName, 
					@delimiter =@delim,
					@query =@sql_query			
					
					set @i=@i+1 
				END
			END
			---drop table #to_table

		  
END

