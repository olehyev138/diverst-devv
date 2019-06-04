class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :fields, :created_at,
             :updated_at, :enterprise_id, :sign_in_count, :enterprise,
             :last_sign_in_at, :linkedin_profile_url, :active, :biography, :points, :credits,
             :time_zone, :total_weekly_points, :user_role, :mentor, :mentee, :mentorship_description,
             :groups_notifications_frequency, :groups_notifications_date, :accepting_mentor_requests,
             :accepting_mentee_requests, :last_group_notification_date

  def enterprise
    EnterpriseSerializer.new(object.enterprise).attributes
  end

  def fields
    fields = object.enterprise.mobile_fields.map(&:field)
    fields_hash = []

    fields.each do |field|
      fields_hash << {
        title: field.title,
        value: field.string_value(object.info[field])
      }
    end

    fields_hash
  end

  def last_name
    "#{(object.last_name || '')[0].capitalize}."
  end
end
