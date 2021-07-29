

CREATE PROCEDURE [dbo].[BQ_BQ1_POS_FactDataExport_ETL]
	
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
	

	
			SET @AuthUser = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'AuthUser');
			SET @project = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'project');
			SET @AuthKeyPath = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'AuthKeyPath');
			

			SET @shell_cmd = 'gcloud auth activate-service-account '+@AuthUser+' --key-file='+@AuthKeyPath;

			PRINT @shell_cmd;
			EXEC sp_nextgen_etl_run_cmd @shell_cmd;
			
			SET @shell_cmd = 'gcloud config set project '+ @project;	
			   
			EXEC sp_nextgen_etl_run_cmd @shell_cmd

			DECLARE @prf_db nvarchar(100)
			SELECT @prf_db= [NvarcharValue]			     
			 FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun]
			 where ConfigKey = 'ProfitectDB'--BQ1_MasterFile_localPath

		   Declare @LocalPath nvarchar(1000), @fullPath nvarchar(1000);
           SELECT @LocalPath = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_FactFile_localPath'

		   set @fullPath = (SELECT CONCAT('del "',@LocalPath,'"\ /s /q'));
		   EXEC sp_nextgen_etl_run_cmd @fullPath;

		   	 update c set 
			       [DateValue] = getdate()
			      ,[UpdateDate] = getdate()
				  ,[NvarcharValue] = format(getdate(),'yyyyMMdd_HHmmss')
			  FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] c
			  where [ConfigKey] = 'BQ1_FactDataExportDate'
/*
		 --dt_FD-sqltobq
		  SELECT [TransactionStartDateID]
			  ,[ID]
			  ,[BatchDate]
		  into #tempDates
		  FROM [Staging_Luxottica].[dbo].[Daily_POS_ActiveDates]
		  where /* [TransactionStartDateID] <=dateadd(day,2,getdate()) and [TransactionStartDateID]  >getdate()-90
		  and*/ [BatchDate] = (SELECT max([BatchDate]) FROM [Staging_Luxottica].[dbo].[Daily_POS_ActiveDates]  )
		  order by 1 desc
*/
		---  select * from #tempDates order by 1
		  
		  DEclare @maxDate datetime
		  DEclare @startDate datetime
		  Declare @HeaderID Nvarchar(500)
		  declare @maxSenth datetime

		  set @startDate = '20190811'--(SELECT MIN([TransactionStartDateID]) FROM #tempDates)
		  set @maxDate = '20190817'--(SELECT MAX([TransactionStartDateID]) FROM #tempDates)
		  set @HeaderID = 0--(SELECT [ConfigurationValue] FROM [dbo].[Configuration] where [ConfigurationKey] = 'ETL_StartPosDocumentHeaderID_BQ')
		 
		-- exec [BQ_LoadTable_ETL] 'Staging_Luxottica', 'v_ActiveDates', 'D:\BQ_Data\MasterData', 'gs://lux-nextgen-dev_sqltobq', 'lux-nextgen-dev:ETL_transfer_dev', 'ActiveDates','^';
		-- exec [BQ_LoadTable_ETL] @prf_db, 'v_MaxPosDocumentHeaderID', 'D:\BQ_Data\MasterData', 'gs://lux-nextgen-dev_sqltobq', 'lux-nextgen-dev:ETL_transfer_dev', 'POSDocumentHeaderID','^'; 

		 while @startDate<=@maxDate
		  begin
		       
			   declare @localDT datetime
			   declare @endDate datetime
			   set @localDT = @startDate
			   set @endDate = dateadd(day,1,@localDT)
			   if(datediff(day,@startDate,@maxDate)>7) set @endDate = dateadd(day,-7,@maxDate)

			   

		   exec BQ_ExtractTableByHeaderIDAndDate_ETL @prf_db, 'POSDocumentTender', 
				'ScannedTimeStamp', @startDate,
				 @LocalPath ,@HeaderID,'POSDocumentHeaderID',@endDate,'^!^';
		  

		   exec BQ_ExtractTableByHeaderIDAndDate_ETL @prf_db, 'POSDocumentLoyaltyCards', 
				'ScannedTimeStamp', @startDate,
				 @LocalPath,@HeaderID,'POSDocumentHeaderID',@endDate,'^!^';

			exec BQ_ExtractTableByHeaderIDAndDate_ETL @prf_db, 'POSDocumentLine', 
				'TransactionStartTimestamp', @startDate,
				 @LocalPath,@HeaderID,'POSDocumentHeaderID',@endDate,'^!^';
				       
			exec BQ_ExtractTableByHeaderIDAndDate_ETL @prf_db, 'POSDocumentPromotionalDiscount', 
				'TimeScan', @startDate, @LocalPath, @HeaderID,'POSDocumentHeaderID',@endDate,'^!^';

			exec BQ_ExtractTableByHeaderIDAndDate_ETL @prf_db, 'POSDocumentHeaderReasonRelation', 
				'DocumentDate', @startDate, @LocalPath, @HeaderID,'POSDocumentHeaderID',@endDate,'^!^';

			


			  declare @exportdt nvarchar(100)
			  set @exportdt = (SELECT format([DateValue],'yyyyMMdd_HHmmss') from [NextGenETL].[dbo].[ETLConfig_PiplineRun] c where [ConfigKey] = 'BQ1_FactDataExportDate')
			  

			  declare @CMD nvarchar(1000)
			  set @CMD= (SELECT concat('"C:\Program Files\7-Zip\7z.exe" a -tzip "',@LocalPath,'"\BQ1_Fact_',format(@startDate,'yyyyMMdd'),'_',@exportdt,'.zip "',@LocalPath,'"\*',format(@startDate,'yyyy-MM-dd'),'*.csv -mx1'))
			
			  update c set NvarcharValue = @CMD
			  FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] c
			  where [ConfigKey] = 'BQ1_FactDataExportDate'
		   
		 
		   
		      declare @shell_cmdzip nvarchar(1000)
			    SET @shell_cmdzip =  'bcp.exe "SELECT NvarcharValue FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] WHERE [ConfigKey] = ''BQ1_FactDataExportDate''" queryout "' 
					+ @localPath + '\factdata_zip' + '.bat" -c -T';
				PRINT @shell_cmdzip;
				EXEC sp_nextgen_etl_run_cmd @shell_cmdzip;

				SET @shell_cmdzip = '"'+ @localPath + '\factdata_zip' + '.bat"'
				EXEC sp_nextgen_etl_run_cmd @shell_cmdzip;

	         set @startDate = @endDate

		  end

		        Declare @gcpPath nvarchar(1000)
                SELECT @gcpPath = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_MasterFile_GSPath'

				set @shell_cmdzip = CONCAT( 'gsutil cp "',@LocalPath,'"\BQ1_Master_',@exportdt,'.zip "',@gcpPath,'"');

				print @shell_cmdzip;
				EXEC sp_nextgen_etl_run_cmd @shell_cmdzip;
		
		

		  set @HeaderID = 	(SELECT MAX([POSDocumentHeaderID]) FROM [dbo].[POSDocumentLine])
		  

		  update c set ConfigurationValue =  @HeaderID
		  FROM [dbo].[Configuration] c where [ConfigurationKey] = 'ETL_StartPosDocumentHeaderID_BQ'

		
/*
		 declare @pubsubMSG nvarchar(300) 
		 set  @pubsubMSG = 'gcloud pubsub topics publish --project {GCPProjectName} etl_job_completed --message "ETL process to loading data to BigQuery Completed"'
		 EXEC sp_nextgen_etl_run_cmd @pubsubMSG;
*/		
		 drop table #tempDates
 END

 /*******

 	 INSERT INTO [dbo].[Configuration]
           ([ConfigurationKey]
           ,[ConfigurationValue]
           ,[MayPassToUI]
           ,[UpdateDateTime]
           ,[Description]
           ,[DisplayCategory])
     VALUES
           ('ETL_StartPosDocumentHeaderID_BQ'
           ,(SELECT MAX([POSDocumentHeaderID]) FROM [dbo].[POSDocumentLine])
           ,'False'
           ,GETDATE()
           ,'To execute BRE not only  by date, but for all records that were delivered , in the same date'
           ,'ETL')


 ********/
