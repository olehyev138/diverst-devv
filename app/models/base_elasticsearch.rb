module BaseElasticsearch
    
    def update_elasticsearch_index(action)
        IndexElasticsearchJob.perform_later(self.class.name, id, action)
    end
    
end