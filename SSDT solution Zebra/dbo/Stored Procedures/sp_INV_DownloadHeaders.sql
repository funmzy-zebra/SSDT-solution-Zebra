

CREATE PROCEDURE [dbo].[sp_INV_DownloadHeaders]
	@i nvarchar(255) = '' 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	declare @query nvarchar(max)= 
	'SELECT [InventoryHeaderCode]
	  ,Convert(nvarchar(19), [DocumentDate], 121) --yyyy-MM-dd HH:mm:ss
      ,[SiteCode]
      ,[ValidatedBy]
      ,[ApprovedBy]
      ,[DocumentNumber]
      ,[DocumentTypeCode]
      ,Convert(nvarchar(19), [UpdateDate], 121)
      ,Convert(nvarchar(19), [InsertDate], 121)
      ,[InventoryCountFrequencyID]
      ,[InventoryCountTypeByProductID]
	  ,[InventoryHeaderCode]
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
	  ,[PrimaryResourceCode]
  FROM [dbo].[Daily_Inventory_Header]'

  if (@i <> '') 
  begin 
	set @query = @query + ' Where ' + @i
  end
  --print @query
  exec (@query)



/********************************************* Testing ********************************************/
/*
exec [DownloadInventoryHeaders] '[DocumentDate] = ''2013-01-27'''

IF ((SELECT COUNT(*) FROM [dbo].[Daily_Inventory_Header] )>0 ) 
BEGIN 
	SELECT distinct '[DocumentDate] = '''''+ convert(nvarchar(10) ,[DocumentDate],126) +''''''
	FROM [dbo].[Daily_Inventory_Header]
	Order By '[DocumentDate] = '''''+ convert(nvarchar(10) ,[DocumentDate],126) +'''''' Desc
END
ELSE 
BEGIN
	SELECT '[DocumentDate] = '''''+ convert(nvarchar(10) ,'1982-08-25 00:00:00.000',126) +''''''
END
*/
/********************************************* Testing end *****************************************/

END

