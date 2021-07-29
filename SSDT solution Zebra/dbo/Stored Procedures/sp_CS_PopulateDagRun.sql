-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_PopulateDagRun]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	  DECLARE @dag_name VARCHAR(100)
	  SET @dag_name = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'DagName');
    -- Insert statements for procedure here
	  INSERT INTO [dbo].[LOG_PiplineRun]
	  SELECT try_convert(bigint,[id])
		  ,[run_id]
		  ,[state]
		  ,replace(left([execution_date],19),'T',' ')
		  ,[state_date]
		  , @dag_name
		  ,DATEADD(HOUR, 4, CONVERT(varchar(20),GETDATE(),120))
	  FROM [NextGenETL].[dbo].[PiplineRun]
	  where  try_convert(bigint,[id]) is not null
	  order by convert(int,[id]) desc

	  truncate table [NextGenETL].[dbo].[PiplineRun]





END
