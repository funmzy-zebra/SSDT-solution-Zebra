
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_TruncateMasterTablesINV]
	
AS
BEGIN
		truncate table [NextGenETL].[dbo].[InventoryDocumentHeaderAttributes]
		truncate table [NextGenETL].[dbo].[InventoryDocumentLineAttributes]
		truncate table [NextGenETL].[dbo].[InventoryLevelAttributes]
		truncate table [NextGenETL].[dbo].[SaleLevelAttributes]
		truncate table [NextGenETL].[dbo].[Master_Custom]
		truncate table [NextGenETL].[dbo].[Master_Product]
		truncate table [NextGenETL].[dbo].[Master_Resource]
		truncate table [NextGenETL].[dbo].[Master_Site]
		truncate table [NextGenETL].[dbo].[Master_Vendor]
		truncate table [NextGenETL].[dbo].Master_InventoryDocumentType
		truncate table [NextGenETL].[dbo].FileKey
		
END


--truncate table [NextGenETL].[dbo].Daily_SaleLevel
--truncate table [NextGenETL].[dbo].Daily_InventoryLevel
--truncate table [NextGenETL].[dbo].Daily_Inventory_Line
--truncate table [NextGenETL].[dbo].Daily_Inventory_Header


