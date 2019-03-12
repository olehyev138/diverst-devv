class IndexElasticsearchJob < ActiveJob::Base
  queue_as :default

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_URL'], logger: Logger

  def perform(model_name:, operation:, record_id:)
    logger.debug [operation, "ID: #{record_id}"]
    return if Rails.env.test?
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
        when 'delete'
          Client.delete index: model.index_name, id: record_id, type: model.__elasticsearch__.document_type, ignore: 404
        else raise ArgumentError, "Unknown operation '#{operation}'"
      end
    rescue => e
      Rollbar.error(e)
    end
  end
end
