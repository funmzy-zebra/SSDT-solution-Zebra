
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[BQ_BQ1_CalcMaxIDsMasterTablesToAppendAndDateRange]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/****** Script for SelectTopNRows command from SSMS  ******/
 
 
  IF OBJECT_ID('tempdb..#tempForIDExt') IS NOT NULL DROP TABLE #tempForIDExt;
 SELECT distinct [tableName]
      ,[NextGenConfigKey]
	  into #tempForIDExt
  FROM [NextGenETL].[dbo].[BQ1_POS_Manual_MasterTablesToAppend]

  DECLARE @prf_db nvarchar(100)
  SELECT @prf_db= [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'ProfitectDB'

	 IF OBJECT_ID('tempdb..#tempForIDExtDistinct') IS NOT NULL DROP TABLE #tempForIDExtDistinct;		
	SELECT ROW_NUMBER() over (Order by [tableName]) as ID,
	       t.*,
	       c.NvarcharValue,
		   c.INTValue, 
		   CONCAT('UPDATE [NextGenETL].[dbo].[ETLConfig_PiplineRun] SET INTValue = ( SELECT MAX(',NvarcharValue,') FROM ',@prf_db,'.dbo.', tableName,') where ConfigKey =  ''',t.NextGenConfigKey,'''') as sql_query
		   into #tempForIDExtDistinct
	FROM #tempForIDExt t inner join [NextGenETL].[dbo].[ETLConfig_PiplineRun] c on
	t.NextGenConfigKey = c.ConfigKey


	 
	Declare @i int, @id int;

	SELECT @i = MIN(ID) from #tempForIDExtDistinct
	SELECT @id = MAX(ID) from #tempForIDExtDistinct
	
			if @i is not null
			BEGIN
				WHILE @i<=@id
				BEGIN
				declare @sqlCommand nvarchar(4000)
				SELECT @sqlCommand = sql_query from #tempForIDExtDistinct where ID=@i 
				EXECUTE sp_executesql @sqlCommand
					
				set @i=@i+1 
			END
			END


		 truncate table NextGenETL.dbo.BQ1_POS_ExportDateRange

		  DECLARE @stg_db nvarchar(100)
          SELECT @stg_db= [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'StagingDB'

		  declare @sqlCommand1 nvarchar(4000)
		  set @sqlCommand1 =
		  'insert into NextGenETL.dbo.BQ1_POS_ExportDateRange SELECT [TransactionStartDateID] ,[ID],[BatchDate] 
		  FROM '+@stg_db+'.[dbo].[Daily_POS_ActiveDates]
		  where  [TransactionStartDateID] <=getdate() and [TransactionStartDateID] >getdate()-30
		  and [BatchDate] = (SELECT max([BatchDate]) FROM ' +@stg_db+'.[dbo].[Daily_POS_ActiveDates]  )
		  order by 1 desc'

		  print @sqlCommand1
		  EXECUTE sp_executesql @sqlCommand1



END
