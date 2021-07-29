CREATE procedure [dbo].[sp_nextgen_etl_run_cmd]
	 @cmd varchar(8000) --= 'dir'
	,@result int = null output
as
begin
	set nocount on

	declare @r int
	declare @output table (result nvarchar(max))
	declare @out_text nvarchar(max)

	declare @procid int = @@procid
	declare @object_name sysname = (select object_name(@procid))
	
	insert @output
	exec @r = master..xp_cmdshell @cmd

	set @out_text = (
		select 
			result as [info/text()] 
		from @output for xml path('')
	)

	exec dbo.[sp_nextgen_etl_log]
		 @object_id = @procid
		,@object_name = @object_name
		,@cmd = @cmd
		,@is_error = @r
		,@msg = @out_text

	set @result = @r
    
	if( @r = 1)
	BEGIN
	
	DECLARE @error_msg nvarchar(1000) 
	SET @error_msg = CONCAT('There was an error in process ID ',@procid)

	RAISERROR(@error_msg , --Message
            16, --Severity
            1);
	END
end
