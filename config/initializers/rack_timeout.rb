if Rails.env.development?
  Rack::Timeout.service_timeout = 0
  Rack::Timeout.wait_timeout = 0
  Rack::Timeout.wait_overtime = 0
end