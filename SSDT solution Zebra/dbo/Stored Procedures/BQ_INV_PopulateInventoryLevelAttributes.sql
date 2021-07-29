CREATE PROCEDURE [dbo].[BQ_INV_PopulateInventoryLevelAttributes]
	
AS
BEGIN

--Extaruct Active attributes
  SELECT distinct [AttributeGroupName]
                ,REPLACE([AttributeGroupName],'_','') factTableName
				,Concat(REPLACE([AttributeGroupName],'InventoryLevel_',''),'Value') ColumnToPopulate
				,REPLACE([AttributeGroupName],'InventoryLevel_','') IDColumn
	into #temp_atr
  FROM [NextGenETL].[dbo].[InventoryLevelAttributes]

  Declare @profitectDB nvarchar(100)='ProfitectDB'
  SELECT @profitectDB= [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'ProfitectDB'
--Create query for insert to Profitect DB

  truncate table [NextGenETL].[dbo].[Pipeline_InventoryLevelAttributesPopulateQ] 
  insert into [NextGenETL].[dbo].[Pipeline_InventoryLevelAttributesPopulateQ] 
  SELECT distinct CONCAT('INSERT INTO ',@profitectDB,'.[dbo].',factTableName
                          ,' (',ColumnToPopulate,
                ') SELECT [AttributeGroupValue] FROM [dbo].[InventoryLevelAttributes] c left join ',
				
				 @profitectDB,'.[dbo].',factTableName,' b on c.[AttributeGroupValue]=b.',ColumnToPopulate
				,' where [AttributeGroupName] =''',[AttributeGroupName],'''',' and ', IDColumn ,' is null'
				) as AttributeQuery
              ,ROW_NUMBER() OVER(ORDER BY factTableName ) as ID
  FROM #temp_atr

  drop table #temp_atr

--RUN Query

            Declare @i int, @id int;

			SELECT @i =  MIN(ID) from NextGenETL..[Pipeline_InventoryLevelAttributesPopulateQ]
			SELECT @id = MAX(ID) from NextGenETL..[Pipeline_InventoryLevelAttributesPopulateQ]
			
			
			if @i is not null
			BEGIN
				WHILE @i<=@id
				BEGIN
					DECLARE @sql_query varchar(6000)
					select @sql_query=AttributeQuery  from NextGenETL..[Pipeline_InventoryLevelAttributesPopulateQ] WHERE ID=@i
					print @i
					EXEC( @sql_query )
					set @i=@i+1 
				END
			END
		
END
