
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_EmailNotification] 
	-- Add the parameters for the stored procedure here
	 @MAIL_BODY VARCHAR(8000),
	 @msg_subject VARCHAR(1000)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @RecipientList varchar(500) = ''

       
    select @RecipientList = @RecipientList + Recipient +'; '
        from msdb.dbo.MonitorETL_EmailRecipients
	   where isEnabled = 1
	  

    -- Insert statements for procedure here
	EXEC msdb.dbo.sp_send_dbmail
		 @profile_name='Profitect',
		 @recipients = @RecipientList,
		 @subject = @msg_subject,
		 @body = @MAIL_BODY,
		 @body_format='HTML'

END
