module ApplicationHelper
  def current_user_has_no_comments?(comments)
    comment = comments.find_by(user_id: current_user.id)
    yield if comment.nil?
  end

  def current_user_has_pending_comments?(comments)
    comment = comments.find_by(user_id: current_user.id, approved: false)
    yield if comment && !current_user.erg_leader?
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
    return user_root_path unless current_user.present?

    if current_user.enterprise.theme.present? && current_user.enterprise.theme.logo_redirect_url.present?
      current_user.enterprise.theme.logo_redirect_url
    else
      user_root_path
    end
  end

  def event_color(event)
    calendar_color = event.try(:group).try(:calendar_color).blank? ? nil : "#" + event.try(:group).try(:calendar_color)

    result_color = calendar_color || enterprise_primary_color || '#7b77c9'

    to_color result_color
  end

  def to_color(color)
    trimmed_color = color.tr('#', '')

    if trimmed_color.to_i(16).to_s(16) == trimmed_color.downcase  #if string is a valid hex number
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
    return "Never" if user.last_sign_in_at.nil?
    return "#{time_ago_in_words(user.last_sign_in_at)} ago"
  end

  def root_admin_path
    return manage_erg_root_path if manage_erg_root_path
    return manage_erg_budgets_path if manage_erg_budgets_path
    return campaigns_path if policy(Campaign).index?
    return polls_path if policy(Poll).index?
    return global_settings_path
  end
  
  def manage_erg_budgets_path
    return plan_overview_groups_path if current_user.policy_group.groups_budgets_index?
    return group_initiatives_path(@group || GroupPolicy::Scope.new(current_user, Group, :initiatives_manage).resolve.first) if policy(Initiative).index?
    return metrics_group_path(@group || GroupPolicy::Scope.new(current_user, Group, :groups_manage).first) if current_user.policy_group.groups_manage?
    return close_budgets_groups_path if current_user.policy_group.annual_budget_manage?
    nil
  end

  def manage_erg_root_path
    return metrics_dashboards_path if policy(MetricsDashboard).index?
    return groups_path if policy(Group).index?
    return segments_path if policy(Segment).index?
    return calendar_groups_path if current_user.policy_group.global_calendar?
    return enterprise_folders_path(current_user.enterprise) if policy(Resource).index?
    nil
  end

  def global_settings_path
    return users_path if policy(User).index?
    return edit_auth_enterprise_path(current_user.enterprise) if current_user.policy_group.sso_manage?
    return policy_group_templates_path if current_user.policy_group.permissions_manage?
    return edit_fields_enterprise_path(current_user.enterprise) if policy(current_user.enterprise).edit_fields?
    return edit_custom_text_path(current_user.enterprise.custom_text) if policy(current_user.enterprise).edit_fields?
    return edit_branding_enterprise_path(current_user.enterprise) if policy(current_user.enterprise).edit_fields?
    return integrations_path if current_user.policy_group.sso_manage?
    return rewards_path if current_user.policy_group.diversity_manage?
    return logs_path if current_user.policy_group.logs_view?
    return edit_pending_comments_enterprise_path(current_user.enterprise) if current_user.policy_group.manage_posts?
    nil
  end

  def default_path
    return root_admin_path if root_admin_path
    return user_root_path
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
    ["sponsor_name"].each do |m|
      if object.respond_to? m.to_sym
        if object.public_send(m.to_sym).present?
          yield
        end
      end
    end
  end

  def show_sponsor_media?(object, m)
    if %r{\Aimage\/.*\Z}.match(object.public_send(m.to_sym))
      yield
    end
  end

  def show_sponsor_video?(object, m)
    if %r{\Avideo\/.*\Z}.match(object.public_send(m.to_sym))
      yield
    end
  end

  #for RSpec test of protected method in segment_controller.rb
  def segment_members_of_group(segment, group)
    segment.members.includes(:groups).select do |user|
      user.groups.include? group
    end
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
    Like.find_by(:user => current_user, :enterprise => current_user.enterprise, :news_feed_link => news_feed_link_id).present?
  end

  def is_answer_liked?(answer_id)
    Like.find_by(:user => current_user, :enterprise => current_user.enterprise, :answer => answer_id).present?
  end
end
