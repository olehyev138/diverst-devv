class RebuildElasticsearchIndexJob < ActiveJob::Base
  queue_as :default

  def perform(model_name)
    model = model_name.constantize

    begin
      model.__elasticsearch__.client.indices.delete index: model.__elasticsearch__.index_name
    rescue
      nil
    end

    begin
      model.__elasticsearch__.client.indices.create(
        body: {
          settings: model.settings.to_hash,
          mappings: model.custom_mapping.to_hash
        }
      )
    rescue
    end

    begin
      # We don't directly call model.import since activerecord-import overrides that
      model.__elasticsearch__.import
    rescue
    end
  end
end
