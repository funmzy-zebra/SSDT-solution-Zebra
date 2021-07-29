
CREATE PROCEDURE [dbo].[sp_POS_CS_CalculateKey_DocumentLine]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SP_DI_CS_ReturnMaxValueIDFromStaging

	declare @StartInsertID bigint;
	declare @Process1Count bigint--, @Process2Count bigint, @Process3Count bigint, @Process4Count bigint, @Process5Count bigint

	print 'Pos_DocLine_1_Cnt'

	DECLARE @sqlCommand nvarchar(1000)
	DECLARE @prf_db nvarchar(100), @paramdef varchar(100)
	SELECT @prf_db= [NvarcharValue] FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where ConfigKey = 'ProfitectDB'
    SET @sqlCommand = 'SELECT @StartInsertID_Out= max(POSDocumentLineID) FROM '+@prf_db+'.[dbo].POSDocumentLine'

	EXECUTE sp_executesql @sqlCommand, N'@StartInsertID_Out bigint OUTPUT' , @StartInsertID_Out = @StartInsertID OUTPUT 

	set @StartInsertID = @StartInsertID +1;

	Update [NextGenETL].[dbo].[ETLConfig_PiplineRun]
	SET  [INTValue] = @StartInsertID
	    ,[UpdateDate] = GETDATE()
	where [ConfigKey] = 'Pos_DocLine_1_Cnt'

	print 'PosDocumentHeaderID'

	
	 SET @sqlCommand = 'SELECT @StartInsertID_Out= max(POSDocumentHeaderID) FROM '+@prf_db+'.[dbo].POSDocumentLine'

	 EXECUTE sp_executesql @sqlCommand, N'@StartInsertID_Out bigint OUTPUT' , @StartInsertID_Out = @StartInsertID OUTPUT 
	 set @StartInsertID = @StartInsertID +1

	 update c set [INTValue] = @StartInsertID
                 ,[UpdateDate] = getdate()
     FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] c where ConfigKey = 'PosDocumentHeaderID'


	  SET @sqlCommand = 'SELECT @StartInsertID_Out= max(POSDocumentPromotionalDiscountID) FROM '+@prf_db+'.[dbo].POSDocumentPromotionalDiscount '

	 EXECUTE sp_executesql @sqlCommand, N'@StartInsertID_Out bigint OUTPUT' , @StartInsertID_Out = @StartInsertID OUTPUT 
	 set @StartInsertID = @StartInsertID +1

	Update [NextGenETL].[dbo].[ETLConfig_PiplineRun]
	SET [INTValue] = @StartInsertID
	   ,[UpdateDate] = getdate()
	where [ConfigKey] = 'Pos_DocPromo_1_Cnt'



END
