class CustomEmailMailer < ApplicationMailer
  def custom(custom_email_id, emails, current_user_id, group_ids = [])
    @custom_email = Email.find custom_email_id
    return unless @custom_email.custom?

    current_user = User.find_by_id current_user_id
    @enterprise = current_user.enterprise

    set_defaults(@enterprise, 'custom')

    emails = members_from_groups(custom_email_id, group_ids, @enterprise)

    if !group_ids.empty?
      emails = members_from_groups(custom_email_id, group_ids, @enterprise)
    end

    @mailer_text = @custom_email.process_content(@custom_email.variables)

    # TODO check emails are unique
    mail(from: @from_address, to: current_user.email, bcc: emails, subject: @custom_email.subject)
  end

  def members_from_groups(custom_email_id, group_ids, enterprise)
    groups = enterprise&.groups&.where(id: group_ids)
    return [] if groups.empty?


    members_emails = []
    groups.each do |g|
      members_emails << g.members.active.map(&:email)
    end

    members_emails.uniq
  end

  def variables
    {
      enterprise: @enterprise
    }
  end
end
