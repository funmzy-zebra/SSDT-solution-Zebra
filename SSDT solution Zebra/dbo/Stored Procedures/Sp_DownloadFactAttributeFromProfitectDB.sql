
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_DownloadFactAttributeFromProfitectDB]
	-- Add the parameters for the stored procedure here
	 @profitectDB nvarchar(100), 
  	 @factTableName nvarchar(100), 
	 @attributeNumer nvarchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	declare @query  nvarchar(max)


     set @query = 'SELECT [AttributeGroupID'+@attributeNumer+'Value]
		         , [AttributeGroupID'+@attributeNumer+']
		  FROM ['+@profitectDB+'].[dbo].['+@factTableName+'AttributeGroupID'+@attributeNumer+']'

	 if @factTableName = 'POSDocumentTender'
		begin
			set @query = 'SELECT [AttributeGroupID' + @attributeNumer + 'Value]
				                ,[AttributeGroupID' + @attributeNumer + ']
						  FROM [' + @profitectDB + '].[dbo].[' + @factTableName + 'AttributeGroupID' + @attributeNumer + '] id
						  WHERE EXISTS (SELECT 0 FROM dbo.Daily_POS_Tender t WHERE id.AttributeGroupID' + @attributeNumer + 'Value = t.AttributeGroupCode' + @attributeNumer + ')'
			print @query						   
		end

	 if @factTableName = 'POSDocumentLoyaltyCards'
		begin
			set @query = 'SELECT [AttributeGroupID' + @attributeNumer + 'Value]
				                ,[AttributeGroupID' + @attributeNumer + ']
						  FROM [' + @profitectDB + '].[dbo].[' + @factTableName + 'AttributeGroupID' + @attributeNumer + '] id
						  WHERE EXISTS (SELECT 0 FROM dbo.Daily_POS_LoyaltyCards lc WHERE id.AttributeGroupID' + @attributeNumer + 'Value = lc.AttributeGroupCode' + @attributeNumer + ')'
			print @query						   
		end

	EXEC( @query )
END
