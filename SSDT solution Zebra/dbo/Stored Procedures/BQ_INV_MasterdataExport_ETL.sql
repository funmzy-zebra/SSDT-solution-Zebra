


CREATE PROCEDURE [dbo].[BQ_INV_MasterdataExport_ETL] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	       DECLARE @shell_cmd VARCHAR(1000)
           DECLARE @sql_bin VARCHAR(1000);

			SET @sql_bin = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'sql_bin');
			SET @shell_cmd = CONCAT('cd ',@sql_bin);
			EXEC sp_nextgen_etl_run_cmd 'c:';
			EXEC sp_nextgen_etl_run_cmd @shell_cmd;

	       EXEC master..xp_cmdshell 'gcloud auth activate-service-account kroger-nextgen-dev-etl@kroger-nextgen-dev.iam.gserviceaccount.com --key-file=C:\GCP\kroger-nextgen-dev-59e9e466ea66.json'    
		   
		 --  EXEC master..xp_cmdshell 'gcloud config set project sobeys-gcp'

		  Declare @LocalPath nvarchar(1000) = N'D:\Profitect\NextGen\external_csv';

			Declare @i int, @id int;

			SELECT @i =  MIN(ID) from NextGenETL..Pipeline_INV_MasterTablesToExtract
			SELECT @id = MAX(ID) from NextGenETL..Pipeline_INV_MasterTablesToExtract
			
			
			if @i is not null
			BEGIN
				WHILE @i<=@id
				BEGIN
					DECLARE @tbName nvarchar (255),@sql_query varchar(1000)
					select @tbName = TBL_FileName,@sql_query=sql_query  from NextGenETL..Pipeline_INV_MasterTablesToExtract WHERE ID=@i
					EXEC [BQ_LoadTableToBucket_ETL_ByQuery]
					@sourceTable = @tbName,
					@localFolder = @LocalPath,
					@gcpFolder = N'gs://kroger-nextgen-dev-bucket/external_csv/',
					@delimiter = N'|',
					@query = @sql_query

					
					
					set @i=@i+1 
				END
			END
			---drop table #to_table

			--gsutil -m cp D:\Profitect\NextGen\TriggerMasterDag\*.zip gs://kroger-nextgen-dev-data/INV_MasterToFact/input/

		  
		  
END
