class UserSerializer < ApplicationRecordSerializer
  attributes :enterprise, :last_name, :user_groups, :user_role, :fields, :news_link_ids, :name,
             :last_initial, :timezones, :time_zone

  has_many :field_data

  # Serialize all user fields, including the custom attributes listed above, and excluding the `excluded_keys`
  def serialize_all_fields
    true
  end

  def avatar_location
    object.avatar_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
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
