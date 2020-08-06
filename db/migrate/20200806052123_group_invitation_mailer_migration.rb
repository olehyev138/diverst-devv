class GroupInvitationMailerMigration < ActiveRecord::Migration
  def change
    Enterprise.all.each do |enterprise|
      group_invitation_email = enterprise.emails.find_or_create_by(
        name: 'Group Invitation Mailer'
      )
      group_invitation_email.update(
        enterprise: enterprise,
        mailer_name: "group_invitation_mailer",
        mailer_method: "invitation",
        content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You have been invited to join <strong> %{group.name} </strong>.</p><p>%{click_here} to join %{group.name} %{custom_text.erg_text}</p></p>",
        subject: "Invitation to join %{group.name}",
        description: "Email that goes out to users to invite them to a group.",
        template: ""
      )

      enterprise.email_variables.where(key: ["user.name", "group.name", "enterprise.name", "click_here", "custom_text.erg_text"]).each do |email_variable|
        email_variable.emails << group_invitation_email
      end
    end
  end
end
