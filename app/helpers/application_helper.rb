module ApplicationHelper
  class MissingKeyError < StandardError
  end

  def linkedin_logo_for_connected_users(user)
    inline_svg('icons/linkedin', size: '17px*17px') if user.linkedin_profile_url.present?
  end

  def back_to_diverst_path
    groups_path # TODO
  end

  def logo_url(enterprise = nil)
    enterprise_logo_or_default('diverst-logo.svg', enterprise)
  end

  def small_logo_url(enterprise = nil)
    enterprise_logo_or_default('diverst-logo-mark.svg', enterprise)
  end

  def login_logo(enterprise = nil)
    enterprise_logo_or_default('diverst-logo-purple.svg', enterprise)
  end

  def logo_destination
    return user_root_path if current_user.blank?

    if current_user.enterprise.theme.present? && current_user.enterprise.theme.logo_redirect_url.present?
      current_user.enterprise.theme.logo_redirect_url
    else
      user_root_path
    end
  end

  def event_color(event)
    calendar_color = event.try(:group).try(:calendar_color).blank? ? nil : '#' + event.try(:group).try(:calendar_color)

    result_color = calendar_color || enterprise_primary_color || '#7b77c9'

    to_color result_color
  end

  def to_color(color)
    trimmed_color = color.tr('#', '')

    if trimmed_color.to_i(16).to_s(16) == trimmed_color.downcase # if string is a valid hex number
      '#' + trimmed_color
    else
      trimmed_color
    end
  end

  def enterprise_primary_color(enterprise = nil)
    enterprise ||= default_enterprise_for_styling

    if enterprise.present? && enterprise.theme.present?
      return enterprise.theme.primary_color
    end

    nil
  end

  def last_sign_in_text(user)
    return 'Never' if user.last_sign_in_at.nil?

    "#{time_ago_in_words(user.last_sign_in_at)} ago"
  end

  def root_admin_path
    return metrics_overview_index_path if MetricsDashboardPolicy.new(current_user, MetricsDashboard).index?
    return manage_erg_root_path if manage_erg_root_path
    return manage_erg_budgets_path if manage_erg_budgets_path
    return campaigns_path if CampaignPolicy.new(current_user, Campaign).create?
    return polls_path if PollPolicy.new(current_user, Poll).create?
    return mentoring_interests_path if MentoringInterestPolicy.new(current_user, MentoringInterest).index?

    global_settings_path
  end

  def manage_erg_budgets_path
    return close_budgets_groups_path if GroupPolicy.new(current_user, Group).manage_all_group_budgets?

    false
  end

  def manage_erg_root_path
    return groups_path if GroupPolicy.new(current_user, Group).create?
    return segments_path if SegmentPolicy.new(current_user, Segment).index?
    return calendar_groups_path if GroupPolicy.new(current_user, Group).calendar?
    return enterprise_folders_path(current_user.enterprise) if EnterpriseFolderPolicy.new(current_user).index?

    false
  end

  def global_settings_path
    return users_path if UserPolicy.new(current_user, User).create?
    return edit_auth_enterprise_path(current_user.enterprise) if EnterprisePolicy.new(current_user, Enterprise).sso_manage?
    return policy_group_templates_path if EnterprisePolicy.new(current_user, Enterprise).manage_permissions?
    return edit_fields_enterprise_path(current_user.enterprise) if EnterprisePolicy.new(current_user, current_user.enterprise).edit_fields?
    return edit_branding_enterprise_path(current_user.enterprise) if EnterprisePolicy.new(current_user, current_user.enterprise).manage_branding?
    return edit_custom_text_path(current_user.enterprise) if EnterprisePolicy.new(current_user, current_user.enterprise).manage_branding?
    return emails_path(current_user.enterprise) if EnterprisePolicy.new(current_user, current_user.enterprise).manage_branding?
    return integrations_path if EnterprisePolicy.new(current_user, Enterprise).sso_manage?
    return rewards_path if EnterprisePolicy.new(current_user, Enterprise).diversity_manage?
    return logs_path if LogPolicy.new(current_user, nil).index?
    return edit_posts_enterprise_path(current_user.enterprise) if GroupPolicy.new(current_user, Group).manage_all_groups? && EnterprisePolicy.new(current_user, Enterprise).manage_posts?

    false
  end

  def group_initiative_expenses_link(text, group, initiative)
    link_to text, group_initiative_expenses_path(group, initiative)
  end

  def percentage_expenditure(total_expenses, budget)
    expenses_percent = (total_expenses / budget) * 100
    return 0 if total_expenses == 0.0
    return 100 if expenses_percent.nan? || expenses_percent.infinite?

    expenses_percent
  end

  def negative_budget_pressure(options)
    initiative = options[:initiative]
    annual_budget = options[:annual_budget]

    return initiative.expenses.sum(:amount) > initiative.estimated_funding if options[:initiative]
    return annual_budget.expenses > annual_budget.amount if options[:annual_budget]
  end

  def default_path
    return root_admin_path if root_admin_path

    user_root_path
  end

  def default_enterprise_asset_url
    enterprise = default_enterprise_for_styling

    if enterprise.nil? || enterprise.theme.nil?
      'application'
    else
      enterprise.theme.asset_url
    end
  end

  def c_t(type)
    @custom_text ||= current_user.enterprise.custom_text rescue CustomText.new

    @custom_text.send("#{ type }_text")
  end

  def show_sponsor?(object)
    m = 'sponsor_name'
    if object.respond_to? m.to_sym
      object.public_send(m.to_sym).present?
    end
  end

  def show_sponsor_media?(object, m)
    if %r{\Aimage\/.*\Z}.match?(object.public_send(m.to_sym))
      yield
    end
  end

  def show_sponsor_video?(object, m)
    if %r{\Avideo\/.*\Z}.match?(object.public_send(m.to_sym))
      yield
    end
  end

  # for RSpec test of protected method in segment_controller.rb
  def segment_members_of_group(segment, group)
    segment.members.includes(:groups).select do |user|
      UserGroup.where(user_id: user.id, group_id: group.id).exists?
    end
  end

  def resource_policy(resource)
    return EnterpriseResourcePolicy.new(current_user, resource) if resource.container.is_a?(Enterprise)
    return GroupResourcePolicy.new(current_user, [resource]) if resource.container.is_a?(Folder)
  end

  private

  def default_enterprise_for_styling
    if current_user
      return current_user.enterprise
    end

    if ENV.key?('DEFAULT_STYLING_ENTERPRISE_ID')
      Enterprise.find_by_id ENV['DEFAULT_STYLING_ENTERPRISE_ID']
    else
      nil
    end
  end

  def enterprise_logo_or_default(default_logo_name, enterprise = nil)
    enterprise = enterprise || default_enterprise_for_styling

    if enterprise && enterprise.theme.present? && enterprise.theme.logo.present?
      enterprise.theme.logo.expiring_url(3601)
    else
      image_path(default_logo_name)
    end
  end

  def is_post_liked?(news_feed_link_id)
    Like.find_by(user: current_user, enterprise: current_user.enterprise, news_feed_link: news_feed_link_id).present?
  end

  def is_answer_liked?(answer_id)
    Like.find_by(user: current_user, enterprise: current_user.enterprise, answer: answer_id).present?
  end

  def boolean_to_yes_no(boolean_value)
    boolean_value ? 'Yes' : 'No'
  end
end
