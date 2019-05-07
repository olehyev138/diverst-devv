class IndexElasticsearchJob < ActiveJob::Base
  queue_as :default

  def perform(model_name:, operation:, record_id:)
    return if Rails.env.test?
    logger.debug [operation, "ID: #{record_id}"]
    model = model_name.constantize

    begin
      case operation
        when 'index'
          record = model.find_by_id(record_id)
          return if record.nil?
          record.__elasticsearch__.index_document
        when 'update'
          record = model.find_by_id(record_id)
          return if record.nil?
          record.__elasticsearch__.update_document

          # Updates child association indexes
          child_associations = record._reflections.map { |a, b| b.name if b.macro == :has_many && !b.options.key(:through) }.compact
          child_associations.each do |association|
            association_data = record.send(association)
            association_data.find_each do |item|
              break unless item.class.included_modules.include?(Elasticsearch::Model)
              item.__elasticsearch__.update_document
            end
          end
        when 'delete'
          client.delete index: model.index_name, id: record_id, type: model.__elasticsearch__.document_type, ignore: 404
        else raise ArgumentError, "Unknown operation '#{operation}'"
      end
    rescue => e
      Rollbar.error(e)
    end
  end

  def client
    Elasticsearch::Client.new host: ENV['ELASTICSEARCH_URL'], logger: logg
  end

  def logg
    Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  end
end
