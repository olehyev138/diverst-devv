class EmailVariablesService
  MAIL_TO_KEY = {
    'user_group_mailer' => [
      'user.name',
      'enterprise.id',
      'enterprise.name',
      'custom_text.erg_text',
    ],
    'budget_mailer' => [
      'user.name',
      'group.name',
      'enterprise.id',
      'enterprise.name',
      'custom_text.erg_text',
      'click_here',
    ],
    'campaign_mailer' => [
      'user.name',
      'enterprise.id',
      'enterprise.name',
      'group_names',
      'campaign.title',
    ],
    'group_leader_post_notification_mailer' => [
    ],
    'poll_mailer' => [
      'user.name',
      'survey.title',
      'enterprise.id',
      'enterprise.name',
      'custom_text.erg_text',
      'click_here',
    ],
    'group_leader_member_notification_mailer' => [
      'user.name',
      'count',
      'group.name',
      'enterprise.id',
      'enterprise.name',
      'custom_text.erg_text',
      'click_here',
    ],
    'welcome_mailer' => [
      'user.name',
      'group.name',
      'enterprise.id',
      'enterprise.name',
      'custom_text.erg_text',
      'click_here',
    ],
    'diverst_mailer' => [
      'user.name',
      'enterprise.id',
      'enterprise.name',
      'custom_text.erg_text',
      'click_here',
    ],
    'reset_password_mailer' => [
      'user.name',
      'enterprise.id',
      'enterprise.name',
      'custom_text.erg_text',
      'click_here',
    ],
  }

  def self.update_email_variables
    EmailVariable.destroy_all
    Enterprise.find_each do |enterprise|
      enterprise.emails.find_each do |email|
        enterprise.email_variables.where(key: MAIL_TO_KEY[email.mailer_name]).find_each do |variable|
          EmailVariable.create(email: email, enterprise_email_variable: variable)
        end
      end
    end
  end
end
