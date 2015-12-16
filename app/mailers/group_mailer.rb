class GroupMailer < ApplicationMailer
  def group_message(message)
    @subject = message.subject
    @content = message.content
    mail(to: message.employees.first.email, bcc: message.employees.pluck(:email), subject: @subject)
  end

  # Invite the specified segments to join a group.
  def invitation(group, invitation_segments)
    employees_to_invite = self.enterprise.employees
    .joins(:employee_groups)
    .where.not(
      "employee_groups.id" => group.id
    )

    unless invitation_segments.empty?
      employees_to_invite = query
      .joins(:segments)
      .where(
        "segments.id" => invitation_segments.ids
      )
    end

    employees_to_invite

    mail(to: group.employees_to_invite.first.email, bcc: group.employees_to_invite[1..-1].pluck(:email), subject: "You've been invited to join a new BRG")
  end
end
