-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_TriggerDag]
     @ReturnResult int = 0 OUTPUT 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   SET @ReturnResult = 0;
    -- Insert statements for procedure here
   BEGIN TRY
	Declare @triggerDate NVARCHAR(100);
    DECLARE @dag_name VARCHAR(100),
	        @DagLocation VARCHAR(100),
			@AuthUser VARCHAR(100),
			@project VARCHAR(100),
			@AuthKeyPath VARCHAR(100),
			@dag_run_id Varchar(100),
			@exec_date varchar(100);
	DECLARE @shell_cmd VARCHAR(1000);
    Declare @cur_date datetime;
	CREATE TABLE #xp_out (coutput varchar(1000));

	SET @cur_date = getdate()

	SET @triggerDate = (SELECT FORMAT(@cur_date,'yyyyMMddTHHmmss'));
	SET @exec_date = (SELECT FORMAT(@cur_date,'yyyy-MM-dd HH:mm:ss'));
	SET @dag_name = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'DagName');
	SET @DagLocation= (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'DagLocation');
	SET @AuthUser = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'AuthUser');
	SET @project = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'project');
	SET @AuthKeyPath = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'AuthKeyPath');
	SET @dag_run_id = 'di_'+@triggerDate;

	SET @shell_cmd = 'gcloud auth activate-service-account '+@AuthUser+' --key-file='+@AuthKeyPath;

	PRINT @shell_cmd;
    EXEC sp_nextgen_etl_run_cmd @shell_cmd;
	--
	SET @shell_cmd = 'gcloud composer environments run composer --project '+@project+' --location '+@DagLocation+' --account '+@AuthUser+' trigger_dag -- '+@dag_name+' --run_id=di_'+@triggerDate;

	PRINT @shell_cmd;

	Update [dbo].[ETLConfig_PiplineRun]
	set [NvarcharValue] = @dag_run_id
	   ,dag_exec_id = @dag_run_id
	   ,[DateValue] = @exec_date
	   ,[UpdateDate] = Getdate()
	where [ConfigKey] = @dag_name

    EXEC sp_nextgen_etl_run_cmd @shell_cmd;
	

	END TRY
	BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000);
	SELECT @ErrorMessage = ERROR_MESSAGE();
	RAISERROR (@ErrorMessage, 16, 1);
	END CATCH

END
