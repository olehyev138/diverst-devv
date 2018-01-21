class IndexElasticsearchJob < ActiveJob::Base
  queue_as :default

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_URL'], logger: Logger

  def perform(model_name:, operation:, record_id:, index:)
    logger.debug [operation, "ID: #{record_id}"]
    model = model_name.constantize

    case operation
      when 'index'
        record = model.find_by_id(record_id)
        return if record.nil?
        record.__elasticsearch__.index_document(index: index)
      when 'update'
        record = model.find_by_id(record_id)
        return if record.nil?
        record.__elasticsearch__.update_document(index: index)
      when 'delete'
        Client.delete index: index, id: record_id, type: model_name.downcase
      else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
