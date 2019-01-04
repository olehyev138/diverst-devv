module BaseGraph

  # BaseGraph jobs, purpose:
  #   - acts as a interface/front for BaseSearch
  #   - parses & formats data returned by BaseSearch for use by frontend

  # Todo:
  #  - add ability for sub aggs
  #  - implement parsing classes for use by frontend frameworks (NVD3/D3)

  def self.included(klass)
    klass.extend ClassMethods
    klass.extend Nvd3Formatter
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

      # Get data and format it for use by frontend frameworks
      return nvd3_format(
        params.dig(:graph, :title) || "Basic Graph",
        self.search(params))
    end
  end

  module Nvd3Formatter
    def nvd3_format(title, response)
      return {
        key: title,
        values: parse_es_response(response)
      }
    end

    def parse_es_response(buckets)
      buckets.map {|bucket|
        {
          label: bucket["key"],
          value: bucket["doc_count"]
        }
      }
    end
  end
end
