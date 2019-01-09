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
    def graph(query, type='nvd3', title='Basic Graph', drilldown=false)
      # Get data and format it for use by frontend frameworks
      response = self.search query

      return nvd3_format(title, type, response)
    end

    def drilldown(query, parent_field)
      # query           - initial query that gets all parents
      # parent_field    - field to use to filter parents on
      #
      # TODO:
      #  - make generic
      #  - seperate nvd3 specific formatting somehow

      buckets = self.search query

      data = {
        key: 'title',
        type: 'type',
        values: []
      }

      # cycle parent buckets
      buckets.each do |bucket|
        # build a query to get all child documents of current parent
        # filter documents on current parent name, then aggregate on child name
        children_query = self.get_query
          .aggregate(type='filter', field=parent_field, value=bucket[:key]) { |q|
            q.aggregate(type='terms', field='group.name').build
        }.build

        children_buckets = parse_es_response(self.search children_query)

        # overall data structure that will be passed to frontend
        data[:values] << {
          label: bucket[:key],        # bucket name
          value: bucket[:doc_count],  # member count
          children: {
            key: bucket[:key] + '_subgroups',
            values: children_buckets
          }
        }
      end
    end
  end

  module Nvd3Formatter
    # TODO:
    #  - move into a class
    #  - make better, support drilldowns
    def nvd3_format(title, type, response)
      return {
        key: title,
        type: type,
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
