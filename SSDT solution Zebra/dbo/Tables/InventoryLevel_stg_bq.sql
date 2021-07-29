﻿CREATE TABLE [dbo].[InventoryLevel_stg_bq] (
    [InventoryDailyID]                BIGINT   NULL,
    [SiteID]                          BIGINT   NOT NULL,
    [InventoryDate]                   DATETIME NOT NULL,
    [ProductID]                       BIGINT   NOT NULL,
    [ItemQuantity]                    REAL     NULL,
    [ItemCost]                        REAL     NULL,
    [ItemRetail]                      REAL     NULL,
    [UpdateDate]                      DATETIME NOT NULL,
    [VendorID]                        BIGINT   NULL,
    [CostAmount]                      REAL     NULL,
    [RetailAmount]                    REAL     NULL,
    [InventoryCountByProductPeriodID] BIGINT   NULL,
    [FileKeyID]                       BIGINT   NULL,
    [UOM]                             REAL     NULL,
    [AttributeInt1]                   BIGINT   NULL,
    [AttributeInt2]                   BIGINT   NULL,
    [AttributeInt3]                   BIGINT   NULL,
    [AttributeInt4]                   BIGINT   NULL,
    [AttributeInt5]                   BIGINT   NULL,
    [AttributeBit1]                   BIT      NULL,
    [AttributeBit2]                   BIT      NULL,
    [AttributeBit3]                   BIT      NULL,
    [AttributeBit4]                   BIT      NULL,
    [AttributeBit5]                   BIT      NULL,
    [AttributeBit6]                   BIT      NULL,
    [AttributeBit7]                   BIT      NULL,
    [AttributeBit8]                   BIT      NULL,
    [AttributeBit9]                   BIT      NULL,
    [AttributeBit10]                  BIT      NULL,
    [AttributeGroupID1]               BIGINT   NULL,
    [AttributeGroupID2]               BIGINT   NULL,
    [AttributeGroupID3]               BIGINT   NULL,
    [AttributeGroupID4]               BIGINT   NULL,
    [AttributeGroupID5]               BIGINT   NULL,
    [AttributeGroupID6]               BIGINT   NULL,
    [AttributeGroupID7]               BIGINT   NULL,
    [AttributeGroupID8]               BIGINT   NULL,
    [AttributeGroupID9]               BIGINT   NULL,
    [AttributeGroupID10]              BIGINT   NULL,
    [CustomID]                        BIGINT   NULL,
    [Measure1]                        REAL     NULL,
    [Measure2]                        REAL     NULL,
    [Measure3]                        REAL     NULL,
    [Measure4]                        REAL     NULL,
    [Measure5]                        REAL     NULL,
    [Measure6]                        REAL     NULL,
    [Measure7]                        REAL     NULL,
    [Measure8]                        REAL     NULL,
    [Measure9]                        REAL     NULL,
    [Measure10]                       REAL     NULL
);

