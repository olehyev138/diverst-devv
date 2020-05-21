SanitizeEmail::Config.configure do |config|
  # run/call whatever logic should turn sanitize_email on and off in this Proc:
  config[:activation_proc] = Proc.new { ENV['REDIRECT_ALL_EMAILS_TO'].present? }
  config[:sanitized_to] = ENV['REDIRECT_ALL_EMAILS_TO']
  # config[:sanitized_cc] =         'cc@sanitize_email.org'
  # config[:sanitized_bcc] =        'bcc@sanitize_email.org'

  config[:use_actual_email_prepended_to_subject] = true         # or false
  config[:use_actual_environment_prepended_to_subject] = true   # or false
  config[:use_actual_email_as_sanitized_user_name] = true       # or false
end
