1.times do
  next unless %w[staging production].include?(Rails.env)

  hosts = [ENV.fetch('INFLUXDB_HOST', 'localhost')]
  database = ENV.fetch('INFLUXDB_DATABASE', 'rails')
  instance = ENV.fetch('INSTANCE', 'unknown')
  app_name = [
    Rails.application.class.parent_name,
    Sidekiq.server? && 'Sidekiq'
  ].compact.join(' ')


  InfluxDB::Rails.configure do |config|
    config.influxdb_database = database
    config.influxdb_username = nil
    config.influxdb_password = nil
    config.influxdb_hosts    = hosts
    config.influxdb_port     = 8086
    config.time_precision = 'ms'

    config.async = true

    config.application_name = app_name
    config.tags_middleware = lambda do |tags|
      tags.merge(domain: ENV['DOMAIN'], instance: instance)
    end
  end

  Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      chain.add Sidekiq::Middleware::Server::InfluxDB,
                influxdb_client: InfluxDB::Rails.client,
                series_name: 'sidekiq_jobs',
                retention_policy: nil,
                start_events: true,
                tags: {
                  application: app_name,
                  server: Socket.gethostname,
                  instance: instance,
                  domain: ENV['DOMAIN']
                },
                except: []
    end
  end
end
