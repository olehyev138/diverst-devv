class LogCsv < Julia::Builder
  column 'user_id', :owner_id

  column :first_name do |activity|
    activity.owner.present? ? activity.owner.first_name : ''
  end

  column :last_name do |activity|
    activity.owner.present? ? activity.owner.last_name : ''
  end

  column :trackable_id

  column :trackable_type

  column 'action', :key

  column 'enterprise_id', :recipient_id

  column :created_at
end
