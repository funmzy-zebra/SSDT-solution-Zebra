
create procedure [dbo].[sp_nextgen_etl_log]
	 @object_id int
	,@object_name sysname
	,@cmd varchar(8000)
	,@is_error bit
	,@msg nvarchar(max)
as
begin
	set nocount on

	insert into dbo.[nextgen_etl_log] (
		 dt
		,spid
		,user_login
		,host
		,proc_id 
		,proc_name
		,cmd
		,is_error
		,msg )
	select
		 getdate()
		,@@spid
		,original_login()
		,host_name()
		,@object_id
		,@object_name
		,@cmd
		,@is_error
		,@msg
end	


