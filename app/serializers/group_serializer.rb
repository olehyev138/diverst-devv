class GroupSerializer < ApplicationRecordSerializer
  attributes :id, :permissions, :current_user_is_member

  attributes_with_permission :name, :short_description, :private, :logo, :logo_file_name, :logo_data, :logo_content_type, if: :family?

  attributes_with_permission :name, :short_description, :description, :pending_users, :members_visibility, :messages_visibility,
                             :active, :parent_id, :latest_news_visibility, :upcoming_events_visibility, :active,
                             :private, :home_message, :default_mentor_group, :position,
                             :enterprise_id, :event_attendance_visibility, :get_calendar_color, :auto_archive,
                             :unit_of_expiry_age, :expiry_age_for_resources, :expiry_age_for_news, :expiry_age_for_events,
                             :logo, :logo_file_name, :logo_data, :logo_content_type, :children, if: :show?

  attributes_with_permission :name, :short_description, :description, :parent_id, :enterprise_id, :currency, :children,
                             :annual_budget, :annual_budget_leftover, :annual_budget_approved, :annual_budget_available, if: :budgets?

  attributes_with_permission :group_category, :group_category_type, :news_feed,
                             :banner, :banner_file_name, :banner_data, :banner_content_type, if: :not_budgets?

  attributes_with_permission :parent, if: :with_parent?
  attributes_with_permission :children, if: :with_children?

  def with_children?
    (instance_options[:with_children?] || show_action?)  && show? && !family?
  end

  def with_parent?
    (instance_options[:with_parent?] || show_action?)  && show? && !family?
  end

  def budgets?
    instance_options[:budgets]
  end

  def not_budgets?
    !budgets? && show_action?
  end

  def family?
    instance_options[:family]
  end

  def public?
    !object[:private]
  end

  def show?
    policy&.show? && !family? && !budgets?
  end

  # **instance_options

  def currency
    object.annual_budget_currency
  end

  def children
    if budgets?
      if with_children?
        object.children.map { |child| GroupSerializer.new(child, **instance_options, with_children: false, with_parent: false).as_json }
      end
    elsif show_action?
      object.children.map { |child| GroupSerializer.new(child, **instance_options, family: true).as_json }
    else
      []
    end
  end

  def parent
    object.parent.present? ? GroupSerializer.new(object.parent, scope: scope, family: true) : nil
  end

  def policies
    if budgets?
      [
          :annual_budgets_manage?,
          :carryover_annual_budget?,
          :reset_annual_budget?,
      ]
    elsif show_action?
      [
          :show?,
          :destroy?,
          :update?,
          :events_view?,
          :members_view?,
          :news_view?,
          :resources_view?,
          :annual_budgets_view?,
          :budgets_view?,
          :leaders_view?,
          :events_create?,
          :members_create?,
          :message_create?,
          :news_link_create?,
          :social_link_create?,
          :news_create?,
          :resources_create?,
          :budgets_create?,
          :leaders_create?,
          :events_manage?,
          :resources_manage?,
          :kpi_manage?,
          :leaders_manage?,
          :news_manage?,
          :annual_budgets_manage?,
          :carryover_annual_budget?,
          :reset_annual_budget?,
          :members_destroy?,
          :join?,
          :leave?,
          :is_a_member?,
          :is_a_pending_member?,
          :is_an_accepted_member?,
          :is_a_leader?,
      ]
    else
      [
          :show?,
          :destroy?,
          :update?,
          :join?,
          :leave?,
          :is_a_member?,
          :is_a_pending_member?,
          :is_an_accepted_member?,
          :is_a_leader?,
      ]
    end
  end

  def logo_location
    object.logo_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def banner
    AttachmentHelper.attachment_signed_id(object.banner)
  end

  def banner_file_name
    AttachmentHelper.attachment_file_name(object.banner)
  end

  def banner_data
    AttachmentHelper.attachment_data_string(object.banner)
  end

  def banner_content_type
    AttachmentHelper.attachment_content_type(object.banner)
  end

  def logo
    AttachmentHelper.attachment_signed_id(object.logo)
  end

  def logo_file_name
    AttachmentHelper.attachment_file_name(object.logo)
  end

  def logo_data
    AttachmentHelper.attachment_data_string(object.logo)
  end

  def logo_content_type
    AttachmentHelper.attachment_content_type(object.logo)
  end

  def current_user_is_member
    scope&.dig(:current_user)&.is_member_of?(object)
  end
end
