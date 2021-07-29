CREATE TABLE [dbo].[LOG_PiplineRun] (
    [id]             BIGINT         NULL,
    [run_id]         NVARCHAR (250) NULL,
    [state]          NVARCHAR (250) NULL,
    [execution_date] DATETIME       NULL,
    [state_date]     NVARCHAR (250) NULL,
    [DAG_Name]       NVARCHAR (250) NULL,
    [InsertDate_CST] DATETIME       NULL
);

