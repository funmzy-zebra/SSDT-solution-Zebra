
CREATE PROCEDURE [dbo].[sp_DownloadInventoryLevel]
	@i nvarchar(255) = '' 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	declare @query nvarchar(max)= 
    'SELECT [SiteCode]
      ,Convert(nvarchar(19), [InventoryDate], 121)
      ,[ProductCode]
      ,[ItemQuantity]
      ,[ItemCost]
      ,[ItemRetail]
      ,Convert(nvarchar(19), [UpdateDate], 121)
      ,[VendorCode]
      ,[CostAmount]
      ,[RetailAmount]
	  ,[FileKey]
	  ,[UOM]
	  ,[AttributeInt1]
      ,[AttributeInt2]
      ,[AttributeInt3]
      ,[AttributeInt4]
      ,[AttributeInt5]
      ,convert(int, [AttributeBit1]) as [AttributeBit1]
      ,convert(int, [AttributeBit2]) as [AttributeBit2]
      ,convert(int, [AttributeBit3]) as [AttributeBit3]
      ,convert(int, [AttributeBit4]) as [AttributeBit4]
      ,convert(int, [AttributeBit5]) as [AttributeBit5]
      ,convert(int, [AttributeBit6]) as [AttributeBit6]
      ,convert(int, [AttributeBit7]) as [AttributeBit7]
      ,convert(int, [AttributeBit8]) as [AttributeBit8]
      ,convert(int, [AttributeBit9]) as [AttributeBit9]
      ,convert(int, [AttributeBit10]) as [AttributeBit10]
      ,[AttributeGroupID1]
      ,[AttributeGroupID2]
      ,[AttributeGroupID3]
      ,[AttributeGroupID4]
      ,[AttributeGroupID5]
      ,[AttributeGroupID6]
      ,[AttributeGroupID7]
      ,[AttributeGroupID8]
      ,[AttributeGroupID9]
      ,[AttributeGroupID10]
	  ,[CustomCode]
	  ,[Measure1]
      ,[Measure2]
      ,[Measure3]
      ,[Measure4]
      ,[Measure5]
      ,[Measure6]
      ,[Measure7]
      ,[Measure8]
      ,[Measure9]
      ,[Measure10]
	 FROM [dbo].[Daily_InventoryLevel]'
  if (@i <> '') 
  begin 
	set @query = @query + ' Where ' + @i
  end
  --print @query
  exec (@query)




/********************************************* Testing ********************************************/
/*

exec [sp_DownloadInventoryLevel] '[InventoryDate] = ''2013-04-06'''

IF ((SELECT COUNT(*) FROM [Daily_Inventory_Level] )>0 ) 
BEGIN 
	SELECT distinct '[InventoryDate] = '''''+ convert(nvarchar(10) ,[InventoryDate],126) +''''''
	FROM [dbo].[Daily_Inventory_Level]
	Order By		'[InventoryDate] = '''''+ convert(nvarchar(10) ,[InventoryDate],126) +'''''' Desc
END
ELSE 
BEGIN
	SELECT '[InventoryDate] = '''''+ convert(nvarchar(10) ,'1982-08-25 00:00:00.000',126) +''''''
END
*/
/********************************************* Testing end *****************************************/
END

