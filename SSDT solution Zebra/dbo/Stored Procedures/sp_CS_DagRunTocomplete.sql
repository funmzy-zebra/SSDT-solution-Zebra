
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_DagRunTocomplete]
	  @ReturnResult int = 0 OUTPUT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @ReturnResult = 0;
	 BEGIN TRY
       Declare @cur_startetime datetime, @run_duration int;
    -- Insert statements for procedure here
	   DECLARE @dag_name VARCHAR(100);
	   DECLARE @dag_exec_id VARCHAR(100);
	   DECLARE @dag_FilePath VARCHAR(300);
	   DECLARE @shell_cmd_Query nvarchar (4000);
	   DECLARE @env  VARCHAR(100);
	   DECLARE @project varchar(100);

		SET @dag_name = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'DagName');
	    set @cur_startetime =(select DateValue from [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = @dag_name)
	    set @run_duration =  (select pre_def_run_duration from [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = @dag_name)
		set @dag_exec_id =   (select dag_exec_id from [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = @dag_name)
		SET @env = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'DagEnv');
		set @dag_FilePath  =   (select Transfer_History_FilePath from [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = @dag_name) + 'output.txt'
		set @project =  (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'project');

		

		set @shell_cmd_Query = Concat('bq query --nouse_legacy_sql --apilog=filename --format=csv "SELECT * FROM `', @project,'.bq_to_mssql_data_transfer_',@env,'.Transfer_History` WHERE Task_ID = ''gcs_to_bq'' and Dag_ID = ''',@dag_name,'''" > ',@dag_FilePath) 
		--select @shell_cmd_Query
		/*  ---- Here  For test
		EXEC master..xp_cmdshell @shell_cmd_Query;
		       truncate table PipelineTransfer_History
		       declare @p8 int
		        set @p8=0
				exec P_BulkInsert @filename=@dag_FilePath,@tablename=N'PipelineTransfer_History',@delimiter=',',@firstRow=2,@codepage=1255,@dataFileType='widechar',@RowPerBatch=35000,@ReturnResult=@p8 output
		       select @p8
         */

		While 1=1
		BEGIN

		DECLARE @shell_cmd VARCHAR(1000);
		Declare @DITrigger_GetPipplineRun varchar(1000);
		
		SET @DITrigger_GetPipplineRun = (SELECT [NvarcharValue] from  [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] = 'NX_DITrigger_GetPipplineRun');

		SET @shell_cmd =  @DITrigger_GetPipplineRun;
		PRINT @shell_cmd;
		--EXEC master..xp_cmdshell @shell_cmd;
		EXEC sp_nextgen_etl_run_cmd @shell_cmd;

		declare @dagstatus bit =
		 ( SELECT top 1 ISNULL('True','False')
		  FROM [NextGenETL].[dbo].[LOG_PiplineRun]
		  where id > (SELECT [INTValue] FROM [dbo].[ETLConfig_PiplineRun] where ConfigKey = @dag_name)
				and [DAG_Name] = @dag_name
				and [state] = 'success' 
				and id = (SELECT MAX( [id])  FROM [NextGenETL].[dbo].[LOG_PiplineRun] where [DAG_Name] = @dag_name)
		  order by 1 desc
		  )


		  declare @dagstatusFail bit =
		 (     SELECT top 1 'True'
			   FROM [NextGenETL].[dbo].[LOG_PiplineRun]
			   where id > (SELECT [INTValue] FROM [dbo].[ETLConfig_PiplineRun] where ConfigKey = @dag_name)
			         and [DAG_Name] = @dag_name
			   	and [state] = 'failed' 
			   	and id = (SELECT MAX( [id])  FROM [NextGenETL].[dbo].[LOG_PiplineRun] where [DAG_Name] = @dag_name)
			   	and id <> (SELECT MAX( [id])  FROM [NextGenETL].[dbo].[LOG_PiplineRun] where [DAG_Name] = @dag_name and [state] = 'success' )
			   order by 1 desc
			   	  )


         update s set [dag_exec_status] =(SELECT top 1 [state] FROM [NextGenETL].[dbo].[LOG_PiplineRun] where  run_id = @dag_exec_id) FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] s where ConfigKey = @dag_name;

		  	EXEC sp_nextgen_etl_run_cmd @shell_cmd_Query;
		       truncate table PipelineTransfer_History
		       declare @p8 int
		        set @p8=0
				exec P_BulkInsert @filename=@dag_FilePath,@tablename=N'PipelineTransfer_History',@delimiter=',',@firstRow=2,@codepage=1255,@dataFileType='widechar',@RowPerBatch=35000,@ReturnResult=@p8 output
		       select @p8

			   -- moved to top on 3/18/2021  
		 declare @trf_dagstatus bit =
		 ( Select top 1 ISNULL('True','False')
               from [NextGenETL].[dbo].[ETLConfig_PiplineRun]  l  inner join  [NextGenETL].[dbo].[PipelineTransfer_History] h
                on  l.ConfigKey=h.Dag_ID and l.dag_exec_id=h.run_id
                where l.ConfigKey = @dag_name and h.state = 'success'
		  )


		  declare @trf_dagstatusFail bit =
		 (    Select top 1 'True'
				from [NextGenETL].[dbo].[ETLConfig_PiplineRun]  l  inner join  [NextGenETL].[dbo].[PipelineTransfer_History] h
				on  l.ConfigKey=h.Dag_ID and l.dag_exec_id=h.run_id
				where l.ConfigKey = @dag_name and h.state = 'failed' 
	      )

		  if @trf_dagstatus='True' 
		     Begin  
			  update s set [dag_exec_status] ='success' FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] s where ConfigKey = @dag_name;
			  break;
			 END
		  if @trf_dagstatusFail = 'True' 
		     Begin  
			  update s set [dag_exec_status] ='failed' FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] s where ConfigKey = @dag_name;
			  break;
			 END

		  if @dagstatus='True' 
		     Begin  
			  update s set [dag_exec_status] ='success' FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] s where ConfigKey = @dag_name;
			  break;
			 END
		  if @dagstatusFail = 'True' 
		     Begin  
			  update s set [dag_exec_status] ='failed' FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] s where ConfigKey = @dag_name;
			  break;
			 END
           
		

            

		  If DATEDIFF(MINUTE,@cur_startetime,getdate())> @run_duration
		  BEGIN
		     print 'sending an email'
		     DECLARE @M_BODY VARCHAR(8000);
			                  /* HEADER */
							SET @M_BODY = 
								'<p>
										Hello,
										<br />
										<br />
										 DAG ' +@dag_name+ ' with execution ID '+@dag_exec_id+' sampling wasn''t complete after '+cast(@run_duration as nvarchar)+' minutes.
										<br />
										 Please confirm DAG completion and proceed manually to the next step with DAG completion.
										<br />
								  <p/>'
			 DECLARE @subject varchar(500);
			                set @project = (SELECT [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'project');
			                set @subject = concat('Alert:  MonitorETL Alarm Activated on ',@project, ' for DAG ', @dag_name);
             print @M_BODY
			 print @subject
			 EXEC	[dbo].[sp_EmailNotification]
					@MAIL_BODY = @M_BODY,
					@msg_subject = @subject 

		       
		     BREAK;
		  END
		  
		  WAITFOR DELAY '00:05:05'

END

END TRY
	BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000);
	SELECT @ErrorMessage = ERROR_MESSAGE();
	RAISERROR (@ErrorMessage, 16, 1);
	END CATCH
		
END
