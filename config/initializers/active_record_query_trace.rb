if Rails.env.development?
  ActiveRecordQueryTrace.enabled = false
  # Optional: other gem config options go here
end
