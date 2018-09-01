1.times do
  next unless %w[staging production].include?(Rails.env)

  hosts = [ENV.fetch('INFLUXDB_HOST', 'localhost')]
  rails_database = ENV.fetch('INFLUXDB_RAILS_DB', 'rails')
  sidekiq_database = ENV.fetch('INFLUXDB_SIDEKIQ_DB', 'sidekiq')
  app_name = [
    Rails.application.class.parent_name,
    Sidekiq.server? && 'Sidekiq'
  ].compact.join(' ')


  InfluxDB::Rails.configure do |config|
    config.influxdb_database = rails_database
    config.influxdb_username = nil
    config.influxdb_password = nil
    config.influxdb_hosts    = hosts
    config.influxdb_port     = 8086

    config.async = true

    config.application_name = hosts
  end

  Sidekiq.configure_server do |config|
    config.server_middleware do |chain|

      chain.add Sidekiq::Middleware::Server::InfluxDB,
                influxdb_client: InfluxDB::Client.new(sidekiq_database, hosts: hosts),
                series_name: 'sidekiq_jobs',
                retention_policy: nil,
                start_events: true,
                tags: { application: app_name, server: Socket.gethostname },
                except: []
    end
  end
end
