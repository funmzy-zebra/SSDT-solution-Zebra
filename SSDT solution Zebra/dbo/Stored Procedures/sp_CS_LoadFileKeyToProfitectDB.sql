
-- =============================================
-- Author:		Polina Malahov	
-- Create date: 2013-08-02
-- Description:	Fill FileKeys
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_LoadFileKeyToProfitectDB]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	Declare @BatchDate nvarchar(20)
	set @BatchDate = Convert(nvarchar(20), GETDATE(), 120)
	INSERT INTO ProfitectDB.[dbo].[FileKey]
	         ([FileKeyName]
	         ,[Destination]
	         ,[BatchDate])
    select distinct  CUST.FileKeyName, CUST.Destination, @BatchDate FROM
	FileKey as CUST

	END
    
