module BaseGraph
  # BaseGraph jobs, purpose:
  #   - acts as a interface/front for BaseSearch
  #   - parses & formats data returned by BaseSearch for use by frontend

  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def get_graph(query)
      GraphDataBuilder.new(query, self)
    end
  end

  class GraphDataBuilder
    def initialize(query, instance, title: 'Basic Graph', type: 'nvd3')
      @title = title
      @type = type

      @instance = instance
      @results = @instance.search(query)
      @formatter = Nvd3Formatter.new(title, type)

    end

    def graph
      @formatter.add_bucket_list(@results)

      self
    end

    def drilldown_graph(query:, parent_field:)
      # parent_field    - field to use to filter parents on

      # cycle parents
      @results.each do |parent|
        # build a query to get all child documents of current parent
        # filter documents on current parent name

        children_query = @instance.get_query
          .filter_agg(field: parent_field, value: parent[:key]) { |_| query }.build

        children = @instance.search(children_query)

        @formatter.add_bucket(parent, children=children)
      end

      self
    end

    def build
      @formatter.format
    end
  end

  class Nvd3Formatter
    # Format elasticsearch responses for the Nvd3 library

    def initialize(title, type)
      @data = {
        key: title,
        type: type,
        values: []
      }
    end

    def add_bucket(bucket, children=nil)
      parent = format_bucket(bucket)

      if children
        parent[:children] = {
          key: (bucket[:key] + '_subgroups').downcase,
          values: format_bucket_list(children)
        }
      end

        @data[:values] << parent
    end

    def add_bucket_list(buckets)
      @data[:values] << format_bucket_list(buckets)
    end

    def format
      @data
    end

    private

    def format_bucket_list(buckets)
      buckets.map { |bucket|
        format_bucket bucket
      }
    end

    def format_bucket(bucket)
      {
        label: bucket[:key],
        value: bucket[:doc_count],
        children: []
      }
    end
  end
end
