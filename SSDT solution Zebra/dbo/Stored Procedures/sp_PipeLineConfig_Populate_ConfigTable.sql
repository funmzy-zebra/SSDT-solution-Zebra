CREATE PROCEDURE [dbo].[sp_PipeLineConfig_Populate_ConfigTable] 
(
 --@sourceDB varchar(50), 
 @NextGenETLDrive varchar(150), 
 @NextGenProjectName varchar(150), 
 @ProfitectDB varchar(150),
 @stagingDB varchar(150),
 @DagLocation varchar(150),
 @DagEnv  varchar(150),
 @BQ1_Project VARCHAR(150),
 @ZPA_Dataset VARCHAR(150),
 @BQ1_DataSet VARCHAR(150),
 @ETLTransfer_DataSet VARCHAR(150),
 @AuthUser VARCHAR(150),
 @AuthKeyPath VARCHAR(150),
 @sql_bin VARCHAR(150),
 @datafeedName VARCHAR(150),
-- @NextGenETLFolder  VARCHAR(150),  --DITrigger_GetPipplineRun
 @NX_DITrigger_GetPipplineRun VARCHAR(150)
)
AS
BEGIN

print 'BackUPOfCurrentConfig'

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ETLConfig_PiplineRun]') AND type in (N'U'))
BEGIN
	DECLARE @s  nvarchar (255)
	Declare @table nvarchar (255)
	SET @table = CONCAT('[NextGenETL].[dbo].[ETLConfig_PiplineRun_BK', FORMAT(GETDATE(), 'yyyyMMddHHmmss'),']');
	SET @s = CONCAT('DROP TABLE IF EXISTS ', @table);
	print @s
	exec(@s)
	SET @s = CONCAT('SELECT *  into ',@table, ' FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun]');
	print @s
	exec(@s)
    DROP TABLE [dbo].[ETLConfig_PiplineRun]


END

	CREATE TABLE [dbo].[ETLConfig_PiplineRun](
	[ConfigKey] [nvarchar](250) NULL,
	[NvarcharValue] [nvarchar](250) NULL,
	[INTValue] [bigint] NULL,
	[DateValue] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[pre_def_run_duration] [int] NULL,
	[dag_exec_id] [varchar](300) NULL,
	[Transfer_History_FilePath] [nvarchar](250) NULL,
	[dag_exec_status] [nvarchar](250) NULL
) ON [PRIMARY]


INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'PosDocumentHeaderID', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'CurrentIterationNumber', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (@datafeedName+'-Processing_dev', NULL, NULL, NULL,NULL, 90, NULL, N'"'+@NextGenETLDrive+'Profitect\BQ_Data\"', NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (@datafeedName+'-Processing_preprod', NULL, NULL, NULL,NULL, 90, NULL, N'"'+@NextGenETLDrive+'Profitect\BQ_Data\"', NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (@datafeedName+'-Processing_prod', NULL, NULL, NULL,NULL, 90, NULL, N'"'+@NextGenETLDrive+'Profitect\BQ_Data\"', NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'DagName',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'POS_BQ1toBQ2-Processing_dev',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'POS_BQ1toBQ2-Processing_preprod',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'POS_BQ1toBQ2-Processing_prod',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'DagEnv', @DagEnv, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
--INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) VALUES (N'THD-Processing_dev/ExecTime', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'AuthUser', @AuthUser, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'AuthKeyPath', @AuthKeyPath, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'DagLocation', @DagLocation, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'project', @NextGenProjectName, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'sql_bin', @sql_bin, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'ProfitectDB', @ProfitectDB, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'BQ1_MasterFile_localPath', N'"'+@NextGenETLDrive+'Profitect\BQ_Data\NexGenMaster"', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'BQ1_MasterDataExportDate', N'"C:\Program Files\7-Zip\7z.exe" a -tzip "D:\BQ_Data\bq1_master"\BQ1_Master_20210408_232615.zip "D:\BQ_Data\bq1_master"\*.csv -mx1', NULL, CAST(N'2021-04-08T23:26:15.680' AS DateTime), CAST(N'2021-04-08T23:26:15.680' AS DateTime), NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'BQ1_Project', @BQ1_Project, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'BQ1_DataSet', @BQ1_DataSet, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'BQ1_ManualLoad_MasterFile_localPath', N'"'+@NextGenETLDrive+'Profitect\BQ_Data\NexGenMaster"', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'BQ1_ManualLoad_MasterFile_GSPath', N'gs://'+@BQ1_Project+'-data/POS_SQLToBQ1/master/', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'BQ1_MasterFile_GSPath', N'gs://'+@BQ1_Project+'-data/POS_SQLToBQ1/input/', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'BQ1_ManualLoad_FactFile_GSPath', N'gs://'+@BQ1_Project+'-data/POS_SQLToBQ1/fact/', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'BQ1_ManualLoad_FactFile_localPath', N''+@NextGenETLDrive+'Profitect\BQ_Data\NextGenFact', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'BQ1_FactFile_localPath', N''+@NextGenETLDrive+'Profitect\BQ_Data\NextGenFact', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'BQ1_FactDataExportDate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'BQ1_FactFile_GSPath', N'gs://'+@BQ1_Project+'-data/POS_SQLToBQ1/input/', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'ZPA_Dataset', @ZPA_Dataset, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'Pos_DocPromo_1_Cnt', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'Pos_DocLine_1_Cnt', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'NX_DITrigger_GetPipplineRun', @NX_DITrigger_GetPipplineRun, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'StagingDB', @StagingDB, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'ETLTransfer_DataSet', @ETLTransfer_DataSet, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'Pos_MaxOrginalReceiptID', N'OriginalReceiptID', 0, NULL, NULL, 0, NULL, NULL, NULL)
 
INSERT [dbo].[ETLConfig_PiplineRun] ([ConfigKey], [NvarcharValue], [INTValue], [DateValue], [UpdateDate], [pre_def_run_duration], [dag_exec_id], [Transfer_History_FilePath], [dag_exec_status]) 
VALUES (N'Pos_MaxRuleExecutionID', N'RuleExecutionID', 0, NULL, NULL, 0, NULL, NULL, NULL)
 
IF(SELECT COUNT(*) from dbo.ETLConfig_PiplineRun where ConfigKey ='BQ1_MaxPOSHeaderID' )=0
BEGIN
INSERT INTO [dbo].[ETLConfig_PiplineRun]
           ([ConfigKey]
           ,[INTValue]
          )
     SELECT 
           'BQ1_MaxPOSHeaderID'
           ,0
END
          
 
 
IF(SELECT COUNT(*) from dbo.ETLConfig_PiplineRun where ConfigKey ='external_csv_GSPath' )=0
BEGIN
INSERT INTO [dbo].[ETLConfig_PiplineRun]
           ([ConfigKey]
           ,[INTValue]
		   ,[NvarcharValue]
          )
     SELECT 
           'external_csv_GSPath'
           ,0
		   ,N'gs://'+@NextGenProjectName+'-bucket/external_csv/'
END
          
 
 
IF(SELECT COUNT(*) from dbo.ETLConfig_PiplineRun where ConfigKey ='external_csv_localPath' )=0
BEGIN
INSERT INTO [dbo].[ETLConfig_PiplineRun]
           ([ConfigKey]
           ,[INTValue]
		   ,[NvarcharValue]
          )
     SELECT 
           'external_csv_localPath'
           ,0
		   ,N'"'+@NextGenETLDrive+'Profitect\BQ_Data\external_csv\"'
END


SELECT  [ConfigKey]
      ,[NvarcharValue]
      'PLEASE MAKE SURE THAT PATHS BELOW EXISTS'
  FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun]
  where ConfigKey like '%local%'

END
