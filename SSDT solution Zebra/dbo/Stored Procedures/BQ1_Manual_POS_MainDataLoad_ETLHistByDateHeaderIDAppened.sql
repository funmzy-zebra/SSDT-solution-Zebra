

CREATE PROCEDURE [dbo].[BQ1_Manual_POS_MainDataLoad_ETLHistByDateHeaderIDAppened]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	-- REPLACING DATA  BY DATE in BQ1

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
		  
    DECLARE @prf_db nvarchar(100)
	SELECT @prf_db= [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'ProfitectDB'

	Declare @LocalPath nvarchar(1000), @fullPath nvarchar(1000);
    SELECT @LocalPath = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_FactFile_localPath'

	Declare @gcpPath nvarchar(150)
           SELECT @gcpPath = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_ManualLoad_MasterFile_GSPath'

		   Declare @gcpDataSet nvarchar(150)
           SELECT @gcpDataSet = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_DataSet'


		  DEclare @maxDate datetime
		  DEclare @startDate datetime
		  Declare @HeaderID Nvarchar(500)

		  set @startDate = '20210320'--(SELECT MIN(DT_ID) FROM #tempDates)
		  set @maxDate = '20210320'--(SELECT MAX(DT_ID) FROM #tempDates)
		  

		  while @startDate<=@maxDate
		  begin
			   declare @localDT datetime
			   declare @endDate datetime
			   set @localDT = @startDate
			   set @endDate = dateadd(day,1,@localDT)

			   exec BQ1_Manual_AppenedTableByHeaderIDAndDate_ETL @prf_db, 'POSDocumentLoyaltyCards', 
				'ScannedTimeStamp', @localDT, @LocalPath, @gcpPath, 
				 @gcpDataSet, 'POSFactLoyalty',@HeaderID,'POSDocumentHeaderID',@endDate,'~';

			
				
               exec BQ1_Manual_AppenedTableByHeaderIDAndDate_ETL @prf_db, 'POSDocumentPromotionalDiscount', 
				'TimeScan', @localDT, @LocalPath, @gcpPath, 
			   	@gcpDataSet, 'POSFactDiscount',@HeaderID,'POSDocumentHeaderID',@endDate,'~';

			
			  
			   exec BQ1_Manual_AppenedTableByHeaderIDAndDate_ETL @prf_db, 'POSDocumentLine', 
				'TransactionStartTimestamp', @localDT, @LocalPath, @gcpPath, 
				@gcpDataSet, 'POSDocument',@HeaderID,'POSDocumentHeaderID',@endDate,'|';

				
				
				exec BQ1_Manual_AppenedTableByHeaderIDAndDate_ETL @prf_db, 'POSDocumentTender', 
				'ScannedTimeStamp', @localDT, @LocalPath, @gcpPath, 
				@gcpDataSet, 'POSFactTender',@HeaderID,'POSDocumentHeaderID',@endDate,'~';

				
				exec BQ1_Manual_AppenedTableByHeaderIDAndDate_ETL @prf_db, 'POSDocumentHeaderReasonRelation', 
				'DocumentDate', @localDT,	@LocalPath, @gcpPath, 
				@gcpDataSet, 'POSHeaderReasonRelation',@HeaderID,'POSDocumentHeaderID',@endDate,'~';


				exec BQ1_Manual_AppenedTableByHeaderIDAndDate_ETL @prf_db, 'POSDocumentHeaderReasonRelation', 
				'DocumentDate', @localDT,	@LocalPath, @gcpPath, 
				@gcpDataSet, 'POSDocumentHeaderReasonRelation',@HeaderID,'POSDocumentHeaderID',@endDate,'~';
				
				 set @fullPath = (SELECT CONCAT('del "',@LocalPath,'"\POSDocument*.* /s /q'));
		         EXEC sp_nextgen_etl_run_cmd @fullPath;

			    set @startDate = @startDate+1
		  end

		-- drop table #tempDates
 END

