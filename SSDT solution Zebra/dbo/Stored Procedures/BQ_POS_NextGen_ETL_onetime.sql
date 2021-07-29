

Create PROCEDURE [dbo].[BQ_POS_NextGen_ETL_onetime] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

           EXEC master..xp_cmdshell 'c:';
           EXEC master..xp_cmdshell 'cd C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\';
	       EXEC master..xp_cmdshell 'gcloud auth activate-service-account sobeys-nextgen-prd-etl@sobeys-nextgen-prd.iam.gserviceaccount.com --key-file=C:\GCPKey\sobeys-nextgen-prd-15c70ef68c9e.json'    
		   
		 --  EXEC master..xp_cmdshell 'gcloud config set project sobeys-gcp'


		--  exec [ProfitectDB_Sobeys]..[BQ_LoadTable_ETL] 'Staging_Sobeys', 'Master_Assortment_item', '\\sobeys-prd-db\Profitect\BQ_Data\NextGen', 'gs://sobeys-nextgen-prd-bucket/external_csv', 'sobeys-nextgen-prd:staging_master_prod', 'Master_Assortment_item','|';
		--  exec [ProfitectDB_Sobeys]..[BQ_LoadTable_ETL] 'Staging_Sobeys', 'Master_Sobeys_loyalty_cards', '\\sobeys-prd-db\Profitect\BQ_Data\NextGen', 'gs://sobeys-nextgen-prd-bucket/external_csv', 'sobeys-nextgen-prd:staging_master_prod', 'Master_Sobeys_loyalty_cards','~';
		--  exec [ProfitectDB_Sobeys]..[BQ_LoadTable_ETL] 'Staging_Sobeys', 'Master_Store_Hierarchy', '\\sobeys-prd-db\Profitect\BQ_Data\NextGen', 'gs://sobeys-nextgen-prd-bucket/external_csv', 'sobeys-nextgen-prd:staging_master_prod', 'Master_Store_Hierarchy','~';
		  --exec [ProfitectDB_Sobeys]..[BQ_LoadTableToBucket_ETL] 'Staging_Sobeys','MAster_Sobeys_POS_Types', '\\SOBEYS-PRD-DB\X$\Profitect\BQ_Data\MasterData','gs://sobeys-nextgen-dev1-bucket/external_csv/','|';
		 -- exec [ProfitectDB_Sobeys]..[BQ_LoadTableToBucket_ETL] 'Staging_Sobeys','Master_Bags_upc', '\\SOBEYS-PRD-DB\X$\Profitect\BQ_Data\MasterData','gs://sobeys-nextgen-dev1-bucket/external_csv/','|';	
		  


		  Declare @dbName nvarchar(1000)= N'Staging_Sobeys'
                 ,@LocalPath nvarchar(1000) = N'\\sobeys-prd-db\Profitect\BQ_Data\NextGen';

			Declare @i int, @id int;
			/*
			drop table if exists NextGenETL..MasterTables_ForNextGen;
			Select ROW_NUMBER() over(order by name) as ID,  name as tableName
			Into NextGenETL..MasterTables_ForNextGen
			From sys.tables 
			Where name like 'Master_' +'%' and name not in ('Master_Store_Hierarchy','Master_Sobeys_loyalty_cards','Master_Assortment_item') 
			      and  name not like '%_2020%'
				  and name not like 'Master_Assortment_item%'-- it can be any table set, Raw_, Master, ... here is an example for Daily_POS
				  and name not like 'Master_Store_Hierarchy%';
			*/

			SELECT @i =  MIN(ID) from NextGenETL..MasterTables_ForNextGen where convert(int,id) = 52
			SELECT @id = MAX(ID) from NextGenETL..MasterTables_ForNextGen where convert(int,id) = 52
			
			
			if @i is not null
			BEGIN
				WHILE @i<=@id
				BEGIN
					DECLARE @tbName nvarchar (255)
					select @tbName = tableName from NextGenETL..MasterTables_ForNextGen WHERE ID=@i
					EXEC [ProfitectDB_Sobeys]..[BQ_LoadTableToBucket_ETL]
					@sourceDB = @dbName,
					@sourceTable = @tbName,
					@localFolder = @LocalPath,
					@gcpFolder = N'gs://sobeys-nextgen-prd-bucket/external_csv/',
					@delimiter = N'|'
					
					
					set @i=@i+1 
				END
			END
			---drop table #to_table

		  
		  
END
