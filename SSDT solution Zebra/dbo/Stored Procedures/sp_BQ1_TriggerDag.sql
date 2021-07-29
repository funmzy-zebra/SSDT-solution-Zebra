/****** Script for SelectTopNRows command from SSMS  ******/

CREATE PROCEDURE [dbo].[sp_BQ1_TriggerDag]
     @ReturnResult int = 0 OUTPUT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   SET @ReturnResult = 0;
    -- Insert statements for procedure here
   BEGIN TRY
		update v set [NvarcharValue] = 'POS_BQ1toBQ2-Processing_prod'
		FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] v
		where ConfigKey = 'DagName'


		--DECLARE	@return_value int
		EXEC [dbo].[sp_CS_TriggerDag]

		--EXEC	@return_value = [dbo].[sp_CS_TriggerDag]
		--		@ReturnResult = @ReturnResult OUTPUT

	END TRY
	BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000);
	SELECT @ErrorMessage = ERROR_MESSAGE();
	RAISERROR (@ErrorMessage, 16, 1);
	END CATCH

END
