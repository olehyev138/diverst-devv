class GroupLeaderMemberNotificationMailer < ApplicationMailer
  def notification(group, leader, count)
    @group = group
    @leader = leader
    @count = count
    @enterprise = leader.enterprise
    return if @enterprise.disable_emails?

    @email = @leader.email_for_notification
    @custom_text = @enterprise.custom_text rescue CustomText.new

    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
  end

  def variables
    {
      user: @leader,
      count: @count,
      group: @group,
      enterprise: @enterprise,
      custom_text: @custom_text,
      click_here: "<a saml_for_enterprise=\"#{@enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>"
    }
  end

  def url
    pending_group_group_members_url(@group)
  end
end
