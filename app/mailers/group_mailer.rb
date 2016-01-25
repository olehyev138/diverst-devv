class GroupMailer < ApplicationMailer
  def group_message(message)
    @subject = message.subject
    @content = message.content
    mail(to: message.employees.first.email, bcc: message.employees.pluck(:email), subject: @subject)
  end

  # Invite the specified segments to join a group.
  def invitation(group, invitation_segments)
    template = html_template(group.enterprise, 'group_invitation')
    @content = template.render({
      'group' => {
        'image' => view_context.image_tag(group.logo.url(:thumb)),
        'name' => group.name,
        'description' => group.description
      },
      'accept_link' => join_employee_group_url(group)
    }).html_safe

    mail(to: group.members[0].email, bcc: group.members[1..-1].map(&:email), subject: "You've been invited to join a new ERG")
  end
end
