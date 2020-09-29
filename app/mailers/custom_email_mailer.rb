class CustomEmailMailer < ApplicationMailer
  def custom(custom_email_id, emails, group_ids = [])
    @custom_email = Email.find custom_email_id
    return unless @custom_email.custom?

    set_defaults(@custom_email.enterprise, 'custom')

    emails = members_from_groups(group_ids)

    # TODO check emails are unique
    mail(from: @from_address, to: emails, subject: @custom_email.subject)
  end

  def members_from_groups(group_ids)
    enterprise = Email.find_by_id(custom_email_id)&.enterprise
    groups = enterprise&.groups&.where(id: group_ids)
    return [] if groups.empty?


    members_emails = []
    groups.each do |g|
      members_emails << g.members.active.map(&:email)
    end

    members_emails
  end

  def variables
    {
      enterprise: @custom_email.enterprise
    }
  end
end
