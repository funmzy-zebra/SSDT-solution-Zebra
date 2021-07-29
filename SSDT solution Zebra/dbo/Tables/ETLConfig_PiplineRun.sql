CREATE TABLE [dbo].[ETLConfig_PiplineRun] (
    [ConfigKey]                 NVARCHAR (250) NULL,
    [NvarcharValue]             NVARCHAR (250) NULL,
    [INTValue]                  BIGINT         NULL,
    [DateValue]                 DATETIME       NULL,
    [UpdateDate]                DATETIME       NULL,
    [pre_def_run_duration]      INT            NULL,
    [dag_exec_id]               VARCHAR (300)  NULL,
    [Transfer_History_FilePath] NVARCHAR (250) NULL,
    [dag_exec_status]           NVARCHAR (250) NULL
);

