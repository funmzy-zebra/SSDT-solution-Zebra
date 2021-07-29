




CREATE PROCEDURE [dbo].[BQ1_Manual_MasterdataLoadAppendByID_ETL] 
	
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
			 
			

		   Declare @LocalPath nvarchar(1000), @fullPath nvarchar(1000);
           SELECT @LocalPath = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_ManualLoad_MasterFile_localPath'

		   set @fullPath = (SELECT CONCAT('del "',@LocalPath,'"\ /s /q'));
		 --  EXEC sp_nextgen_etl_run_cmd @fullPath;
		   
		   Declare @gcpPath nvarchar(150)
           SELECT @gcpPath = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_ManualLoad_MasterFile_GSPath'

		   Declare @gcpDataSet nvarchar(150)
           SELECT @gcpDataSet = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_DataSet'
		   			
			Declare @i int, @id int, @exportDate nvarchar(10);

			SELECT @i =  MIN(ID) from NextGenETL..BQ1_POS_Manual_MasterTablesToAppend
			SELECT @id = MAX(ID) from NextGenETL..BQ1_POS_Manual_MasterTablesToAppend
			
			SET @exportDate = ( SELECT format(GETDATE(),'yyyyMMdd'))
			
			if @i is not null
			BEGIN
				WHILE @i<=@id
				BEGIN

					DECLARE 
							@FiletbName nvarchar (255),
							@tableName varchar(1000), 
							@delim varchar(2),
							@IDColumnName nvarchar (255),
							@IDColumnValue nvarchar (255),
							@ConfigKey nvarchar (255)
					select @FiletbName = [table_FileName],
					       @tableName=[tableName] , 
						   @delim=[Delimiter] ,
						   @ConfigKey = [NextGenConfigKey]
			        from NextGenETL..BQ1_POS_Manual_MasterTablesToAppend WHERE ID=@i

				SELECT @IDColumnName = [NvarcharValue], @IDColumnValue = INTValue FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = @ConfigKey

				exec BQ1_Manual_AppenedTableByHeaderID_ETL
					@sourceDB = @prf_db
				  , @sourceTable = @tableName
				  , @loadDate = @exportDate
				  , @localFolder = @LocalPath
				  , @gcpFolder = @gcpPath
				  , @bigQueryDB = @gcpDataSet
				  , @bigQueryTable = @FiletbName
				  , @HeaderID = @IDColumnValue
				  , @HeaderIDColumn = @IDColumnName
				  , @delimiter = @delim
					
					
					
					set @i=@i+1 
				END
			END
			---drop table #to_table

		  
END

