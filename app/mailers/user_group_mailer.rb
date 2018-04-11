class UserGroupMailer < ApplicationMailer
  def notification(user, groups)
    @user = user
    @groups = groups
    @custom_text = user.enterprise.custom_text rescue CustomText.new
    @mailer_text = user.enterprise.user_group_mailer_notification_text  % { user_name: @user.name }
    mail(to: @user.email, subject: "You have updates in your #{ @custom_text.erg_text.pluralize }")
  end
end
