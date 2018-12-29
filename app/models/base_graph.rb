module BaseGraph
    
    def self.included(klass)
        klass.extend ClassMethods
    end
    
    module ClassMethods
        
        def graph(params)
            # ex. params = {
            #   :graph = {
            #       type: "bar",
            #       title: "Group Population"
            #   }
            #   :search => {}   
            # }
            buckets = self.search(params)
            return {
                key: params.dig(:graph, :title) || "Basic Graph", 
                values: parse_buckets(buckets)
            }
        end
        
        def parse_buckets(buckets)
            buckets.map {|bucket|
                {
                    label: bucket["key"],
                    value: bucket["doc_count"]
                }
            }
        end
        
    end
end