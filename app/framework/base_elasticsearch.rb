module BaseElasticsearch
    
    def update_elasticsearch_index(action)
        #Elasticsearch::Index.new.delay(:queue => "elasticsearch").update_index(self.class.name, id, action)
    end
end