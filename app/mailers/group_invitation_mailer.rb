class GroupInvitationMailer < ApplicationMailer
  def invitation(group_id, user_id)
    @group = Group.find_by(id: group_id)
    @user = User.find_by(id: user_id)
    @enterprise = @group.enterprise
    return if @enterprise.disable_emails?

    @custom_text = @enterprise.custom_text rescue CustomText.new
    @email = @user.email_for_notification

    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
  end

  def variables
    {
        user: @user,
        group: @group,
        enterprise: @enterprise,
        custom_text: @custom_text,
        click_here: "<a saml_for_enterprise=\"#{@enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>"
    }
  end

  def url
    group_url(@group)
  end
end
