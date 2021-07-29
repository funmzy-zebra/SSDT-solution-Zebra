

-- =============================================
-- Author:		Polina Malachov
-- Create date: 3/3/2021
-- Description:	Populates group group attributes to Profitect DB
-- =============================================
CREATE PROCEDURE [dbo].[BQ_INV_PopulateSaleLevelAttributes]
	
AS
BEGIN

--Extaruct Active attributes
  SELECT distinct [AttributeGroupName]
                ,REPLACE([AttributeGroupName],'_','') factTableName
				,Concat(REPLACE([AttributeGroupName],'SaleLevel_',''),'Value') ColumnToPopulate
				,REPLACE([AttributeGroupName],'SaleLevel_','') IDColumn
	into #temp_atr
  FROM [NextGenETL].[dbo].[SaleLevelAttributes]

  Declare @profitectDB nvarchar(100)='ProfitectDB'
  SELECT @profitectDB= [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'ProfitectDB'

--Create query for insert to Profitect DB

  truncate table [NextGenETL].[dbo].[Pipeline_SaleLevelAttributesPopulateQ] 
  insert into [NextGenETL].[dbo].[Pipeline_SaleLevelAttributesPopulateQ] 
  SELECT distinct CONCAT('INSERT INTO ',@profitectDB,'.[dbo].',factTableName
                          ,' (',ColumnToPopulate,
                ') SELECT [AttributeGroupValue] FROM [dbo].[SaleLevelAttributes] c left join ',
				
				 @profitectDB,'.[dbo].',factTableName,' b on c.[AttributeGroupValue]=b.',ColumnToPopulate
				,' where [AttributeGroupName] =''',[AttributeGroupName],'''',' and ', IDColumn ,' is null'
				) as AttributeQuery
              ,ROW_NUMBER() OVER(ORDER BY factTableName ) as ID
  FROM #temp_atr

  drop table #temp_atr

--RUN Query

            Declare @i int, @id int;

			SELECT @i =  MIN(ID) from NextGenETL..[Pipeline_SaleLevelAttributesPopulateQ]
			SELECT @id = MAX(ID) from NextGenETL..[Pipeline_SaleLevelAttributesPopulateQ]
			
			
			if @i is not null
			BEGIN
				WHILE @i<=@id
				BEGIN
					DECLARE @sql_query varchar(6000)
					select @sql_query=AttributeQuery  from NextGenETL..[Pipeline_SaleLevelAttributesPopulateQ] WHERE ID=@i
					print @i
					EXEC( @sql_query )
					set @i=@i+1 
				END
			END
		
END
