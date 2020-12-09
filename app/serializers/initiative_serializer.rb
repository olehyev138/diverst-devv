class InitiativeSerializer < ApplicationRecordSerializer
  attributes :pillar, :owner, :outcome, :participating_groups,
             :full?, :permissions, :picture, :picture_file_name, :picture_data,
             :is_attending, :group, :group_id

  attributes_with_permission :pillar, :outcome, :initiative_users,
                             :qr_code, :qr_code_file_name, :qr_code_data, :budget_users, if: :singular_action?

  attributes_with_permission :budget, :budgets, :budget_status, :expenses_status, :current_expenses_sum,
                             :leftover, if: :with_budget?

  attributes_with_permission :total_comments, :comments, if: :with_comments?

  attributes_with_permission :total_attendees, if: :view_attendees?

  def budget
    budgets.first
  end

  def with_budget?
    instance_options[:with_budget] && singular_action?
  end

  def with_comments?
    instance_options[:with_comments] && singular_action?
  end

  def view_attendees?
    policy.attendees? && singular_action?
  end

  def comments
    object.comments.map do |comment|
      InitiativeCommentSerializer.new(comment, **new_action_instance_options('index')).as_json
    end
  end

  def group
    {
        id: object.group.id,
        name: object.group.name,
        calendar_color: object.group.get_calendar_color,
        current_user_is_member: scope&.dig(:current_user)&.is_member_of?(object.group),
    }
  end

  def participating_groups
    object.participating_groups.map do |p_group|
      {
          id: p_group.id,
          name: p_group.name,
          calendar_color: p_group.get_calendar_color,
          current_user_is_member: scope&.dig(:current_user)&.is_member_of?(p_group),
      }
    end
  end

  def budget_users
    object.budget_users.map do |budget_user|
      BudgetUserSerializer.new(budget_user, event: object, **instance_options).as_json
    end
  end

  # def budget_item
  #   BudgetItemSerializer.new(object.budget_item, scope: scope, event: object).as_json if object.budget_item.present?
  # end

  def serialize_all_fields
    true
  end

  def policies
    super + [:join_event?, :attendees?]
  end

  # Picture

  def picture_location
    object.picture_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def picture
    AttachmentHelper.attachment_signed_id(object.picture)
  end

  def picture_file_name
    AttachmentHelper.attachment_file_name(object.picture)
  end

  def picture_data
    AttachmentHelper.attachment_data_string(object.picture)
  end

  # QR Code

  def qr_code
    AttachmentHelper.attachment_signed_id(object.picture)
  end

  def qr_code_file_name
    AttachmentHelper.attachment_file_name(object.picture)
  end

  def qr_code_data
    AttachmentHelper.attachment_data_string(object.picture)
  end

  def qr_code_location
    object.qr_code_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def group_name
    object.group.name
  end

  def is_attending
    scope&.dig(:current_user)&.is_attending?(object)
  end
end
