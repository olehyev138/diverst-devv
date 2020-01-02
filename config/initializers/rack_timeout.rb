if Rails.env.development?
  Rack::Timeout.service_timeout = 0
  Rack::Timeout.wait_timeout = 0
  Rack::Timeout.wait_overtime = 0
else
  Rack::Timeout.service_timeout = 15
  Rack::Timeout.wait_timeout = 30
  Rack::Timeout.wait_overtime = 60
end
