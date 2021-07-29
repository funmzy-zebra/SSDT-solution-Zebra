
create procedure [dbo].[sp_INV_CS_LoadUnknownDocTypes] 
AS
begin
declare @maxID int
set @maxID = (select MAX([DocumentTypeID]) from [ProfitectDB].dbo.[InventoryDocumentType] )

SELECT distinct  case when charindex('_',[DocumentTypeCode],0)<>0 
					  then replace(left([DocumentTypeCode],charindex('_',[DocumentTypeCode],0)),'_','') 
					  else [DocumentTypeCode] END as ParentDoc
			    ,Right([DocumentTypeCode],Len([DocumentTypeCode])-charindex('_',[DocumentTypeCode],0)) as ChildDoc
				,[DocumentTypeCode] as ChildDocCod
  into #AllDocsTypes  
  FROM Master_InventoryDocumentType


INSERT [ProfitectDB].dbo.[InventoryDocumentType] 
(
	[DocumentTypeID], 
	[DocumentTypeCode], 
	[DocumentTypeDescription], 
	[ProfitectCode], 
	[ParentDocumentTypeID], 
	[Level], 
	[ReverseSign]
) 
Select 
ROW_NUMBER() OVER(ORDER BY CUST.[DocumentTypeCode] DESC) + @maxID , 
CUST.[DocumentTypeCode],
CUST.DocumentTypeDescription,
CUST.ProfitectCode,
ROW_NUMBER() OVER(ORDER BY CUST.[DocumentTypeCode] DESC) + @maxID , 
CUST.Level,
0 as [ReverseSign]
From (
	Select distinct
	ParentDoc as [DocumentTypeCode],  
	ParentDoc as [DocumentTypeDescription],
	203 as [ProfitectCode],
	NULL as [ParentDocumentTypeID],
	NULL as [Level],
	0 as [ReverseSign]
	from #AllDocsTypes
    ) CUST left outer join [ProfitectDB].dbo.[InventoryDocumentType] idt on CUST.DocumentTypeCode = idt.DocumentTypeCode
Where idt.DocumentTypeID is null


--declare @maxID int
set @maxID = (select MAX([DocumentTypeID]) from [ProfitectDB].dbo.[InventoryDocumentType] )

INSERT [ProfitectDB].dbo.[InventoryDocumentType] 
(
	[DocumentTypeID], 
	[DocumentTypeCode], 
	[DocumentTypeDescription], 
	[ProfitectCode], 
	[ParentDocumentTypeID], 
	[Level], 
	[ReverseSign]
) 
Select 
ROW_NUMBER() OVER(ORDER BY CUST.[DocumentTypeCode] DESC) + @maxID 
, CUST.*
FROM(
select  dc.ChildDocCod as [DocumentTypeCode], 
	    dc.ChildDoc as [DocumentTypeDescription] , 
		tp.ProfitectCode as [ProfitectCode],
		tp.DocumentTypeID as ParentID,
		NULL as [Level],
	    0 as [ReverseSign]

from #AllDocsTypes dc inner join [ProfitectDB].[dbo].[InventoryDocumentType] tp on dc.ParentDoc = tp.DocumentTypeCode

) CUST 

left outer join [ProfitectDB].dbo.[InventoryDocumentType] idt on CUST.DocumentTypeCode = idt.DocumentTypeCode
Where idt.DocumentTypeID is null


--update idt set DocumentTypeDescription = RTRIM(tt.[Column 3]) +' ('+[Column 1]+')'
--
--from [Master_CS_dim_cao_adj_rsn] tt inner join [ProfitectDB].dbo.[InventoryDocumentType] idt on  'ADJ_'+[Column 1] = idt.DocumentTypeCode
--
drop table #AllDocsTypes






END
