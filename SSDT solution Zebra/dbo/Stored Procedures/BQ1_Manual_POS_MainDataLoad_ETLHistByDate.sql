

CREATE PROCEDURE [dbo].[BQ1_Manual_POS_MainDataLoad_ETLHistByDate]
	
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
    SELECT @LocalPath = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_ManualLoad_FactFile_localPath'

	Declare @gcpPath nvarchar(150)
           SELECT @gcpPath = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_ManualLoad_FactFile_GSPath'

		   Declare @gcpDataSet nvarchar(150)
           SELECT @gcpDataSet = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'BQ1_DataSet'


		  DEclare @endDate datetime
		  DEclare @startDate datetime
		  set @startDate = (SELECT MIN([TransactionStartDateID]) FROM [NextGenETL].[dbo].[BQ1_POS_ExportDateRange])
		  set @endDate = (SELECT MAX([TransactionStartDateID]) FROM [NextGenETL].[dbo].[BQ1_POS_ExportDateRange])
		  
		  truncate table [dbo].[ETL_Transfer_POS_ActiveDates];
			
				/*************Populated range of days, if needed populate specifc days manually*******/
			with dates_CTE (date) as (
			    select @startDate 
			    Union ALL
			    select DATEADD(day, 1, date)
			    from dates_CTE
			    where date < @endDate
			)
			insert into [dbo].[ETL_Transfer_POS_ActiveDates]   
			select ROW_NUMBER() over(order by date asc) ID, format( date,'yyyyMMdd') as  DocumentDate
			      ,'false'
			from dates_CTE;

		  Declare @ETLTransfer_DataSet nvarchar(200)
		  SELECT @ETLTransfer_DataSet = [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'ETLTransfer_DataSet'

		  EXEC BQ_LoadTable_ETL_ByQuery
					@sourceTable = 'ActiveDates', 
					@localFolder =@LocalPath,
					@gcpFolder =@gcpPath, 
					@bigQueryDB= @ETLTransfer_DataSet, 
					@bigQueryTable = 'ActiveDates', 
					@delimiter =',',
					@query ='SELECT format(convert(date, DocumentDate),''yyyy-MM-dd'') FROM [NextGenETL].[dbo].ETL_Transfer_POS_ActiveDates'	

		   DECLARE @tbName nvarchar (255),@sql_query varchar(1000), @delim varchar(2)
		   set @sql_query = Concat('SELECT MIN(PosDocumentHeaderID)-1 from ',@prf_db,'.dbo.POSDocumentLine where TransactionStartTimestamp>=''',@startDate,'''')
		   print @sql_query

		   EXEC BQ_LoadTable_ETL_ByQuery
					@sourceTable = 'POSDocumentHeaderID', 
					@localFolder =@LocalPath,
					@gcpFolder =@gcpPath, 
					@bigQueryDB= @ETLTransfer_DataSet, 
					@bigQueryTable = 'POSDocumentHeaderID', 
					@delimiter =',',
					@query =@sql_query
		  

		  while @startDate<=@endDate
		  begin
			   declare @localDT datetime
			   set @localDT = @startDate--(SELECT TransactionStartDateID from #tempDates where DT_ID=  @startDate)


			   exec [BQ1_Manual_LoadTableByDate_ETL] @prf_db, 'POSDocumentLoyaltyCards', 
				'ScannedTimeStamp', @localDT, @LocalPath, @gcpPath, 
				 @gcpDataSet, 'POSFactLoyalty','~';

			
				
               exec [BQ1_Manual_LoadTableByDate_ETL] @prf_db, 'POSDocumentPromotionalDiscount', 
				'TimeScan', @localDT, @LocalPath, @gcpPath, 
			   	@gcpDataSet, 'POSFactDiscount','~';

			
			  
			   exec [BQ1_Manual_LoadTableByDate_ETL] @prf_db, 'POSDocumentLine', 
				'TransactionStartTimestamp', @localDT, @LocalPath, @gcpPath, 
				@gcpDataSet, 'POSDocument','|';

				
				
				exec [BQ1_Manual_LoadTableByDate_ETL] @prf_db, 'POSDocumentTender', 
				'ScannedTimeStamp', @localDT, @LocalPath, @gcpPath, 
				@gcpDataSet, 'POSFactTender','~';

				
				exec [BQ1_Manual_LoadTableByDate_ETL] @prf_db, 'POSDocumentHeaderReasonRelation', 
				'DocumentDate', @localDT,	@LocalPath, @gcpPath, 
				@gcpDataSet, 'POSHeaderReasonRelation','~';

				exec [BQ1_Manual_LoadTableByDate_ETL] @prf_db, 'POSDocumentHeaderReasonRelation', 
				'DocumentDate', @localDT,	@LocalPath, @gcpPath, 
				@gcpDataSet, 'POSDocumentHeaderReasonRelation','~';
				
				 set @fullPath = (SELECT CONCAT('del "',@LocalPath,'"\ /s /q'));
		         EXEC sp_nextgen_etl_run_cmd @fullPath;

			    set @startDate = @startDate+1
		  end

		-- drop table #tempDates
 END

