
create procedure [dbo].[sp_GetInventoryLevelLoopData]
as 
begin
    IF ((SELECT COUNT(*) FROM [Daily_InventoryLevel] )>0 )
		BEGIN
			SELECT distinct '[InventoryDate] = '''''+ convert(nvarchar(10) ,[InventoryDate],126) +''''''
			FROM [dbo].[Daily_InventoryLevel]
			Order By		'[InventoryDate] = '''''+ convert(nvarchar(10) ,[InventoryDate],126) +'''''' Desc
		END
    ELSE
		BEGIN
			SELECT '[InventoryDate] = '''''+ convert(nvarchar(10) ,'1982-08-25 00:00:00.000',126) +''''''
		END
end
