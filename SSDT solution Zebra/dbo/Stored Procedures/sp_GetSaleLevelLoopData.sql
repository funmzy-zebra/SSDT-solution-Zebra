
create procedure [dbo].[sp_GetSaleLevelLoopData]
as 
begin
    IF ((SELECT COUNT(*) FROM [dbo].[Daily_SaleLevel] )>0 )
		BEGIN
			SELECT distinct '[DocumentDate] = '''''+ convert(nvarchar(10) ,[DocumentDate],126) +''''''
			FROM [dbo].[Daily_SaleLevel]
			Order By '[DocumentDate] = '''''+ convert(nvarchar(10) ,[DocumentDate],126) +'''''' Desc
		END
    ELSE
		BEGIN
			SELECT '[DocumentDate] = '''''+ convert(nvarchar(10) ,'1982-08-25 00:00:00.000',126) +''''''
		END
end
