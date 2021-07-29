-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_CreateIndexes]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS ( SELECT '1' FROM sys.indexes WHERE object_id = OBJECT_ID('[dbo].[Daily_POS_Lines]')AND name='NonClusteredIndex_Lines_filekey_headercode')  

	  CREATE NONCLUSTERED INDEX [NonClusteredIndex_Lines_filekey_headercode] ON [dbo].[Daily_POS_Lines]
		(

			[POSDocumentHeaderCode] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]



	IF NOT EXISTS ( SELECT '1' FROM sys.indexes WHERE object_id = OBJECT_ID('[dbo].[Daily_POS_Headers]')AND name='NonClusteredIndex-POSHeader_filekey_headercode')  
	
	
	  CREATE NONCLUSTERED INDEX [NonClusteredIndex-POSHeader_filekey_headercode] ON [dbo].[Daily_POS_Headers]
		(
			
			[POSDocumentHeaderCode] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


	IF NOT EXISTS ( SELECT '1' FROM sys.indexes WHERE object_id = OBJECT_ID('[dbo].[Daily_POS_LoyaltyCards]')AND name='NonClusteredIndex_LoyaltyCards_filekey_headercode')  

	CREATE NONCLUSTERED INDEX [NonClusteredIndex_LoyaltyCards_filekey_headercode] ON [dbo].[Daily_POS_LoyaltyCards]
		(
			
			[POSDocumentHeaderCode] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

    IF NOT EXISTS ( SELECT '1' FROM sys.indexes WHERE object_id = OBJECT_ID('[dbo].[Daily_POS_PromotionalDiscount]')AND name='NonClusteredIndex_Promo_filekey_headercode')  

	CREATE NONCLUSTERED INDEX [NonClusteredIndex_Promo_filekey_headercode] ON [dbo].[Daily_POS_PromotionalDiscount]
		(
			
			[POSDocumentHeaderCode] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]



	IF NOT EXISTS ( SELECT '1' FROM sys.indexes WHERE object_id = OBJECT_ID('[dbo].[Daily_POS_Tenders]')AND name='NonClusteredIndex_tenders_filekey_headercode')  

       CREATE NONCLUSTERED INDEX [NonClusteredIndex_tenders_filekey_headercode] ON [dbo].[Daily_POS_Tenders]
		(
			
			[POSDocumentHeaderCode] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


END
