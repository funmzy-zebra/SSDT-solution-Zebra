CREATE TABLE [dbo].[Daily_POS_HeaderReason_HeaderReasonRel] (
    [File_ID]                           NVARCHAR (1000) NULL,
    [POSDocumentHeaderID]               BIGINT          NULL,
    [POSDocumentHeaderCode]             NVARCHAR (1000) NULL,
    [POSDocumentReasonName]             NVARCHAR (1000) NULL,
    [POSDocumentHeaderReasonLevel1Name] NVARCHAR (1000) NULL,
    [POSDocumentCode]                   NVARCHAR (1000) NULL,
    [DocumentDate]                      DATETIME2 (7)   NULL,
    [DateTime_Added]                    NVARCHAR (1000) NULL
);

