class UserSerializer < ApplicationRecordSerializer
  attributes :last_name, :user_role, :name,
             :last_initial, :timezones, :time_zone, :avatar, :avatar_file_name, :avatar_data, :avatar_content_type,
             :permissions, :available_roles, :name_with_status

  attributes :field_data, :user_role, if: :show_action?

  # Serialize all user fields, including the custom attributes listed above, and excluding the `excluded_keys`
  def serialize_all_fields
    true
  end

  def field_data
    field_objects = if object.field_data.loaded?
                      object.field_data.select { |fd| !fd.field.private || (scope && UserPolicy.new(scope.dig(:current_user), User).manage?) }
                    elsif scope && UserPolicy.new(scope.dig(:current_user), User).manage?
                      object.field_data
                    else
                      object.field_data.includes(:field).where(fields: { private: false })
                    end
    field_objects.map do |field_datum|
      FieldDataSerializer.new(field_datum, **instance_options).as_json
    end
  end

  def avatar_location
    object.avatar_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def avatar
    AttachmentHelper.attachment_signed_id(object.avatar)
  end

  def avatar_file_name
    AttachmentHelper.attachment_file_name(object.avatar)
  end

  def avatar_data
    AttachmentHelper.attachment_data_string(object.avatar)
  end

  def avatar_content_type
    AttachmentHelper.attachment_content_type(object.avatar)
  end

  def excluded_keys
    [:password_digest]
  end

  # Custom attributes

  def enterprise
    EnterpriseSerializer.new(object.enterprise).attributes
  end

  def timezones
    ActiveSupport::TimeZone.all.map { |tz| [tz.tzinfo.name, "(GMT#{tz.formatted_offset(true, '')}) #{tz.name}"] }
  end

  def available_roles
    scope&.dig(:current_user)&.enterprise&.user_roles&.select { |role| ['user', 'admin'].include?(role.role_type) }
  end

  def time_zone
    tz = if object.time_zone
      ActiveSupport::TimeZone[ActiveSupport::TimeZone::MAPPING.key(object.time_zone)]
    else
      ActiveSupport::TimeZone[ActiveSupport::TimeZone::MAPPING.key(scope.dig(:current_user).enterprise.time_zone)]
    end
    "(GMT#{tz.formatted_offset(true, '')}) #{tz.name}"
  end

  def fields
    fields = object.enterprise.mobile_fields.map(&:field)
    fields_hash = []

    fields.each do |field|
      fields_hash << {
        title: field.title,
        value: field.string_value(object[field])
      }
    end

    fields_hash
  end
end
