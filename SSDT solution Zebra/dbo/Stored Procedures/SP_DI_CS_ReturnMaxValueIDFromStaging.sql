


CREATE PROC [dbo].[SP_DI_CS_ReturnMaxValueIDFromStaging]
@queryParam nvarchar(100),
@MaxID BIGINT = 0 output
AS
-- =============================================
-- Author:          Polina Malachov
--Date:                    06.03.201
-- Description: This sp get @TableNmae and return the max id FOR the given table
-- =============================================
BEGIN TRY
       
       DECLARE @CMD NVARCHAR(4000)

              SET @CMD='SELECT  @MAXID= convert(bigint, [INTValue]) FROM [NextGenETL].[dbo].[ETLConfig_PiplineRun] where [ConfigKey] =''' +@queryParam +''''
			--  print @cmd

              EXEC SP_EXECUTESQL @CMD,N'@MAXID BIGINT OUTPUT',@MaxID=@MaxID OUTPUT
 
              IF @MaxID is NULL
              SET @MaxID = 0
 
       --     RETURN @MAXID
END TRY
BEGIN CATCH

END CATCH
