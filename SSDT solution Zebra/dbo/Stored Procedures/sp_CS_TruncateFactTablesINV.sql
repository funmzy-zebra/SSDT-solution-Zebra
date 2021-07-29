

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_TruncateFactTablesINV]
	
AS
BEGIN
		truncate table [NextGenETL].[dbo].[Daily_Inventory_Header]
		truncate table [NextGenETL].[dbo].[Daily_Inventory_Line]
		truncate table [NextGenETL].[dbo].[Daily_InventoryLevel]
		truncate table [NextGenETL].[dbo].[Daily_SaleLevel]
		truncate table [NextGenETL].[dbo].[InventoryLevel_stg_bq]
		truncate table [NextGenETL].[dbo].[SaleLevel_stg_bq]
		truncate table [NextGenETL].[dbo].[InventoryDocumentLine_stg_bq]
		truncate table [NextGenETL].[dbo].[InventoryDocumentHeader_stg_bq]
		
		
END
