config = {
  host: ENV['ELASTICSEARCH_URL'] || 'localhost:9200',
  transport_options: {
    request: { timeout: 5 }
  }
}

if File.exist?('log/elasticsearch.log')
  config[:logger] = Logger.new("#{Rails.root}/log/elasticsearch.log")
end

if File.exist?('config/elasticsearch.yml')
  config.merge!(YAML.load_file('config/elasticsearch.yml').symbolize_keys)
end

Elasticsearch::Model.client = Elasticsearch::Client.new(config)
