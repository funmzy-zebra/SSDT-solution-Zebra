-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_TruncateTablesAndDropIndexes]
	
AS
BEGIN
		truncate table [NextGenETL].[dbo].[Daily_POS_Headers]
		truncate table [NextGenETL].[dbo].[Daily_POS_Lines]
		truncate table [NextGenETL].[dbo].[Daily_POS_LoyaltyCards]
		truncate table [NextGenETL].[dbo].[Daily_POS_Tenders]
		truncate table [NextGenETL].[dbo].[Daily_POS_PromotionalDiscount]
		truncate table [NextGenETL].[dbo].[Daily_POS_HeaderReason_HeaderReasonRel]

		IF EXISTS ( SELECT '1' FROM sys.indexes WHERE object_id = OBJECT_ID('[dbo].[Daily_POS_Lines]')AND name='NonClusteredIndex_Lines_filekey_headercode')  
			  DROP INDEX [NonClusteredIndex_Lines_filekey_headercode] ON [dbo].[Daily_POS_Lines]
		IF EXISTS ( SELECT '1' FROM sys.indexes WHERE object_id = OBJECT_ID('[dbo].[Daily_POS_Headers]')AND name='NonClusteredIndex-POSHeader_filekey_headercode')  
			  DROP INDEX [NonClusteredIndex-POSHeader_filekey_headercode] ON [dbo].[Daily_POS_Headers]
		IF EXISTS ( SELECT '1' FROM sys.indexes WHERE object_id = OBJECT_ID('[dbo].[Daily_POS_LoyaltyCards]')AND name='NonClusteredIndex_LoyaltyCards_filekey_headercode')  
			 DROP INDEX [NonClusteredIndex_LoyaltyCards_filekey_headercode] ON [dbo].[Daily_POS_LoyaltyCards]
		IF EXISTS ( SELECT '1' FROM sys.indexes WHERE object_id = OBJECT_ID('[dbo].[Daily_POS_Tenders]')AND name='NonClusteredIndex_tenders_filekey_headercode')  
			 DROP INDEX [NonClusteredIndex_tenders_filekey_headercode] ON [dbo].[Daily_POS_Tenders]
		IF EXISTS ( SELECT '1' FROM sys.indexes WHERE object_id = OBJECT_ID('[dbo].[Daily_POS_PromotionalDiscount]')AND name='NonClusteredIndex_Promo_filekey_headercode')  
			 DROP INDEX [NonClusteredIndex_Promo_filekey_headercode] ON [dbo].[Daily_POS_PromotionalDiscount]



END
