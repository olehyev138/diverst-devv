class GroupLeaderPostNotificationMailer < ApplicationMailer
  def notification(group, leader, count)
    @group = group
    @user = leader
    @count = count
    @enterprise = leader.enterprise
    return if @enterprise.disable_emails?

    @custom_text = @enterprise.custom_text rescue CustomText.new
    @email = @user.email_for_notification

    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
  end

  def variables
    {
      user: @user,
      count: @count,
      group: @group,
      enterprise: @enterprise,
      custom_text: @custom_text,
      click_here: "<a saml_for_enterprise=\"#{@enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>"
    }
  end

  def url
    group_posts_url(@group)
  end
end
