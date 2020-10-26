class InvitedUserSerializer < ApplicationRecordSerializer
  attributes :email, :first_name, :biography,
             :last_name, :name, :last_initial, :timezones, :time_zone, :field_data

  attributes_with_permission :group_ids, :field_data, if: :with_associations?

  def with_associations?
    instance_options[:with_associations]
  end

  def field_data
    field_objects = if object.field_data.loaded?
      object.field_data.select { |fd| !fd.field.private || (scope.present? && UserPolicy.new(scope.dig(:current_user), User).manage?) }
    elsif scope.present? && UserPolicy.new(scope.dig(:current_user), User).manage?
      object.field_data
    else
      object.field_data.includes(:field).where(fields: { private: false })
    end
    field_objects.map do |field_datum|
      FieldDataSerializer.new(field_datum, **instance_options).as_json
    end
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

  def time_zone
    tz = ActiveSupport::TimeZone[ActiveSupport::TimeZone::MAPPING.key(object.time_zone)]
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
