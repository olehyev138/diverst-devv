module Indexable
  def update_elasticsearch_index(object, enterprise, action)
    begin
      IndexElasticsearchJob.perform_later(
        model_name: 'User',
        operation: action,
        index: User.es_index_name(enterprise: enterprise),
        record_id: object.id
      )
    rescue => e
      puts e.inspect
    end
  end

  def update_elasticsearch_all_indexes(enterprise)
    RebuildElasticsearchIndexJob.perform_later(model_name: 'User', enterprise: enterprise)
  end
end
