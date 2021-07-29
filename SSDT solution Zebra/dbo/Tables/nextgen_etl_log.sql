CREATE TABLE [dbo].[nextgen_etl_log] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [dt]         DATETIME       NULL,
    [spid]       SMALLINT       NULL,
    [user_login] [sysname]      NULL,
    [host]       NVARCHAR (128) NULL,
    [proc_id]    INT            NULL,
    [proc_name]  [sysname]      NULL,
    [cmd]        VARCHAR (8000) NULL,
    [is_error]   BIT            NULL,
    [msg]        NVARCHAR (MAX) NULL
);

