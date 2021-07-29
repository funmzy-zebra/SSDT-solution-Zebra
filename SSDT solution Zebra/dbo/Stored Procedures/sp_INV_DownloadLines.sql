

CREATE PROCEDURE [dbo].[sp_INV_DownloadLines]
	@i nvarchar(255) = '' 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	declare @query nvarchar(max)= 
   'SELECT [InventoryLineCode]
			,[InventoryHeaderCode]
			,[DocumentLineNumber]
			,[ItemQuantity]
			,[ItemCostPrice]
			,[ItemRetailPrice]
			,[ProductCode]
			,Convert(nvarchar(19), [UpdateDate], 121) --yyyy-MM-dd HH:mm:ss
			,[ValidatedByCode]
			,[ApprovedByCode]
			,[OriginalVendorCode]
			,Convert(nvarchar(19), [DocumentDate], 121) 
			,case when [DirectionIN]=0 then ''0'' when [DirectionIN]=1 then ''1'' end
			,case when [DirectionOUT]=0 then ''0''when [DirectionOUT]=1 then ''1''  end as DirectionOUT
			,[ReasonCode]
			,[InventoryLineCode]
			,isnull(convert(tinyint      ,[IsMerchandise]),0)[IsMerchandise]
			,[LineCostAmount]
			,[LineRetailAmount]
			,[ReducedItemCostAmount]
			,[ReducedItemRetailAmount]
			,[AttributeInt1]
			,[AttributeInt2]
			,[AttributeInt3]
			,[AttributeInt4]
			,[AttributeInt5]
			,convert(int,[AttributeBit1])
			,convert(int,[AttributeBit2])
			,convert(int,[AttributeBit3])
			,convert(int,[AttributeBit4])
			,convert(int,[AttributeBit5])
			,convert(int,[AttributeBit6])
			,convert(int,[AttributeBit7])
			,convert(int,[AttributeBit8])
			,convert(int,[AttributeBit9])
			,convert(int,[AttributeBit10])
			,[AttributeGroupCode1]
			,[AttributeGroupCode2]
			,[AttributeGroupCode3]
			,[AttributeGroupCode4]
			,[AttributeGroupCode5]
			,[AttributeGroupCode6]
			,[AttributeGroupCode7]
			,[AttributeGroupCode8]
			,[AttributeGroupCode9]
			,[AttributeGroupCode10]
			,[FileKey]
			,[UOM]
			,[Measure1]
			,[Measure2]
			,[Measure3]
			,[CustomCode]
			,[PrimaryResourceCode]
			,[Measure4]
			,[Measure5]
			,[Measure6]
			,[Measure7]
			,[Measure8]
			,[Measure9]
			,[Measure10]
			,isnull(convert(tinyint      ,[AttributeBit11]),0)  as [AttributeBit11]
			,isnull(convert(tinyint      ,[AttributeBit12]),0)  as [AttributeBit12]
			,isnull(convert(tinyint      ,[AttributeBit13]),0)  as [AttributeBit13]
			,isnull(convert(tinyint      ,[AttributeBit14]),0)  as [AttributeBit14]
			,isnull(convert(tinyint      ,[AttributeBit15]),0)  as [AttributeBit15]
			,isnull(convert(tinyint      ,[AttributeBit16]),0)  as [AttributeBit16]
			,isnull(convert(tinyint      ,[AttributeBit17]),0)  as [AttributeBit17]
			,isnull(convert(tinyint      ,[AttributeBit18]),0)  as [AttributeBit18]
			,isnull(convert(tinyint      ,[AttributeBit19]),0)  as [AttributeBit19]
			,isnull(convert(tinyint      ,[AttributeBit20]),0)  as [AttributeBit20]
			,[AttributeGroupCode11]
			,[AttributeGroupCode12]
			,[AttributeGroupCode13]
			,[AttributeGroupCode14]
			,[AttributeGroupCode15]
			,[AttributeGroupCode16]
			,[AttributeGroupCode17]
			,[AttributeGroupCode18]
			,[AttributeGroupCode19]
			,[AttributeGroupCode20]
			,[AttributeInt6]
			,[AttributeInt7]
			,[AttributeInt8]
			,[AttributeInt9]
			,[AttributeInt10]
			,[AttributeInt11]
			,[AttributeInt12]
			,[AttributeInt13]
			,[AttributeInt14]
			,[AttributeInt15]
  FROM [dbo].[Daily_Inventory_Line] '
if (@i <> '') 
  begin 
	set @query = @query + ' Where ' + @i
  end
  --print @query
  exec (@query)

END

/********************************************* Testing ********************************************/
/*
exec [DownloadInventoryLines] '[DocumentDate] = ''2013-01-27'''

IF ((SELECT COUNT(*) FROM [dbo].[Daily_Inventory_Line] )>0 ) 
BEGIN 
	SELECT distinct '[DocumentDate] = '''''+ convert(nvarchar(10) ,[DocumentDate],126) +''''''
	FROM [dbo].[Daily_Inventory_Line]
	Order By '[DocumentDate] = '''''+ convert(nvarchar(10) ,[DocumentDate],126) +'''''' Desc
END
ELSE 
BEGIN
	SELECT '[DocumentDate] = '''''+ convert(nvarchar(10) ,'1982-08-25 00:00:00.000',126) +''''''
END
*/
/********************************************* Testing end *****************************************/



