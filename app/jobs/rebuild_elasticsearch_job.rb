class RebuildElasticsearchJob < ActiveJob::Base
  queue_as :default

  def perform
    client = Elasticsearch::Client.new host: host, user: user, password: password
    indices = client.cat.indices h: ['index'], format: 'json'
    indices = indices.map { |index| index['index'] }

    indices.each do |index|
      client.indices.delete index: index
    end

    import
  rescue
  end

  def import
    # needed for development environment
    Rails.application.eager_load!

    # get all the objects in our DB and import them
    models = ActiveRecord::Base.descendants

    models.each do |model|
      next if not model.respond_to? :__elasticsearch__
      next if model.__elasticsearch__.client.indices.exists? index: model.index_name

      # create the index
      model.__elasticsearch__.create_index!

      # import
      model.import
    end
  rescue
  end

  def host
    ENV['ELASTICSEARCH_HOST_URL'] || '0.0.0.0:9200'
  end

  def user
    ENV['ELASTICSEARCH_USER'] || ''
  end

  def password
    ENV['ELASTICSEARCH_PASSWORD'] || ''
  end
end
