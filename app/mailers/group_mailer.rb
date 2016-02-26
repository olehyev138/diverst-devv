class GroupMailer < ApplicationMailer
  GROUP_MESSAGE_SLUG = 'group_message'
  INVITATION_SLUG = 'group_invitation'

  def group_message(message)
    template = html_template(group.enterprise, GROUP_MESSAGE_SLUG)

    template_locals = {
      'group' => {
        'image' => view_context.image_tag(group.logo.url(:thumb)),
        'name' => group.name,
        'description' => group.description
      },
      'message': {
        subject: message.subject,
        content: message.content
      },
      'accept_link' => join_user_group_url(group)
    }

    @content = template.render(template_locals).html_safe
    subject = subject_template(GROUP_MESSAGE_SLUG).render(template_locals).html_safe

    mail(to: group.members[0].email, bcc: group.members[1..-1].map(&:email), subject: subject)
  end

  # Invite the specified segments to join a group.
  def invitation(group, _invitation_segments)
    template = html_template(group.enterprise, INVITATION_SLUG)

    template_locals = {
      'group' => {
        'image' => view_context.image_tag(group.logo.url(:thumb)),
        'name' => group.name,
        'description' => group.description
      },
      'accept_link' => join_user_group_url(group)
    }

    @content = template.render(template_locals).html_safe
    subject = subject_template(INVITATION_SLUG).render(template_locals).html_safe

    mail(to: group.members[0].email, bcc: group.members[1..-1].map(&:email), subject: subject)
  end
end
