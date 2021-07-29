-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_Update_DAG_LastRun_To_ConfigTBL]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @dag_name VARCHAR(100);
	SET @dag_name = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'DagName');
    -- Insert statements for procedure here
	 update g set 
	   INTValue = ISNULL((SELECT top 1 [id] FROM [NextGenETL].[dbo].[LOG_PiplineRun]
				   where id > (SELECT [INTValue] FROM [dbo].[ETLConfig_PiplineRun] where ConfigKey = @dag_name)
						and [DAG_Name] = @dag_name
						and [state] in ( 'success' ,'failed')),INTValue)

	  ,UpdateDate = getdate()  
	  FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] g where ConfigKey = @dag_name

	   

END
