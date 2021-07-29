CREATE TABLE [dbo].[BQ1_POS_Manual_MasterTablesToExtract_ToAppend] (
    [ID]           BIGINT         NULL,
    [TBL_FileName] NVARCHAR (300) NULL,
    [Delimiter]    NVARCHAR (2)   NULL,
    [sql_query]    NVARCHAR (419) NOT NULL
);

