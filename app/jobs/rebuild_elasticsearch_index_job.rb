class RebuildElasticsearchIndexJob < ActiveJob::Base
  queue_as :default

  def perform(model_name:, enterprise:)
    model = model_name.constantize
    index = model.es_index_name(enterprise: enterprise)

    begin
      model.__elasticsearch__.client.indices.delete index: index
    rescue
      nil
    end

    model.__elasticsearch__.client.indices.create(
      index: index,
      body: {
        settings: model.settings.to_hash,
        mappings: model.custom_mapping.to_hash
      }
    )

    # We don't directly call model.import since activerecord-import overrides that
    model.__elasticsearch__.import(
      index: index,
      query: -> { model.es_index_for_enterprise(enterprise) }
    )
  end
end
