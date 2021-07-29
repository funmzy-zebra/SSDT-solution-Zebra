CREATE TABLE [dbo].[Master_InventoryDocumentType] (
    [DocumentTypeCode]        NVARCHAR (50)  NOT NULL,
    [DocumentTypeDescription] NVARCHAR (100) NULL,
    [ProfitectCode]           INT            NOT NULL,
    [ParentDocumentTypeCode]  INT            NULL,
    [Level]                   INT            NULL,
    [ReverseSign]             BIT            NULL
);

