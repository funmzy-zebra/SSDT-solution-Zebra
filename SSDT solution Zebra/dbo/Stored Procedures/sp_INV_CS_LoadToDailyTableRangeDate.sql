
/* Start GateKeeper for Incremental Cube Processing		*/

-- =============================================
-- Author:		Pavel Kirillov
-- Update date: 2014-02-26 added Min date per Liran's request
-- Update date: 2014-11-25 added Limit date (Gatekeeper)
-- Description:	Deletes calendar dates not linked to any data in the system
-- =============================================
CREATE PROCEDURE [dbo].[sp_INV_CS_LoadToDailyTableRangeDate]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @DIRunDate datetime = GetDate()
	declare @minDateLinesStaging Datetime, @maxDateLinesStaging Datetime, @minDateLinesProfitectDB Datetime, @maxDateLinesProfitectDB Datetime
	declare @minDateSalesStaging Datetime, @maxDateSalesStaging Datetime, @minDateSalesProfitectDB Datetime, @maxDateSalesProfitectDB Datetime
	declare @minDateInventoryLevelStaging Datetime, @maxDateInventoryLevelStaging Datetime, @minDateInventoryLevelProfitectDB Datetime , @maxDateInventoryLevelProfitectDB Datetime

	declare @incrementalLimitInvDocs Datetime, @incrementalLimitInvLevel Datetime, @incrementalLimitSaleLevel Datetime

	select @incrementalLimitInvDocs = GetDate() - Cast((select ConfigurationValue from ProfitectDB.dbo.Configuration where ConfigurationKey = 'di_cube_process_inc_limit_inv_docs') as int)
	select @incrementalLimitInvLevel = GetDate() - Cast((select ConfigurationValue from ProfitectDB.dbo.Configuration where ConfigurationKey = 'di_cube_process_inc_limit_inv_level') as int)
	select @incrementalLimitSaleLevel = GetDate() - Cast((select ConfigurationValue from ProfitectDB.dbo.Configuration where ConfigurationKey = 'di_cube_process_inc_limit_sales_Level') as int)
	
	select @minDateLinesProfitectDB = MIN(DocumentDate) from ProfitectDB.dbo.InventoryDocumentHeader
	select @maxDateLinesProfitectDB = MAX(DocumentDate) from ProfitectDB.dbo.InventoryDocumentHeader
	select @minDateLinesStaging = MIN(DocumentDate) from dbo.Daily_Inventory_Line
	select @maxDateLinesStaging = MAX(DocumentDate) from dbo.Daily_Inventory_Line
	
	select @minDateSalesProfitectDB = MIN(DocumentDate) from ProfitectDB.dbo.SaleLevel
	select @maxDateSalesProfitectDB = MAX(DocumentDate) from ProfitectDB.dbo.SaleLevel
	select @minDateSalesStaging = MIN(DocumentDate) from dbo.Daily_SaleLevel
	select @maxDateSalesStaging = MAX(DocumentDate) from dbo.Daily_SaleLevel

	select @minDateInventoryLevelProfitectDB = MIN(InventoryDate) from ProfitectDB.dbo.InventoryLevel
	select @maxDateInventoryLevelProfitectDB = MAX(InventoryDate) from ProfitectDB.dbo.InventoryLevel
	select @minDateInventoryLevelStaging = MIN(InventoryDate) from dbo.Daily_InventoryLevel
	select @maxDateInventoryLevelStaging = MAX(InventoryDate) from dbo.Daily_InventoryLevel
	
	if @minDateLinesStaging is not null
	begin
	insert into ProfitectDB.dbo.DailyTableRangeDate (TableName, DiDate, StartDate, EndDate, MinDate )
	values ('v_Olap_InvFactMain', @DIRunDate, @minDateLinesStaging, @maxDateLinesStaging, @minDateLinesProfitectDB)
	end

	if @minDateSalesStaging is not null
	begin
	insert into ProfitectDB.dbo.DailyTableRangeDate (TableName, DiDate, StartDate, EndDate, MinDate )
	values ('v_Olap_InvDailyInventorySale', @DIRunDate, @minDateSalesStaging, @maxDateSalesStaging, @minDateSalesProfitectDB)
	end

	if @minDateInventoryLevelStaging is not null
	begin
	insert into ProfitectDB.dbo.DailyTableRangeDate  (TableName, DiDate, StartDate, EndDate, MinDate )
	values ('v_Olap_FactInventoryLevel', @DIRunDate, @minDateInventoryLevelStaging, @maxDateInventoryLevelStaging, @minDateInventoryLevelProfitectDB)
	end

	update ProfitectDB.dbo.DailyTableRangeDate 
	set StartDate = @incrementalLimitInvDocs
	where TableName = 'v_Olap_InvFactMain' and StartDate < @incrementalLimitInvDocs

	update ProfitectDB.dbo.DailyTableRangeDate 
	set MinDate = @minDateLinesProfitectDB
	where TableName = 'v_Olap_InvFactMain' and MinDate < @minDateLinesProfitectDB

	update ProfitectDB.dbo.DailyTableRangeDate 
	set EndDate = @maxDateLinesProfitectDB
	where TableName = 'v_Olap_InvFactMain' and EndDate > @maxDateLinesProfitectDB

	update ProfitectDB.dbo.DailyTableRangeDate 
	set StartDate = @incrementalLimitSaleLevel
	where TableName = 'v_Olap_InvDailyInventorySale' and StartDate < @incrementalLimitSaleLevel

	update ProfitectDB.dbo.DailyTableRangeDate 
	set MinDate = @minDateSalesProfitectDB
	where TableName = 'v_Olap_InvDailyInventorySale' and MinDate < @minDateSalesProfitectDB

	update ProfitectDB.dbo.DailyTableRangeDate 
	set EndDate = @maxDateSalesProfitectDB
	where TableName = 'v_Olap_InvDailyInventorySale' and EndDate > @maxDateSalesProfitectDB

	update ProfitectDB.dbo.DailyTableRangeDate 
	set StartDate = @incrementalLimitInvLevel
	where TableName = 'v_Olap_FactInventoryLevel' and StartDate < @incrementalLimitInvLevel

	update ProfitectDB.dbo.DailyTableRangeDate 
	set MinDate = @minDateInventoryLevelProfitectDB
	where TableName = 'v_Olap_FactInventoryLevel' and MinDate < @minDateInventoryLevelProfitectDB
	
	update ProfitectDB.dbo.DailyTableRangeDate 
	set EndDate = @maxDateInventoryLevelProfitectDB
	where TableName = 'v_Olap_FactInventoryLevel' and EndDate > @maxDateInventoryLevelProfitectDB
	
	/*	Debug
	select * from ProfitectDB.dbo.DailyTableRangeDate
	order by DiDate desc

	delete from ProfitectDB.dbo.DailyTableRangeDate
	where CubeProcessDate is null
	*/
END

/* End GateKeeper for Incremental Cube Processing		*/
