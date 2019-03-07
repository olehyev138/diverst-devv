module BaseElasticsearch

    def update_elasticsearch_index(action)
      IndexElasticsearchJob.perform_later(model_name: self.class.name, operation: action, record_id: id)
    end

    def update_elasticsearch_all_indexes
      RebuildElasticsearchIndexJob.perform_later('User')
    end
end
