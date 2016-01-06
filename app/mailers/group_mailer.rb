class GroupMailer < ApplicationMailer
  def group_message(message)
    @subject = message.subject
    @content = message.content
    mail(to: message.employees.first.email, bcc: message.employees.pluck(:email), subject: @subject)
  end

  # Invite the specified segments to join a group.
  def invitation(group, invitation_segments)
    template = Liquid::Template.parse(group.enterprise.emails.where(slug: 'diverst-invitation').first.custom_html_template)
    @content = template.render({
      'group' => {
        'image' => view_context.image_tag(group.logo.url(:thumb)),
        'name' => group.name,
        'description' => group.description
      },
      'accept_link' => view_context.join_group_path(group)
    })

    mail(to: 'frank.marineau@gmail.com', subject: "You've been invited to join a new ERG")
  end
end
