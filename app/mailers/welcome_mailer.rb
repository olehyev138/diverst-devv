class WelcomeMailer < ApplicationMailer
  def notification(group_id, user_id)
    @group, @user = Group.find_by(id: group_id), User.find_by(id: user_id)

    return if @group.nil? || @user.nil?

    @enterprise = @user.enterprise

    return if @user.enterprise.disable_emails?

    @custom_text = @enterprise.custom_text rescue CustomText.new
    @email = @user.email_for_notification

    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
  end

  def variables
    {
      user: @user,
      enterprise: @enterprise,
      group: @group,
      custom_text: @custom_text,
      click_here: "<a saml_for_enterprise=\"#{@enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>"
    }
  end

  def url
    group_url(@group)
  end
end
