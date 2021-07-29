

CREATE PROCEDURE [dbo].[P_BulkInsert]
	-- Add the parameters for the stored procedure here
	@filename nvarchar(250), 
	@tablename nvarchar(250),
	@delimiter nvarchar(10),
	@firstRow int,
	@codepage int,
	@dataFileType varchar(50),
	@RowPerBatch int=100000,
	@ReturnResult int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET @ReturnResult = 0
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRANSACTION

		EXEC(N'BULK INSERT [dbo].' + @tablename + ' FROM ''' + @filename + ''' WITH (ROWS_PER_BATCH = '+ @RowPerBatch +', CODEPAGE =''' + @codepage + ''', DATAFILETYPE = ''' + @dataFileType + ''', FIELDTERMINATOR = ''' + @delimiter + ''', FIRSTROW=' + @firstRow + ', ROWTERMINATOR = ''\n'')') 
		IF @@ERROR <> 0
		BEGIN
			  SET @ReturnResult = -1
			  ROLLBACK TRANSACTION
		END
	COMMIT TRANSACTION
END

