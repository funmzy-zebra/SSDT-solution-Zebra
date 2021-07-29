CREATE TABLE [dbo].[Master_Vendor] (
    [VendorCode]            NVARCHAR (1000) NOT NULL,
    [VendorName]            NVARCHAR (1000) NULL,
    [VendorDescription]     NVARCHAR (1000) NULL,
    [DateCreated]           DATETIME        NULL,
    [DateModified]          DATETIME        NULL,
    [CrossDockIndicator]    BIT             NULL,
    [VendorTypeName]        NVARCHAR (1000) NULL,
    [VendorTypeDescription] NVARCHAR (1000) NULL,
    [ParentVendorCode]      NVARCHAR (1000) NULL,
    [AttributeBit1]         BIT             NULL,
    [AttributeGroupCode1]   NVARCHAR (1000) NULL
);

