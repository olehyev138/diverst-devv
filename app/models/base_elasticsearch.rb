module BaseElasticsearch
  def update_elasticsearch_index(action)
    IndexElasticsearchJob.perform_later(model_name: self.class.name, operation: action, record_id: id)
  end
end
