module BaseGraph

  # BaseGraph jobs, purpose:
  #   - Acts as a interface/front for BaseSearch
  #   - Parses & formats data returned by BaseSearch for use by frontend

  # Todo:
  #  - Implement parsing classes for use by frontend frameworks (NVD3/D3)

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
