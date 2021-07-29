
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PrepINVMasterTablesList]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select c.TABLE_NAME,c.COLUMN_NAME
into #t
From INFORMATION_SCHEMA.COLUMNS c
Where TABLE_NAME  like 'salelevelattribute%' or 
      TABLE_NAME  like 'Inventorylevelattribute%' or 
	  TABLE_NAME  like 'InventorydocumentHeaderattribute%' or
	  TABLE_NAME  like 'Inventorydocumentlineattribute%'

----SELECt * from #t

select TABLE_NAME ,
  max(case when COLUMN_NAME not like '%Value' and COLUMN_NAME not like '%OrdinalID'  then COLUMN_NAME end) AttributeID,
  max(case when COLUMN_NAME like '%Value' then COLUMN_NAME end) AttributeValue,
  max(case when COLUMN_NAME like '%OrdinalID' then COLUMN_NAME end) AttributeOrdinal
 Into #relevantFactAttributes 
from #t
group by TABLE_NAME

Select c.TABLE_NAME,c.COLUMN_NAME
into #Master
From INFORMATION_SCHEMA.COLUMNS c
Where TABLE_NAME  like 'Product' or 
      TABLE_NAME  like 'Resource' or 
	  TABLE_NAME  like 'Custom' or
	  TABLE_NAME  like 'Vendor'  or
	  TABLE_NAME  like 'InventoryDocumentLineReason'  or
	  TABLE_NAME  like 'InventoryDocumentType' or
	  TABLE_NAME  like 'Site' 
	  --TABLE_NAME  like 'FileKey'

	 delete FROM #Master where COLUMN_NAME like '%1%'
	 delete FROM #Master where COLUMN_NAME like '%ProfitectCode%'

Declare @dbName nvarchar(1000)= (SELECT DB_NAME() AS [Current Database]) --ProfitectDB Name

drop table if exists NextGenETL..Pipeline_INV_MasterTablesToExtract;
Select ROW_NUMBER() over(order by sql_query) as ID,  sql_query,TBL_FileName
Into NextGenETL..Pipeline_INV_MasterTablesToExtract
FROM(
SELECT concat( 'SELECT MAX(' , AttributeID,') as '+AttributeID+', REPLACE(IIF(LEN(' ,AttributeValue,')=0,'' '',',AttributeValue,'),''|'','' '') as ',AttributeValue,', 0 as ',AttributeOrdinal ,' ' ,' FROM ' , @dbName ,'.DBO.',TABLE_NAME,' group by ' ,AttributeValue) sql_query , TABLE_NAME TBL_FileName
FROM #relevantFactAttributes
union
Select concat( 'SELECT MAX(' , TABLE_NAME+'ID)',', ' ,COLUMN_NAME,' ' ,' FROM ' , @dbName ,'.DBO.',TABLE_NAME, ' GROUP BY ' , COLUMN_NAME) sql_query, TABLE_NAME TBL_FileName
from #Master where COLUMN_NAME Like '%Code' and COLUMN_NAME Not Like '%Display%'
union
Select concat( 'SELECT ' , 'MAX(FileKeyID) AS FileKeyID',', FileKeyName  FROM ' , @dbName ,'.DBO.FileKey GROUP BY FileKeyName') sql_query, 'FileKey' as TBL_FileName

)cust


--REPLACE(IIF(LEN(PSS.ProductSeasonDescription)=0,' ' ,PSS.ProductSeasonDescription),'~',' ')
----Prep for Terraform external tables if needed
SELECT Concat('"masterdata_dictionary.',[TBL_FileName],'"="',[TBL_FileName],'.csv"')
  FROM [NextGenETL].[dbo].Pipeline_INV_MasterTablesToExtract
  order by 1
--Delete tables if needed
SELECT Concat('bq rm -f -t kroger-nextgen-dev:masterdata_dictionary_dev.',[TBL_FileName])
  FROM [NextGenETL].[dbo].Pipeline_INV_MasterTablesToExtract
  order by 1


  drop table #Master
END
