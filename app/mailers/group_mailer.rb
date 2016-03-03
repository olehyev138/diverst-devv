class GroupMailer < ApplicationMailer
  # Slugs are used to refer to identify email types to their rows in the `emails` table in the DB
  GROUP_MESSAGE_SLUG = 'group_message'
  INVITATION_SLUG = 'group_invitation'

  def group_message(message)
    template = html_template(message.group.enterprise, GROUP_MESSAGE_SLUG)

    template_locals = global_template_vars(group: message.group).merge({
      'message': {
        subject: message.subject,
        content: message.content
      }
    })

    @content = template.render(template_locals).html_safe
    subject = subject_template(message.group.enterprise, GROUP_MESSAGE_SLUG).render(template_locals).html_safe

    mail(to: message.group.members[0].email, bcc: message.group.members[1..-1].map(&:email), subject: subject)
  end

  # Invite the specified segments to join a group.
  def invitation(group, invitation_segments)
    template_locals = global_template_vars(group: group).merge({
      'group' => {
        'image' => view_context.image_tag(group.logo.expiring_url(:thumb, 10)),
        'name' => group.name,
        'description' => group.description
      },
      'accept_link' => join_user_group_url(group)
    })

    content_template = html_template(group.enterprise, INVITATION_SLUG)
    subject_template = subject_template(group.enterprise, INVITATION_SLUG)

    @content = content_template.render(template_locals).html_safe
    subject = subject_template.render(template_locals).html_safe

    recipients = invitation_segments.flat_map{ |s| s.members.pluck(:email) }

    mail(to: recipients[0], bcc: recipients[1..-1], subject: subject)
  end

  private

  def global_template_vars(group:)
    {
      'group' => {
        'image' => view_context.image_tag(group.logo.expiring_url(:thumb, 10)),
        'name' => group.name,
        'description' => group.description
      }
    }
  end
end
