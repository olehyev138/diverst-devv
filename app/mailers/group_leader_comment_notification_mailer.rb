class GroupLeaderCommentNotificationMailer < ApplicationMailer
  def notification(group, leader, count)
    @group = group
    @leader = leader
    @count = count
    return if @leader.enterprise.disable_emails?

    @email = @leader.email_for_notification

    set_defaults(@leader.enterprise, method_name)

    mail(from: @from_address, to: @email, subject: "#{count} Pending Comment(s) for #{group.name.titleize}")
  end
end
