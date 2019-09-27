# Use ISO 8601
Date::DATE_FORMATS[:default] = Date::DATE_FORMATS[:iso8601]
Time::DATE_FORMATS[:default] = Time::DATE_FORMATS[:iso8601]
ActiveSupport.use_standard_json_time_format = true

# Don't provide milliseconds
ActiveSupport::JSON::Encoding.time_precision = 0