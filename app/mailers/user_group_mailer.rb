class UserGroupMailer < ApplicationMailer
  def notification(user, groups)
    @user = user
    @groups = groups
    @custom_text = user.enterprise.custom_text rescue CustomText.new
    @email = @user.email_for_notification
    return if @user.enterprise.disable_emails?

    set_defaults(user.enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
    @user.update last_group_notification_date: DateTime.now
  end

  def variables
    {
      user: @user,
      enterprise: @user.enterprise,
      custom_text: @custom_text
    }
  end
end
