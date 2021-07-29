﻿CREATE TABLE [dbo].[Daily_POS_PromotionalDiscount] (
    [File_ID]                 NVARCHAR (1000) NULL,
    [POSDocumentHeaderID]     BIGINT          NULL,
    [POSDocumentHeaderCode]   NVARCHAR (1000) NULL,
    [POSDocumentLineCode]     NVARCHAR (1000) NULL,
    [DiscountTypeCode]        NVARCHAR (1000) NULL,
    [TimeScan]                DATETIME2 (7)   NULL,
    [TimeScanDateID]          BIGINT          NULL,
    [TimeScanTimeID]          BIGINT          NULL,
    [SiteCode]                NVARCHAR (1000) NULL,
    [ShiftCode]               NVARCHAR (1000) NULL,
    [ResourceCodeCashier]     NVARCHAR (1000) NULL,
    [TotalDiscount]           FLOAT (53)      NULL,
    [TotalHeaderDiscount]     FLOAT (53)      NULL,
    [ProductCode]             NVARCHAR (1000) NULL,
    [DocumentTypeCode]        NVARCHAR (1000) NULL,
    [ItemQuantity]            BIGINT          NULL,
    [DiscountCode]            NVARCHAR (1000) NULL,
    [FileKey]                 NVARCHAR (1000) NULL,
    [AttributeBit1]           BIT             NULL,
    [AttributeBit2]           BIT             NULL,
    [AttributeBit3]           BIT             NULL,
    [AttributeBit4]           BIT             NULL,
    [AttributeBit5]           BIT             NULL,
    [AttributeGroupCode1]     NVARCHAR (1000) NULL,
    [AttributeGroupCode2]     NVARCHAR (1000) NULL,
    [AttributeGroupCode3]     NVARCHAR (1000) NULL,
    [AttributeGroupCode4]     NVARCHAR (1000) NULL,
    [AttributeGroupCode5]     NVARCHAR (1000) NULL,
    [PosDocumentDiscountCode] NVARCHAR (1000) NULL,
    [Measure1]                FLOAT (53)      NULL,
    [Measure2]                FLOAT (53)      NULL,
    [Measure3]                FLOAT (53)      NULL,
    [Measure4]                FLOAT (53)      NULL,
    [Measure5]                FLOAT (53)      NULL,
    [Measure6]                FLOAT (53)      NULL,
    [Measure7]                FLOAT (53)      NULL,
    [Measure8]                FLOAT (53)      NULL,
    [Measure9]                FLOAT (53)      NULL,
    [Measure10]               FLOAT (53)      NULL,
    [DateTime_Added]          NVARCHAR (1000) NULL
);

