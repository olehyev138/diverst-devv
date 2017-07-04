class LogCsv < Julia::Builder

  column :trackable_id

  column :trackable_type

  column 'action', :key

  column 'user_id', :owner_id

  column 'enterprise_id', :recipient_id

  column :created_at
end